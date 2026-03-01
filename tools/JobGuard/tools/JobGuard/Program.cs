using System.ComponentModel;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Text;
using Microsoft.Win32.SafeHandles;
using System.Management;

// JobGuard: create a Windows Job object, run a root process inside it, optionally assign
// additional PIDs (e.g., COM-activated Excel) into the same Job, and rely on
// JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE to guarantee cleanup.
//
// This is intentionally minimal: it is a local repo tool to prevent stray Excel/dotnet/cdb
// processes from holding file locks or lingering across failed runs.

static class Program
{
    public static int Main(string[] args)
    {
        try
        {
            // `dotnet <tool> -- <args...>` will pass a leading "--" through to the tool.
            if (args.Length > 0 && args[0] == "--")
            {
                args = args.Skip(1).ToArray();
            }

            if (args.Length == 0 || args[0] is "-h" or "--help" or "help")
            {
                PrintHelp();
                return 0;
            }

            var cmd = args[0];
            var rest = args.Skip(1).ToArray();

            return cmd switch
            {
                "run" => Run(rest),
                "assign" => Assign(rest),
                _ => Fail($"Unknown command '{cmd}'.")
            };
        }
        catch (Exception ex)
        {
            Console.Error.WriteLine(ex.ToString());
            return 1;
        }
    }

    static void PrintHelp()
    {
        Console.WriteLine(
            """
            JobGuard (local tool)

            Usage:
              jobguard run [options] -- <command> [args...]
              jobguard assign [options] --pid <pid>

            run options:
              --job-name <name>                Optional. Named job (useful for debugging).
              --no-kill-on-close               Do not set KILL_ON_JOB_CLOSE.
              --breakaway-from-parent-job      Create the root process with CREATE_BREAKAWAY_FROM_JOB (best-effort).
              --assign-pid-file <path>         Optional. Wait for <path>, read PID, assign that process to the job.
              --assign-timeout-ms <ms>         Default: 60000.
              --require-exe-contains <text>    Optional. Before assigning PID from file, require ExecutablePath contains this substring.
              --require-cmdline-contains <text> Optional. Before assigning PID from file, require CommandLine contains this substring.
              --verbose                        Extra logs.

            assign options:
              --job-name <name>                Required. Open existing job by name (or create if missing).
              --pid <pid>                      Required.
              --require-exe-contains <text>    Optional safety check.
              --require-cmdline-contains <text> Optional safety check.
              --verbose                        Extra logs.

            Notes:
            - Assigning the COM-activated Excel process by PID is the expected pattern. Excel is often not a child
              of the runner process, so it won't automatically be in the Job unless explicitly assigned.
            - Safety: use the require-* filters when you might have other Excel instances on the machine.
            """);
    }

    static int Fail(string message)
    {
        Console.Error.WriteLine(message);
        return 1;
    }

    sealed class SafeWin32Handle : SafeHandleZeroOrMinusOneIsInvalid
    {
        public SafeWin32Handle() : base(ownsHandle: true) { }
        public SafeWin32Handle(nint handle) : base(ownsHandle: true) => SetHandle(handle);
        protected override bool ReleaseHandle() => CloseHandle(handle);
    }

    static int Run(string[] args)
    {
        // Parse options until "--".
        var jobName = (string?)null;
        var killOnClose = true;
        var breakawayFromParentJob = false;
        var assignPidFile = (string?)null;
        var assignTimeoutMs = 60_000;
        var requireExeContains = (string?)null;
        var requireCmdlineContains = (string?)null;
        var verbose = false;

        var idx = 0;
        for (; idx < args.Length; idx++)
        {
            var a = args[idx];
            if (a == "--")
            {
                idx++;
                break;
            }

            switch (a)
            {
                case "--job-name":
                    jobName = RequireValue(args, ref idx, "--job-name");
                    break;
                case "--no-kill-on-close":
                    killOnClose = false;
                    break;
                case "--breakaway-from-parent-job":
                    breakawayFromParentJob = true;
                    break;
                case "--assign-pid-file":
                    assignPidFile = RequireValue(args, ref idx, "--assign-pid-file");
                    break;
                case "--assign-timeout-ms":
                    assignTimeoutMs = int.Parse(RequireValue(args, ref idx, "--assign-timeout-ms"));
                    break;
                case "--require-exe-contains":
                    requireExeContains = RequireValue(args, ref idx, "--require-exe-contains");
                    break;
                case "--require-cmdline-contains":
                    requireCmdlineContains = RequireValue(args, ref idx, "--require-cmdline-contains");
                    break;
                case "--verbose":
                    verbose = true;
                    break;
                default:
                    return Fail($"Unknown option '{a}' for 'run'.");
            }
        }

        if (idx >= args.Length)
        {
            return Fail("Missing command. Use: jobguard run [options] -- <command> [args...]");
        }

        var cmdArgs = args.Skip(idx).ToArray();
        if (cmdArgs.Length == 0)
        {
            return Fail("Missing command after '--'.");
        }

        using var job = CreateOrOpenJob(jobName, killOnClose, verbose);
        var jobCreationUtc = DateTime.UtcNow;

        if (verbose)
        {
            Console.WriteLine($"[jobguard] Job: {(string.IsNullOrWhiteSpace(jobName) ? "(unnamed)" : jobName)} kill_on_close={killOnClose}");
        }

        var creationFlags = CREATE_SUSPENDED | (breakawayFromParentJob ? CREATE_BREAKAWAY_FROM_JOB : 0);
        var created = CreateProcessSuspended(cmdArgs, creationFlags, verbose);
        using var hProcess = new SafeWin32Handle(created.hProcess);
        using var hThread = new SafeWin32Handle(created.hThread);

        EnsureAssignedToJob(job, hProcess, pid: (int)created.dwProcessId, verbose, context: "root");

        if (ResumeThread(hThread.DangerousGetHandle()) == unchecked((uint)-1))
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "ResumeThread failed");
        }

        if (verbose)
        {
            Console.WriteLine($"[jobguard] Root PID: {created.dwProcessId}");
        }

        if (!string.IsNullOrWhiteSpace(assignPidFile))
        {
            var pid = WaitForPidFile(assignPidFile!, assignTimeoutMs, requireWriteAfterUtc: jobCreationUtc - TimeSpan.FromSeconds(5));
            if (verbose)
            {
                Console.WriteLine($"[jobguard] PID file '{assignPidFile}' => {pid}");
            }

            AssignByPid(
                job,
                pid,
                requireExeContains,
                requireCmdlineContains,
                verbose,
                // Extra safety: require process started after job creation (helps avoid grabbing existing Excel instances).
                requireStartedAfterUtc: jobCreationUtc - TimeSpan.FromSeconds(5));
        }

        // Wait for root to exit; then exit (closing Job handle may kill any stragglers in the Job).
        if (WaitForSingleObject(hProcess.DangerousGetHandle(), INFINITE) != WAIT_OBJECT_0)
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "WaitForSingleObject(root) failed");
        }

        var exitCode = GetExitCode(hProcess);
        if (verbose)
        {
            Console.WriteLine($"[jobguard] Root exit code: {exitCode}");
        }

        return exitCode;
    }

    static int Assign(string[] args)
    {
        var jobName = (string?)null;
        var pid = (int?)null;
        var requireExeContains = (string?)null;
        var requireCmdlineContains = (string?)null;
        var verbose = false;

        for (var i = 0; i < args.Length; i++)
        {
            var a = args[i];
            switch (a)
            {
                case "--job-name":
                    jobName = RequireValue(args, ref i, "--job-name");
                    break;
                case "--pid":
                    pid = int.Parse(RequireValue(args, ref i, "--pid"));
                    break;
                case "--require-exe-contains":
                    requireExeContains = RequireValue(args, ref i, "--require-exe-contains");
                    break;
                case "--require-cmdline-contains":
                    requireCmdlineContains = RequireValue(args, ref i, "--require-cmdline-contains");
                    break;
                case "--verbose":
                    verbose = true;
                    break;
                default:
                    return Fail($"Unknown option '{a}' for 'assign'.");
            }
        }

        if (string.IsNullOrWhiteSpace(jobName))
        {
            return Fail("assign requires --job-name <name>.");
        }
        if (pid is null)
        {
            return Fail("assign requires --pid <pid>.");
        }

        using var job = CreateOrOpenJob(jobName, killOnClose: true, verbose);
        AssignByPid(job, pid.Value, requireExeContains, requireCmdlineContains, verbose, requireStartedAfterUtc: null);
        return 0;
    }

    static string RequireValue(string[] args, ref int i, string opt)
    {
        if (i + 1 >= args.Length)
        {
            throw new ArgumentException($"Missing value for {opt}");
        }
        i++;
        return args[i];
    }

    static SafeWin32Handle CreateOrOpenJob(string? jobName, bool killOnClose, bool verbose)
    {
        var hJob = CreateJobObjectW(lpJobAttributes: nint.Zero, lpName: jobName);
        if (hJob == nint.Zero)
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "CreateJobObjectW failed");
        }

        var job = new SafeWin32Handle(hJob);

        if (killOnClose)
        {
            var info = new JOBOBJECT_EXTENDED_LIMIT_INFORMATION
            {
                BasicLimitInformation = new JOBOBJECT_BASIC_LIMIT_INFORMATION
                {
                    LimitFlags = JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE
                }
            };

            if (!SetInformationJobObject(job, JobObjectInfoClass.JobObjectExtendedLimitInformation, ref info))
            {
                throw new Win32Exception(Marshal.GetLastWin32Error(), "SetInformationJobObject(KILL_ON_JOB_CLOSE) failed");
            }
        }

        if (verbose)
        {
            var lastError = Marshal.GetLastWin32Error();
            if (!string.IsNullOrWhiteSpace(jobName) && lastError == ERROR_ALREADY_EXISTS)
            {
                Console.WriteLine($"[jobguard] Opened existing job '{jobName}'.");
            }
        }

        return job;
    }

    static void AssignByPid(
        SafeWin32Handle job,
        int pid,
        string? requireExeContains,
        string? requireCmdlineContains,
        bool verbose,
        DateTime? requireStartedAfterUtc)
    {
        using var h = OpenProcessForJobAssignment(pid);
        if (h.IsInvalid)
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), $"OpenProcess({pid}) failed");
        }

        var snap = GetProcessSnapshot(pid);
        if (snap is null)
        {
            throw new InvalidOperationException($"Failed to snapshot PID {pid} via WMI/CIM (process disappeared?).");
        }

        if (!string.IsNullOrWhiteSpace(requireExeContains) &&
            (snap.ExecutablePath is null || !snap.ExecutablePath.Contains(requireExeContains, StringComparison.OrdinalIgnoreCase)))
        {
            throw new InvalidOperationException($"Refusing to assign PID {pid}: ExecutablePath does not contain '{requireExeContains}'. Actual: '{snap.ExecutablePath}'");
        }

        if (!string.IsNullOrWhiteSpace(requireCmdlineContains) &&
            (snap.CommandLine is null || !snap.CommandLine.Contains(requireCmdlineContains, StringComparison.OrdinalIgnoreCase)))
        {
            throw new InvalidOperationException($"Refusing to assign PID {pid}: CommandLine does not contain '{requireCmdlineContains}'. Actual: '{snap.CommandLine}'");
        }

        if (requireStartedAfterUtc is not null)
        {
            var creation = GetProcessCreationTimeUtc(h);
            if (creation < requireStartedAfterUtc.Value)
            {
                throw new InvalidOperationException($"Refusing to assign PID {pid}: CreationTimeUtc {creation:o} < required {requireStartedAfterUtc:o} (likely PID reuse or pre-existing instance).");
            }
        }

        if (verbose)
        {
            Console.WriteLine($"[jobguard] Assign PID {pid}: {snap.Name}");
            Console.WriteLine($"[jobguard]   Exe: {snap.ExecutablePath}");
            Console.WriteLine($"[jobguard]   Cmd: {snap.CommandLine}");
        }

        EnsureAssignedToJob(job, h, pid, verbose, context: "assign");
    }

    static SafeWin32Handle OpenProcessForJobAssignment(int pid)
    {
        const uint access =
            PROCESS_QUERY_LIMITED_INFORMATION |
            PROCESS_SET_QUOTA |
            PROCESS_TERMINATE;

        return new SafeWin32Handle(OpenProcess(access, bInheritHandle: false, (uint)pid));
    }

    static int WaitForPidFile(string path, int timeoutMs, DateTime? requireWriteAfterUtc)
    {
        var sw = Stopwatch.StartNew();
        while (sw.ElapsedMilliseconds < timeoutMs)
        {
            if (File.Exists(path))
            {
                if (requireWriteAfterUtc is not null)
                {
                    try
                    {
                        var lastWrite = File.GetLastWriteTimeUtc(path);
                        if (lastWrite < requireWriteAfterUtc.Value)
                        {
                            // Stale PID file from a previous run; keep waiting.
                            Thread.Sleep(100);
                            continue;
                        }
                    }
                    catch
                    {
                        // If we can't stat the file, just fall back to reading it.
                    }
                }

                var txt = File.ReadAllText(path).Trim();
                if (int.TryParse(txt, out var pid) && pid > 0)
                {
                    return pid;
                }

                // File exists but isn't ready; keep polling briefly.
            }

            Thread.Sleep(100);
        }

        throw new TimeoutException($"Timed out waiting for PID file: {path}");
    }

    static int GetExitCode(SafeWin32Handle hProcess)
    {
        if (!GetExitCodeProcess(hProcess.DangerousGetHandle(), out var code))
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "GetExitCodeProcess failed");
        }
        return unchecked((int)code);
    }

    static DateTime GetProcessCreationTimeUtc(SafeWin32Handle hProcess)
    {
        if (!GetProcessTimes(
                hProcess.DangerousGetHandle(),
                out var ftCreation,
                out _,
                out _,
                out _))
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "GetProcessTimes failed");
        }

        var creation = FileTimeToDateTimeUtc(ftCreation);
        return creation;
    }

    static DateTime FileTimeToDateTimeUtc(FILETIME ft)
    {
        long fileTime = ((long)ft.dwHighDateTime << 32) | (uint)ft.dwLowDateTime;
        return DateTime.FromFileTimeUtc(fileTime);
    }

    static PROCESS_INFORMATION CreateProcessSuspended(string[] cmdArgs, uint creationFlags, bool verbose)
    {
        var commandLine = BuildWindowsCommandLine(cmdArgs);
        if (verbose)
        {
            Console.WriteLine($"[jobguard] CreateProcess: {commandLine}");
        }

        var si = new STARTUPINFOW();
        si.cb = (uint)Marshal.SizeOf<STARTUPINFOW>();

        if (!CreateProcessW(
                lpApplicationName: null,
                lpCommandLine: commandLine,
                lpProcessAttributes: nint.Zero,
                lpThreadAttributes: nint.Zero,
                bInheritHandles: false,
                dwCreationFlags: creationFlags,
                lpEnvironment: nint.Zero,
                lpCurrentDirectory: null,
                lpStartupInfo: ref si,
                lpProcessInformation: out var pi))
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "CreateProcessW failed");
        }

        return pi;
    }

    static void EnsureAssignedToJob(SafeWin32Handle job, SafeWin32Handle process, int pid, bool verbose, string context)
    {
        if (AssignProcessToJobObject(job, process))
        {
            return;
        }

        var err = Marshal.GetLastWin32Error();
        var inJob = TryIsProcessInAnyJob(process);
        var inJobText = inJob?.ToString() ?? "unknown";

        var extra = "";
        if (err == ERROR_ACCESS_DENIED && inJob == true)
        {
            // Common cases:
            // - The target process is already in a Job and the system cannot form a valid job hierarchy.
            // - The target process is in a different parent job than another process already assigned to this Job.
            // - Running on pre-Windows 8 semantics (single job association).
            extra =
                " Target process appears to already be in a Job; this can make assignment fail. " +
                "If you are grouping multiple processes, they may already be in different parent jobs. " +
                "Try: run the root process with --breakaway-from-parent-job, or avoid assigning processes that are already job-contained.";
        }
        else if (err == ERROR_ACCESS_DENIED && inJob == false)
        {
            extra = " Access denied. You may need elevated permissions to open/assign this process.";
        }

        if (verbose)
        {
            Console.WriteLine($"[jobguard] Assign failure ({context}) pid={pid} err={err} in_job={inJobText}");
        }

        throw new Win32Exception(err, $"AssignProcessToJobObject({context}:{pid}) failed (in_job={inJobText}).{extra}");
    }

    static bool? TryIsProcessInAnyJob(SafeWin32Handle process)
    {
        try
        {
            if (!IsProcessInJob(process.DangerousGetHandle(), hJob: nint.Zero, out var inJob))
            {
                return null;
            }

            return inJob;
        }
        catch
        {
            return null;
        }
    }

    static string BuildWindowsCommandLine(string[] args)
    {
        // Approximate CommandLineToArgvW escaping rules.
        // Good enough for our usage (paths + simple args). If this becomes a source of flakiness,
        // we should switch to passing lpApplicationName explicitly and quote only arguments.
        var sb = new StringBuilder();
        for (var i = 0; i < args.Length; i++)
        {
            if (i > 0) sb.Append(' ');
            sb.Append(QuoteWindowsArg(args[i]));
        }
        return sb.ToString();
    }

    static string QuoteWindowsArg(string arg)
    {
        if (arg.Length == 0)
        {
            return "\"\"";
        }

        var needsQuotes = arg.Any(ch => ch is ' ' or '\t' or '\n' or '\v' or '"');
        if (!needsQuotes)
        {
            return arg;
        }

        var sb = new StringBuilder();
        sb.Append('"');

        var backslashes = 0;
        foreach (var ch in arg)
        {
            if (ch == '\\')
            {
                backslashes++;
                continue;
            }

            if (ch == '"')
            {
                // Escape backslashes, then the quote.
                sb.Append('\\', backslashes * 2 + 1);
                sb.Append('"');
                backslashes = 0;
                continue;
            }

            if (backslashes > 0)
            {
                sb.Append('\\', backslashes);
                backslashes = 0;
            }

            sb.Append(ch);
        }

        if (backslashes > 0)
        {
            // Escape trailing backslashes before closing quote.
            sb.Append('\\', backslashes * 2);
        }

        sb.Append('"');
        return sb.ToString();
    }

    sealed record ProcessSnapshot(
        int ProcessId,
        string Name,
        string? ExecutablePath,
        string? CommandLine);

    static ProcessSnapshot? GetProcessSnapshot(int pid)
    {
        try
        {
            using var searcher = new ManagementObjectSearcher(
                $"SELECT ProcessId, Name, ExecutablePath, CommandLine FROM Win32_Process WHERE ProcessId={pid}");
            using var results = searcher.Get();
            foreach (ManagementObject obj in results)
            {
                var name = (string?)obj["Name"] ?? "";
                var exe = (string?)obj["ExecutablePath"];
                var cmd = (string?)obj["CommandLine"];
                return new ProcessSnapshot(pid, name, exe, cmd);
            }
        }
        catch
        {
            // Fall back to minimal info.
        }

        try
        {
            using var p = Process.GetProcessById(pid);
            return new ProcessSnapshot(pid, p.ProcessName, ExecutablePath: null, CommandLine: null);
        }
        catch
        {
            return null;
        }
    }

    // Win32 interop
    const uint PROCESS_QUERY_LIMITED_INFORMATION = 0x1000;
    const uint PROCESS_SET_QUOTA = 0x0100;
    const uint PROCESS_TERMINATE = 0x0001;

    const uint CREATE_SUSPENDED = 0x00000004;
    const uint CREATE_BREAKAWAY_FROM_JOB = 0x01000000;

    const uint JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE = 0x00002000;

    const uint INFINITE = 0xFFFFFFFF;
    const uint WAIT_OBJECT_0 = 0x00000000;

    const int ERROR_ALREADY_EXISTS = 183;
    const int ERROR_ACCESS_DENIED = 5;

    enum JobObjectInfoClass
    {
        JobObjectExtendedLimitInformation = 9
    }

    [StructLayout(LayoutKind.Sequential)]
    struct FILETIME
    {
        public uint dwLowDateTime;
        public uint dwHighDateTime;
    }

    [StructLayout(LayoutKind.Sequential)]
    struct JOBOBJECT_BASIC_LIMIT_INFORMATION
    {
        public long PerProcessUserTimeLimit;
        public long PerJobUserTimeLimit;
        public uint LimitFlags;
        public nuint MinimumWorkingSetSize;
        public nuint MaximumWorkingSetSize;
        public uint ActiveProcessLimit;
        public nuint Affinity;
        public uint PriorityClass;
        public uint SchedulingClass;
    }

    [StructLayout(LayoutKind.Sequential)]
    struct IO_COUNTERS
    {
        public ulong ReadOperationCount;
        public ulong WriteOperationCount;
        public ulong OtherOperationCount;
        public ulong ReadTransferCount;
        public ulong WriteTransferCount;
        public ulong OtherTransferCount;
    }

    [StructLayout(LayoutKind.Sequential)]
    struct JOBOBJECT_EXTENDED_LIMIT_INFORMATION
    {
        public JOBOBJECT_BASIC_LIMIT_INFORMATION BasicLimitInformation;
        public IO_COUNTERS IoInfo;
        public nuint ProcessMemoryLimit;
        public nuint JobMemoryLimit;
        public nuint PeakProcessMemoryUsed;
        public nuint PeakJobMemoryUsed;
    }

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    struct STARTUPINFOW
    {
        public uint cb;
        public string? lpReserved;
        public string? lpDesktop;
        public string? lpTitle;
        public uint dwX;
        public uint dwY;
        public uint dwXSize;
        public uint dwYSize;
        public uint dwXCountChars;
        public uint dwYCountChars;
        public uint dwFillAttribute;
        public uint dwFlags;
        public ushort wShowWindow;
        public ushort cbReserved2;
        public nint lpReserved2;
        public nint hStdInput;
        public nint hStdOutput;
        public nint hStdError;
    }

    [StructLayout(LayoutKind.Sequential)]
    struct PROCESS_INFORMATION
    {
        public nint hProcess;
        public nint hThread;
        public uint dwProcessId;
        public uint dwThreadId;
    }

    [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
    static extern nint CreateJobObjectW(nint lpJobAttributes, string? lpName);

    [DllImport("kernel32.dll", SetLastError = true)]
    static extern bool SetInformationJobObject(SafeWin32Handle hJob, JobObjectInfoClass infoClass, ref JOBOBJECT_EXTENDED_LIMIT_INFORMATION lpJobObjectInfo, uint cbJobObjectInfoLength);

    static bool SetInformationJobObject(SafeWin32Handle job, JobObjectInfoClass infoClass, ref JOBOBJECT_EXTENDED_LIMIT_INFORMATION info)
    {
        return SetInformationJobObject(job, infoClass, ref info, (uint)Marshal.SizeOf<JOBOBJECT_EXTENDED_LIMIT_INFORMATION>());
    }

    [DllImport("kernel32.dll", SetLastError = true)]
    static extern bool AssignProcessToJobObject(SafeWin32Handle hJob, SafeWin32Handle hProcess);

    [DllImport("kernel32.dll", SetLastError = true)]
    static extern bool IsProcessInJob(nint hProcess, nint hJob, out bool result);

    [DllImport("kernel32.dll", SetLastError = true)]
    static extern nint OpenProcess(uint dwDesiredAccess, bool bInheritHandle, uint dwProcessId);

    [DllImport("kernel32.dll", SetLastError = true)]
    static extern bool CloseHandle(nint hObject);

    [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
    static extern bool CreateProcessW(
        string? lpApplicationName,
        string lpCommandLine,
        nint lpProcessAttributes,
        nint lpThreadAttributes,
        bool bInheritHandles,
        uint dwCreationFlags,
        nint lpEnvironment,
        string? lpCurrentDirectory,
        ref STARTUPINFOW lpStartupInfo,
        out PROCESS_INFORMATION lpProcessInformation);

    [DllImport("kernel32.dll", SetLastError = true)]
    static extern uint ResumeThread(nint hThread);

    [DllImport("kernel32.dll", SetLastError = true)]
    static extern uint WaitForSingleObject(nint hHandle, uint dwMilliseconds);

    [DllImport("kernel32.dll", SetLastError = true)]
    static extern bool GetExitCodeProcess(nint hProcess, out uint lpExitCode);

    [DllImport("kernel32.dll", SetLastError = true)]
    static extern bool GetProcessTimes(nint hProcess, out FILETIME creationTime, out FILETIME exitTime, out FILETIME kernelTime, out FILETIME userTime);

    [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
    static extern bool QueryFullProcessImageNameW(nint hProcess, uint dwFlags, StringBuilder lpExeName, ref uint lpdwSize);
}
