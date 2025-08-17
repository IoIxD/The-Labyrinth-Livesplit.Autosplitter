Minecraft mod for Alpha 1.1.2 that stores the player's position in an object, using C/JNI to ensure full control over the data such that a program like LiveSplit/Cheat Engine can hook into it.

Being a mod done with [RetroMCP-Java](https://github.com/MCPHackers/RetroMCP-Java) and JNI, the following files are relevant:

- `client.patch`: Patches for the mod written in MCP. Place in `{mcp_dir}/src/net`, cd into it, and run `git patch client.patch`
- `mod.c`: The source for `LabyrinthModNative.dll`.
- `Makefile`: The file for building `mod.c`. Uses `mingw`

# Building

Currently, only building on Linux is supported.

Run either:

- `make linux` for an .so file (effectively useless but it's there)
- `make windows` for an .so file (requires MinGW to be installed)
