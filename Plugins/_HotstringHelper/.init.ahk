#Requires AutoHotkey v2.0
#SingleInstance Force
;;|||TODO|||
    ;;-||Hotload|| Make the compiled version hotload the hotstring file when run. Allowing new hotkeys to be persist through relaunches without needing a recompile.
        ;+ Make sure to modify the error message if you do.

Init() {
    ;: CONFIG ;;
    SplitPath(A_ScriptDir,,&HH_DirOfDir)
    local CompiledOutputPath := A_ScriptDir "\Plugins\hotstrings.ahk"
    local SourceOutputPath := HH_DirOfDir "\Hotstrings.ahk"

    ;: Set OutputPath ;;
    If A_IsCompiled {
        global _HH_OutputPath := CompiledOutputPath
    } else {
    global _HH_OutputPath := SourceOutputPath
    }


    global HH_OutputFileFallback := HH_DirOfDir "\hotstrings.ahk"

    if !FileExist(_HH_OutputPath) {
        local baseError := "The hotstring file could not be found at: " _HH_OutputPath "`n`n"
        local errorTitle :="|" A_ScriptName "| ERROR: File Not Found"
        If !A_IsCompiled { 
            
            MsgBox(baseError "Please check the paths specified in the script at " A_ScriptFullPath, errorTitle)
            return
        } else {
            MsgBox(baseError "Either create a file there, or compile the script with the correct path. `n`nHotstrings should still work until the program is closed, but they will not be added to a new version if you recompile", errorTitle)
            return
        }
    }
}
Init()