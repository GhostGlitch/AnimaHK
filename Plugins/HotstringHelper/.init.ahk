#Requires AutoHotkey v2.0
#SingleInstance Force
;;|||TODO||| 
 ;;-||Use AppData|| Make it create _reload_hotstrings.ahk and hotstrings.ahk in appdata if they can not be found in the plugin path.
   ;;+ Possibly embed hotkeys.ahk in the compiled version, so that if not found, a default version can be extracted to AppData.
 ;;-||Embed _reload_hostrings|| Embed the _reload_hotstrings.ahk in compiled binaries, so that it can be run directly from there without need for external files.
_HH_Init() {
    global A_ScriptPID := ProcessExist()
    ;: Set Path to own Plugin ;;
    if !_HH_PluginPath {
        ;: CONFIG ;;
        local CompiledPluginPath := A_ScriptDir "\Plugins\HotstringHelper"
        local SourcePluginPath := A_ScriptDir

        If A_IsCompiled {
            global _HH_PluginPath := CompiledPluginPath
        } else {
            global _HH_PluginPath  := SourcePluginPath
        }
    }
    ;: Set Important Paths ;;
    global _HH_OutputPath := _HH_PluginPath "\hotstrings.ahk"
    global _HH_Reload := _HH_PluginPath "\_reload_hotstrings.ahk"

    CheckForFile(_HH_OutputPath, "hotstring file", "create a file there")
    CheckForFile(_HH_Reload, "hotstring reload script", 'move "_reload_hotstrings.ahk" there')

    ; Checks if the file exists, and if not shows customizable error messages depending on compilation status.
    CheckForFile(Path, SimpleName, PossibleSolution) {
        if !FileExist(Path) {
            local baseError := "The " SimpleName " could not be found at: " Path "`n`n"
            local errorTitle :="|" A_ScriptName "| ERROR: File Not Found"
            If !A_IsCompiled { 
                MsgBox(baseError "Please check the paths specified in the script at " A_ScriptFullPath, errorTitle)
                return
            } else {
                MsgBox(baseError 'Either ' PossibleSolution ', or recompile the script with the correct path. `nHotstrings will not work without it.', errorTitle)
                return
            }
        }
    }
    Run _HH_Reload " " A_ScriptPID
}
_HH_Init()