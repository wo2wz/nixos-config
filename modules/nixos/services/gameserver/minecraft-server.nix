{ inputs, config, pkgs, lib, ... }:


{
  users = {
    users.minecraft = {
      group = "minecraft";
      isSystemUser = true;

      home = "/var/lib/minecraft";
      createHome = true;
    };
    groups.minecraft = {};
  };

  environment.etc."minecraft/java21_args".text = ''
    --add-modules=jdk.incubator.vector
    -XX:+UseG1GC
    -XX:MaxGCPauseMillis=200
    -XX:+UnlockExperimentalVMOptions
    -XX:+UnlockDiagnosticVMOptions
    -XX:+DisableExplicitGC
    -XX:+AlwaysPreTouch
    -XX:G1NewSizePercent=28
    -XX:G1MaxNewSizePercent=50
    -XX:G1HeapRegionSize=16M
    -XX:G1ReservePercent=15
    -XX:G1MixedGCCountTarget=3
    -XX:InitiatingHeapOccupancyPercent=20
    -XX:G1MixedGCLiveThresholdPercent=90
    -XX:SurvivorRatio=32
    -XX:G1HeapWastePercent=5
    -XX:MaxTenuringThreshold=1
    -XX:+PerfDisableSharedMem
    -XX:G1SATBBufferEnqueueingThresholdPercent=30
    -XX:G1ConcMarkStepDurationMillis=5
    -XX:G1RSetUpdatingPauseTimePercent=0
    -XX:+UseNUMA
    -XX:-DontCompileHugeMethods
    -XX:MaxNodeLimit=240000
    -XX:NodeLimitFudgeFactor=8000
    -XX:ReservedCodeCacheSize=400M
    -XX:NonNMethodCodeHeapSize=12M
    -XX:ProfiledCodeHeapSize=194M
    -XX:NonProfiledCodeHeapSize=194M
    -XX:NmethodSweepActivity=1
    -XX:+UseFastUnorderedTimeStamps
    -XX:+UseCriticalJavaThreadPriority
    -XX:AllocatePrefetchStyle=3
    -XX:+AlwaysActAsServerClassMachine
    -XX:+UseTransparentHugePages
    -XX:LargePageSizeInBytes=2M
    -XX:+UseLargePages
    -XX:+EagerJVMCI
    -XX:+UseStringDeduplication
    -XX:+UseAES
    -XX:+UseAESIntrinsics
    -XX:+UseFMA
    -XX:+UseLoopPredicate
    -XX:+RangeCheckElimination
    -XX:+OptimizeStringConcat
    -XX:+UseCompressedOops
    -XX:+UseThreadPriorities
    -XX:+OmitStackTraceInFastThrow
    -XX:+RewriteBytecodes
    -XX:+RewriteFrequentPairs
    -XX:+UseFPUForSpilling
    -XX:+UseFastStosb
    -XX:+UseNewLongLShift
    -XX:+UseVectorCmov
    -XX:+UseXMMForArrayCopy
    -XX:+UseXmmI2D
    -XX:+UseXmmI2F
    -XX:+UseXmmLoadAndClearUpper
    -XX:+UseXmmRegToRegMoveAll
    -XX:+EliminateLocks
    -XX:+DoEscapeAnalysis
    -XX:+AlignVector
    -XX:+OptimizeFill
    -XX:+EnableVectorSupport
    -XX:+UseCharacterCompareIntrinsics
    -XX:+UseCopySignIntrinsic
    -XX:+UseVectorStubs
    -XX:UseAVX=2
    -XX:UseSSE=4
    -XX:+UseFastJNIAccessors
    -XX:+UseInlineCaches
    -XX:+SegmentedCodeCache
    -Djdk.nio.maxCachedBufferSize=262144
    -Djdk.graal.UsePriorityInlining=true
    -Djdk.graal.Vectorization=true
    -Djdk.graal.OptDuplication=true
    -Djdk.graal.DetectInvertedLoopsAsCounted=true
    -Djdk.graal.LoopInversion=true
    -Djdk.graal.VectorizeHashes=true
    -Djdk.graal.EnterprisePartialUnroll=true
    -Djdk.graal.VectorizeSIMD=true
    -Djdk.graal.StripMineNonCountedLoops=true
    -Djdk.graal.SpeculativeGuardMovement=true
    -Djdk.graal.TuneInlinerExploration=1
    -Djdk.graal.LoopRotation=true
    -Djdk.graal.CompilerConfiguration=enterprise
  '';

  systemd = {
    targets.multi-user.wants = [
      "minecraft@countries.service"
      "minecraft@monifactory.service"
    ];

    sockets."minecraft@" = {
      partOf = [ "minecraft@%i.service" ];
      socketConfig = {
        SocketUser = "minecraft";
        SocketGroup = "minecraft";
        SocketMode = "0600";

        ListenFIFO = "%t/minecraft-%i.stdin";
        RemoveOnStop = true;
      };
    };

    services."minecraft@" = {
      description = "Minecraft Java Edition server for %i";
      wants = [ "network-online.target" "velocity.service" ];
      after = [ "network-online.target" "velocity.service" ];

      environment = {
        JAVA_17_PATH = lib.getExe pkgs.graalvmPackages.graalvm-oracle_17;
        JAVA_21_PATH = lib.getExe inputs.nixpkgs-pin.legacyPackages.${pkgs.stdenv.hostPlatform.system}.graalvm-ce;
      };

      serviceConfig = {
        User = "minecraft";
        Group = "minecraft";
        StateDirectory = "minecraft/%i";
        StateDirectoryMode = "0700";
        WorkingDirectory = "%S/minecraft/%i";

        ExecStart = "${lib.getExe pkgs.bash} run.sh";

        Type = "exec";
        Restart = "always";
        # minecraft responds to SIGINT to stop the server
        KillSignal = "SIGINT";
        # minecraft sends exit code 130 when stopped
        SuccessExitStatus = 130;

        # use socket for stdin to send commands
        Sockets = "minecraft@%i.socket";
        StandardInput = "socket";
        StandardOutput = "journal";
        StandardError = "journal";

        # hardening
        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [ "" ];
        DevicePolicy = "strict";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" ];
        UMask = "0077";
      };
    };
  };
}
