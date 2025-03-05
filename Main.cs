using CMod;
using Cosmoteer.Gui;
using Halfling.Gui.Dialogs;
using HarmonyLib;
using System.Reflection;
using System.Runtime.CompilerServices;

[assembly: IgnoresAccessChecksTo("Cosmoteer")]
[assembly: IgnoresAccessChecksTo("HalflingCore")]

namespace CModEntrypoint_JohnCosmoteer_ExampleCMod {
    public class Main {
        public static Harmony? harmony;

        /// <summary>
        /// Use this method to apply patches BEFORE the game is fully loaded 
        /// and BEFORE modifications to rules fules (such as mod actions, mod strings) are applied.
        /// 
        /// Source code reference: Cosmoteer.Mods.ModInfo.ApplyPreLoadMods()
        /// </summary>
        public static void Pre_ApplyPreLoadMods() {
            FileLogger.LogInfo("Pre_ApplyPreLoadMods() called");
        }

        /// <summary>
        /// Use this method to apply patches BEFORE the game is fully loaded 
        /// and AFTER modifications to rules fules (such as mod actions, mod strings) are applied.
        /// 
        /// Source code reference: Cosmoteer.Mods.ModInfo.ApplyPreLoadMods()
        /// </summary>
        public static void Post_ApplyPreLoadMods() {
            FileLogger.LogInfo("Post_ApplyPreLoadMods() called");
        }

        /// <summary>
        /// Use this method to apply patches AFTER the game is fully loaded 
        /// and BEFORE modifications are done to the loaded game data (such as MODDED ship libraries being added).
        /// 
        /// Source code reference: Cosmoteer.Mods.ModInfo.ApplyPostLoadMods()
        /// </summary>
        public static void Pre_ApplyPostLoadMods() {
            FileLogger.LogInfo("Pre_ApplyPostLoadMods() called");
        }

        /// <summary>
        /// Use this method to apply patches AFTER the game is fully loaded 
        /// and AFTER modifications are done to the loaded game data (such as MODDED ship libraries being added).
        /// 
        /// Source code reference: Cosmoteer.Mods.ModInfo.ApplyPostLoadMods()
        /// </summary>
        public static void Post_ApplyPostLoadMods() {
            FileLogger.LogInfo("Post_ApplyPostLoadMods() called");

            harmony = new Harmony("cmod.john_cosmoteer.example");

            // enable if you want ot have harmony logging about your patching.
            // if enabled, will create a log file on your systems Desktop called "harmony.log.txt".
            Harmony.DEBUG = false;

            FileLog.Log("Running patches");
            var assembly = Assembly.GetExecutingAssembly();
            harmony.PatchAll(assembly);
        }
    }


    [HarmonyPatch(typeof(TitleScreen))]
    [HarmonyPatch("ActivatedDelayed")]
    [HarmonyPatch(new Type[] { })]
    static class Cosmoteer_Gui_TitleScreen_ActivatedDelayed_Patch {
        static bool wasDialogDisplayed = false;
        public static void Postfix() {
            // few potentially useful access points:
            // current game root
            // Cosmoteer.Game.GameRoot.Current;

            // current simulation root
            // Cosmoteer.Game.GameRoot.Current.Sim;

            // an "Update" method to attach to
            // Halfling.App.Director.FrameEnded

            if(wasDialogDisplayed) {
                return;
            }

            OneButtonDialog.Show("Example CMod loaded. Yippie!!!!!!", "Sure");

            wasDialogDisplayed = true;
        }
    }
}