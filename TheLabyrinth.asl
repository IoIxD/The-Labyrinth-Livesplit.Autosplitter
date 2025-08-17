state("javaw") {
}


init {
    // initializes a list of MemoryWatchers
    vars.Watchers = new MemoryWatcherList
    {
        // adds a Watcher to the list; additionally use of vars.Watchers.Add(MemoryWatcher) is possible
        new MemoryWatcher<int>(new DeepPointer("LabyrinthModNative.dll", 0x0)) { Name = "intWatcher" },
    };

}

update {
    // updates all Watchers in the list (use this in update {})
    // vars.Watchers.UpdateAll(game);
    // print(vars.Watchers["intWatcher"].Current);
}
