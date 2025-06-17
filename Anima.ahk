#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <Apparition\__Base>
#Include <Apparition\MsgBox>
#Include <Apparition\Collections>
;;|||TODO|||
    ;;-||Refactor|| - None Currently
    ;;-||Autoclicker|| Add toggleable autoclicker and/or an autoclicker that needs a key held with the mouse button. Specifically forGames/terraria. but maybe make universal? 
        ;+  At least make it a plugin that certain games can call.

    ;;-||Maybe?||
        ;;?-|Plugin-Control| Add Tray controls to enable/disable individual plugins

; If Run as a script, run the mahk to ensure module trees are correct.
;@Ahk2Exe-IgnoreBegin
RunWait "Anima.m.ahk"
Appa.SetDebug(,false)
;@Ahk2Exe-IgnoreEnd

;Globals
CoordMode "Mouse", "Client"
global A_ScriptPID := ProcessExist()

#Include Plugins\

; Handle turning any window into an "overlay". Overlay windows are Overlay windows are always on top, transparent, and do not intercept mouse inputs.
#Include Overlayify\_overlayify.ahk

; Media controls
#Include MediaControls.ahk

; Make Hotstrings On the Fly (also includes the hotstrings themselves)
;@Ahk2Exe-IgnoreBegin
global _HH_PluginPath := A_ScriptDir "\Plugins\HotstringHelper"
;@Ahk2Exe-IgnoreEnd
#Include HotstringHelper\_hotstringhelper.ahk

; Mask annoying Hotkeys
#Include Shadow.ahk

; Game specific hotkey configs
#Include Games\_games.ahk

^+F1:: ListHotkeys
; Any others not specified (disabled)
; #Include _plugins.ahk