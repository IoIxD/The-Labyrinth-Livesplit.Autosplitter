state("javaw") {
}


init {
    vars.NeedSetGSPointer = false;
    vars.GameStatePointer = 0;

    // For some reason, we can't do any of this when the game starts up.
    // Something about an object being null? IDC, lets just make this function to do it oncei n the update function.
    vars.SetupGameStatePointer = (Action)(()=> {
        vars.GameStatePointer = 0;
        foreach(var module in modules) {
            if(module.ModuleName == "LabyrinthModNative.dll") {
                var scanner = new SignatureScanner(game, module.BaseAddress, module.ModuleMemorySize);
            
                var target = new SigScanTarget(0, "54 68 65 20 46 69 74 6e 65 73 73 47 72 61 6d 21 22 20 50 61 63 65 72 20 54 65 73 74 20 69 73 20 61 20 6d 75 6c 74 69 73 74 61 67 65 20 61 65 72 6f 62 69 63 20 63 61 70 61 63 69 74 79 20 74 65 73 74 20 74 68 61 74 20 70 72 6f 67 72 65 73 73 69 76 65 6c 79 20 67 65 74 73 20 6d 6f 72 65 20 64 69 66 66 69 63 75 6c 74 20 61 73 20 69 74 20 63 6f 6e 74 69 6e 75 65 73 2e 20 54 68 65 20 32 30 20 6d 65 74 65 72 20 70 61 63 65 72 20 74 65 73 74 20 77 69 6c 6c 20 62 65 67 69 6e 20 69 6e 20 33 30 20 73 65 63 6f 6e 64 73 2e 20 4c 69 6e 65 20 75 70 20 61 74 20 74 68 65 20 73 74 61 72 74 2e 20 54 68 65 20 72 75 6e 6e 69 6e 67 20 73 70 65 65 64 20 73 74 61 72 74 73 20 73 6c 6f 77 6c 79 2c 20 62 75 74 20 67 65 74 73 20 66 61 73 74 65 72 20 65 61 63 68 20 6d 69 6e 75 74 65 20 61 66 74 65 72 20 79 6f 75 20 68 65 61 72 20 74 68 69 73 20 73 69 67 6e 61 6c 2e");
                
                // returns all addresses which matched the target
                var results = scanner.ScanAll(target);

                // scans all of the game's memory pages to search for a successful scan
                foreach (var page in game.MemoryPages(false))
                {
                    var _scanner = new SignatureScanner(game, page.BaseAddress, (int)(page.RegionSize));
                    IntPtr result = _scanner.Scan(target);
                    if (result != IntPtr.Zero){
                        vars.GameStatePointer = result;
                        vars.NeedSetGSPointer = true;
                        break;
                    }
                }
                print("State Pointer: 0x"+vars.GameStatePointer.ToString("X"));
            }
        }
    });
    // vars.completedSplits = new HashSet<string>();

    // vars.hour_values = new Dictionary<string, long>()
    // {
    //     {"Hour1",116444736000000000},
    //     {"Hour2",116444738000000000},
    //     {"Hour3",116444740000000000},
    //     {"Hour4",116444760000000000},
    //     {"Hour5",116444780000000000}, 
    //     {"Hour6",116444800000000000},
    //     {"Hour7",116444820000000000},
    // };
}

startup {
    // settings.Add("Hour1", true, "12AM");
    // settings.Add("Hour2", true, "1AM");
    // settings.Add("Hour3", true, "2AM");
    // settings.Add("Hour4", true, "3AM");
    // settings.Add("Hour5", true, "4AM");
    // settings.Add("Hour6", true, "5AM");
    // settings.Add("Hour7", true, "6AM");
}
update {
    if(!vars.NeedSetGSPointer) {
        vars.SetupGameStatePointer();
        vars.NeedSetGSPointer = true;
    }
    vars.playerX = memory.ReadValue<float>((IntPtr)(vars.GameStatePointer + 40));
    vars.playerY = memory.ReadValue<float>((IntPtr)(vars.GameStatePointer + 44));
    vars.playerZ = memory.ReadValue<float>((IntPtr)(vars.GameStatePointer + 48));

    // print(vars.playerX+", "+vars.playerY+", "+vars.playerZ);
}

start {
    // if(vars.currentScreen == 2) {
    //     return true;
    // }
}


reset {
    // if(vars.currentScreen == 0) {
        // return true;
    // }
    // return false;
}

split {
    // foreach(var split in vars.hour_values) {
    //     if(!settings[split.Key] || 
    //        vars.completedSplits.Contains(split.Key) ){
    //         continue;
    //        }

    //     if(vars.currentTime >= split.Value) {
    //         vars.tempVar = 0;
    //         vars.completedSplits.Add(split.Key);
    //         print("[ONAT] Split triggered (" + split.Key + ")");
    //         return true;
    //     } else {
    //         return false;
    //     }
    // }
    return false;
}