using System.Collections.Concurrent;
using System.Globalization;
using System.Runtime.InteropServices;
using System.Threading;
using Microsoft.Office.Interop.Excel;

namespace DnaCalc.Research.ExcelRtdServer;

[ComVisible(true)]
[Guid("B8D5528C-16D5-4AF1-B22E-8687B13C1B6A")]
[ProgId("DnaCalc.Tools.RtdServer")]
[ClassInterface(ClassInterfaceType.None)]
public sealed class DnaRtdServer : IRtdServer
{
    private sealed class TopicState
    {
        public int TopicId { get; set; }
        public string[] Args { get; set; } = Array.Empty<string>();
        public string Key { get; set; } = string.Empty;
        public object? Value { get; set; }
        public bool Dirty { get; set; }
    }

    private readonly object _gate = new();
    private readonly ConcurrentDictionary<int, TopicState> _topics = new();
    private IRTDUpdateEvent? _callback;
    private Timer? _timer;
    private int _ticks;
    private int _pulse;

    public int ServerStart(IRTDUpdateEvent callbackObject)
    {
        lock (_gate)
        {
            _callback = callbackObject;
            try
            {
                _callback.HeartbeatInterval = 2;
            }
            catch
            {
                // Some hosts can reject this set; server remains usable.
            }

            _timer?.Dispose();
            _timer = new Timer(OnTick, null, TimeSpan.FromMilliseconds(250), TimeSpan.FromSeconds(1));
        }

        return 1;
    }

    public object ConnectData(int topicId, ref Array strings, ref bool newValues)
    {
        var args = ReadTopicArgs(strings);
        var key = string.Join("|", args.Select(a => a.Trim()), StringComparer.OrdinalIgnoreCase);
        var topic = new TopicState
        {
            TopicId = topicId,
            Args = args,
            Key = key,
            Value = EvaluateTopic(args),
            Dirty = true
        };
        _topics[topicId] = topic;
        newValues = true;
        return topic.Value ?? string.Empty;
    }

    public Array RefreshData(ref int topicCount)
    {
        var dirty = _topics.Values
            .Where(t => t.Dirty)
            .OrderBy(t => t.TopicId)
            .ToArray();

        topicCount = dirty.Length;
        var payload = Array.CreateInstance(typeof(object), 2, Math.Max(topicCount, 1));
        if (topicCount == 0)
        {
            payload.SetValue(0, 0, 0);
            payload.SetValue(string.Empty, 1, 0);
            return payload;
        }

        for (var i = 0; i < dirty.Length; i++)
        {
            payload.SetValue(dirty[i].TopicId, 0, i);
            payload.SetValue(dirty[i].Value ?? string.Empty, 1, i);
            dirty[i].Dirty = false;
        }

        return payload;
    }

    public void DisconnectData(int topicId)
    {
        _topics.TryRemove(topicId, out _);
    }

    public int Heartbeat() => 1;

    public void ServerTerminate()
    {
        lock (_gate)
        {
            _timer?.Dispose();
            _timer = null;
            _topics.Clear();
            _callback = null;
        }
    }

    private void OnTick(object? _)
    {
        Interlocked.Increment(ref _ticks);
        _pulse = _pulse == 0 ? 1 : 0;

        var changed = false;
        foreach (var topic in _topics.Values)
        {
            var next = EvaluateTopic(topic.Args);
            if (!Equals(topic.Value, next))
            {
                topic.Value = next;
                topic.Dirty = true;
                changed = true;
            }
        }

        if (!changed)
        {
            return;
        }

        try
        {
            _callback?.UpdateNotify();
        }
        catch
        {
            // Host may disconnect callback transiently; continue serving.
        }
    }

    private object EvaluateTopic(string[] args)
    {
        if (args.Length == 0)
        {
            return string.Empty;
        }

        var kind = args[0].Trim().ToUpperInvariant();
        return kind switch
        {
            "TIME" => DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff", CultureInfo.InvariantCulture),
            "TICKS" => Volatile.Read(ref _ticks),
            "PULSE" => _pulse,
            "ECHO" => args.Length >= 2 ? args[1] : string.Empty,
            _ => string.Join(":", args)
        };
    }

    private static string[] ReadTopicArgs(Array strings)
    {
        var values = new List<string>();
        foreach (var item in strings)
        {
            values.Add(Convert.ToString(item, CultureInfo.InvariantCulture) ?? string.Empty);
        }
        return values.ToArray();
    }
}
