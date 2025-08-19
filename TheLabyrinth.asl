state("javaw") {}

startup {
    settings.Add("Checkpoint2", false);
    settings.Add("Checkpoint3", false);
    settings.Add("Checkpoint4", false);
    settings.Add("Checkpoint5", false);
    settings.Add("Checkpoint6", false);
    settings.Add("WoodenTower", false);
    settings.Add("Waterfalls", false);
    settings.Add("LastLevel", false);
    settings.Add("TheEnd", false);
}

init {
    var module = modules.SingleOrDefault(m => m.ModuleName.Equals("LabyrinthModNative.dll"));
    var scanner = new SignatureScanner(game, module.BaseAddress, module.ModuleMemorySize);

    // Our mod has a signature in the form of the FitnessGram Pacer Test in unicode bytes
    var target = new SigScanTarget(0, "54 68 65 20 46 69 74 6E 65 73 73 47 72 61 6D 21 22 20 50 61 63 65 72 20 54 65 73 74 20 69 73 20 61 20 6D 75 6C 74 69 73 74 61 67 65 20 61 65 72 6F 62 69 63 20 63 61 70 61 63 69 74 79 20 74 65 73 74 20 74 68 61 74 20 70 72 6F 67 72 65 73 73 69 76 65 6C 79 20 67 65 74 73 20 6D 6F 72 65 20 64 69 66 66 69 63 75 6C 74 20 61 73 20 69 74 20 63 6F 6E 74 69 6E 75 65 73 2E 20 54 68 65 20 32 30 20 6D 65 74 65 72 20 70 61 63 65 72 20 74 65 73 74 20 77 69 6C 6C 20 62 65 67 69 6E 20 69 6E 20 33 30 20 73 65 63 6F 6E 64 73 2E 20 4C 69 6E 65 20 75 70 20 61 74 20 74 68 65 20 73 74 61 72 74 2E 20 54 68 65 20 72 75 6E 6E 69 6E 67 20 73 70 65 65 64 20 73 74 61 72 74 73 20 73 6C 6F 77 6C 79 2C 20 62 75 74 20 67 65 74 73 20 66 61 73 74 65 72 20 65 61 63 68 20 6D 69 6E 75 74 65 20 61 66 74 65 72 20 79 6F 75 20 68 65 61 72 20 74 68 69 73 20 73 69 67 6E 61 6C 2E");

    // scans the bytes in the scanner for the target and returns the first address at which it was found
    vars.FitnessGramPacerTest = scanner.Scan(target);

    print("Fitness Gram Pacer Test: "+vars.FitnessGramPacerTest.ToString("X"));

    vars.PlayerXPtr = (IntPtr)(vars.FitnessGramPacerTest + 288);
    vars.PlayerYPtr = (IntPtr)(vars.FitnessGramPacerTest + 296);
    vars.PlayerZPtr = (IntPtr)(vars.FitnessGramPacerTest + 304);

    vars.splits = new Dictionary<string, Func<bool>>()
    {
        {"Checkpoint2",  () => vars.PlayerX >= 276 && vars.PlayerX <= 278 && vars.PlayerZ >= -101 && vars.PlayerZ <= -94 && vars.PlayerY <= 20},
        {"Checkpoint3",  () => vars.PlayerX >= 234 && vars.PlayerX <= 259 && vars.PlayerZ >= -83 && vars.PlayerZ <= -80},
        {"Checkpoint4",  () => vars.PlayerX >= 236 && vars.PlayerX <= 283 && vars.PlayerZ >= -41 && vars.PlayerZ <= -38},
        {"Checkpoint5",  () => vars.PlayerX >= 300 && vars.PlayerX <= 312 && vars.PlayerZ >= -67 && vars.PlayerZ <= -59},
        {"Checkpoint6",  () => vars.PlayerX >= 275 && vars.PlayerX <= 277 && vars.PlayerZ >= -192 && vars.PlayerZ <= -190},
        {"WoodenTower",  () => vars.PlayerX >= 269 && vars.PlayerX <= 293 && vars.PlayerZ >= -283 && vars.PlayerZ <= -258},
        {"Waterfalls",   () => vars.PlayerX >= 279 && vars.PlayerX <= 283 && vars.PlayerY >= 93 && vars.PlayerY <= 96 && vars.PlayerZ >= -271 && vars.PlayerZ <= -264 },
        {"LastLevel",    () => vars.PlayerX >= 369 && vars.PlayerX <= 399 && vars.PlayerZ >= -296 && vars.PlayerZ <= -265},
        {"TheEnd", () => vars.PlayerX >= 471 && vars.PlayerX <= 552 && vars.PlayerY >= 15 && vars.PlayerY <= 68 && vars.PlayerZ >= -325 && vars.PlayerZ <= -283},
    };
    vars.completedSplits = new HashSet<string>();

    vars.resetSplits = (Action)(() =>
    {
        vars.completedSplits.Clear();
        print("[DELTARUNE] All splits have been reset to initial state");
    });
}

update {
    vars.PlayerX = game.ReadValue<double>((IntPtr)vars.PlayerXPtr);
    vars.PlayerY = game.ReadValue<double>((IntPtr)vars.PlayerYPtr);
    vars.PlayerZ = game.ReadValue<double>((IntPtr)vars.PlayerZPtr);

    // print(vars.PlayerY.ToString());
    // print(vars.PlayerX.ToString()+", "+vars.PlayerZ.ToString());
}


reset {
    if(vars.PlayerX >= 275 && vars.PlayerX <= 279 && vars.PlayerZ >= -208 && vars.PlayerZ <= -179 && vars.PlayerY <= 20) {
        return true;
    }
}

start {
    if(vars.PlayerX >= 255 && vars.PlayerX <= 299 && vars.PlayerZ >= -178 && vars.PlayerZ <= -135 && vars.PlayerY <= 20) {
        return true;
    }
}

onReset
{
    vars.resetSplits();
}

split
{
    foreach(var split in vars.splits)
    {
        if(!settings[split.Key] || 
           vars.completedSplits.Contains(split.Key) ||
           !split.Value())  {
            continue;
           };

        vars.completedSplits.Add(split.Key);
        print("[Minecraft Labyrinth] Split triggered (" + split.Key + ")");
        return true;
    }
}
