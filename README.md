# CMod Example

An example CMod (C# mod) loadable with the [CMod Loader](https://github.com/murolem/CMod_Loader).

Shows a dialog window on a successful loading (I know, excitiiiing :3).

## Making a CMod

### Requirenments

A CMod behaves similarly to a regular `.rules` mod, except it must have:

-   A `CMod` folder with a `Main.dll` file inside. This is the entrypoint of a CMod. Generated automatically.
-   The DLL must be a C# DLL with a namespace starting with `CModEntrypoint` and a a public `Main` class inside.
-   The namespace must follow the format `CModEntrypoint_<username>_<modname>`. It helps the Loader to find the mod, prevents collisions between different mods and allows mod authors to target target other CMods if they wish to. All the positives!

Harmony is used as a patching library and it comes with the [Helper library](https://github.com/murolem/CMod_Loader) (part of the CMod Loader). It should be up in the references, referencing the Helper mod directory. When initializing Harmony, follow this format for the ID: `cmod.<username>.<modname>`.

If you want to use different patching library or another version of Harmony - you are free to do so. If Harmony DLL is present along your mod DLL, it will be used instead of the Harmony DLL shipped with the Helper.

Some other things in the mod (such as `FileLogger`) are defined under `CMod` namespace. This namespace is arbitrary and you are free to change it however you like.

### Project structure

Anything goes, except for the `static` folder. It's copied by the build script (explained later) "as-is" to the resulting mod folder (not under `CMod`). Put all non-code stuff in there.

### Project configuration

▮ The project config contains some references with relative paths, which are likely to be broken on your end. If using Visual Studio, you might wanna check the raw config by double-clicking the project name. It might be easier that way to see what's wrong.

Harmony reference should point to the Harmony DLL inside the Helper mod directory. `Cosmoteer` and `HalflingCore` reference the game DLLs, these should point to the dlls inside the `Bin` Cosmoteer directory.

▮ The post-build script (outlined in [Building](#Building) section) must be configured to work. Otherwise it would likely fail the build and might produce some unexpected results.

### Hooks

Hooks are methods within the `Main` class that are called by the Loader at different points in game.

See the methods inside the `Main` for the list of available hooks and their descriptions.

### Logging

A `FileLogger` class is included to help you with logging. It creates a .log file inside the mod directory (in CMod folder) and logs whatever you like in there.

### Utils

There's a small `Utils` class attached with a few methods to help you get the paths to the mod folder/CMod folder. These should be helpful in loading assets, etc.

### Troubleshooting

▮ Debugging by logging (the most based method ofc) is possible through the file logger mentioned above.

▮ Live debugging is _potentially_ possible to do in a non-hacky way, but I didn't manage to do so with a configuration that launches an executable.
There goes the hacky way:

-   Set a breakpoint.
-   If needed, delay execution in the code before the breakpoint for a reasonable time. You'll need atleast 5 seconds from the game start.
-   Build project with the game restart enabled or restart the game manually.
-   Go to Debug → Attach to process (or use hotkey). Find and pick Cosmoteer.
-   After first time, you'll be able to attach to the Cosmoteer process with a single hotkey. It should appear in the same menu.

If you were fast enough, the breakpoint _can_ trigger. I say can because it's kinda unstable, and the breakpoints can sometimes change places...

If you manage to find a better way, PLEASE SHARE. It would be much appreciated! :З

▮ Debugging Loader/Helper might be complicated without building them. But there are logfiles for each. See their github pages for more info. 

### Building

To help with some boring build things, a post-build script `IntegrateAfterBuild.ps1` exist.

After build, it will:

-   Generate a mod directory (**clearing** it if it exists).
-   Copy build artifacts (build files) into the mod directory.
-   Copy `static` folder as-is to the mod directory.
-   Restart Cosmoteer (if enabled), with option to restart in dev mode.

The script **requires** configuration to work.

Check the project configuration before build - it's likely will contain some broken paths.

### Publishing

CMods are published the same way the regular `.rules` mods do — from inside the game.

Because these are DLLs, they can also have their own version that might show up in logs or stack traces, so it's recommended to set it/update it with new releases of your mod. The version can be found (if using Visual Studio), in project Properties → Package Version.

If you are using the `FileLogger` utility, or have implemented your own logger, don't forget to remove the logfile before publishing as it could contain some sensetive info, such as your Windows username (and whatever else you log). `FileLogger` log file can be found in the mod directory → `CMod` → `Logifle.log`. 

**Important:** After mod is published for the first time, it's assigned a Workshop ID. It's used for publishing new updates and is saved within your mod folder. Because each new build clears out your mod folder, to not lose it on rebuild, copy it from your mod folder to the `static` folder in your project.

## Contributing

Contributions are very welcome as this is my first published C# project. As well as in the [Loader](https://github.com/murolem/CMod_Loader).
