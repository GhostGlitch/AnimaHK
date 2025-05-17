#Requires AutoHotkey v2.0
#SingleInstance Force
;;|||TODO|||
    ;;-||Autoclicker|| Add toggleable autoclicker and/or an autoclicker that needs a key held with the mouse button. Specifically forGames/terraria. but maybe make universal? 
        ;+  At least make it a plugin that certain games can call.

    ;;-||Maybe?||
        ;;?-|Plugin-Control| Add Tray controls to enable/disable individual plugins
        
#Include Plugins\

; Handle turning any window into an "overlay". Overlay windows are Overlay windows are always on top, transparent, and do not intercept mouse inputs.
#Include Overlayify\_overlayify.ahk

; Media controls
#Include MediaControls.ahk

; Other Random Hot[key/string]s
#Include Typing.ahk

; Mask annoying Hotkeys
#Include Shadow.ahk

; Game specific hotkey configs
#Include Games\_games.ahk

; Any others not specified
#Include _plugins.ahk