#Requires AutoHotkey v2.0
#SingleInstance Force
;;|||TODO|||
    ;;-||Refactor||
        ;;+ Make path globals non-compiled only, that's the only time the patch is necessary. Plugins can use compile flags to fix the paths for the compiled version, but when source-run, they expect a local test, not a global one.
    ;;-||Autoclicker|| Add toggleable autoclicker and/or an autoclicker that needs a key held with the mouse button. Specifically forGames/terraria. but maybe make universal? 
        ;+  At least make it a plugin that certain games can call.

    ;;-||Maybe?||
        ;;?-|Plugin-Control| Add Tray controls to enable/disable individual plugins

#Include Plugins\

;Globals
global A_ScriptPID := ProcessExist()

; Handle turning any window into an "overlay". Overlay windows are Overlay windows are always on top, transparent, and do not intercept mouse inputs.
#Include Overlayify\_overlayify.ahk

; Media controls
#Include MediaControls.ahk

; Make Hotstrings On the Fly (also includes the hotstrings themselves)
global _HH_PluginPath := A_ScriptDir "\Plugins\HotstringHelper"
#Include HotstringHelper\_hotstringhelper.ahk

; Mask annoying Hotkeys
#Include Shadow.ahk

; Game specific hotkey configs
#Include Games\_games.ahk

; Any others not specified (disabled)
; #Include _plugins.ahk