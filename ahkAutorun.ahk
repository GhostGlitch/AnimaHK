#Requires AutoHotkey v2.0
#SingleInstance Force
#Include Plugins\

; Handle turning any window into an "overlay". Overlay windows are Overlay windows are always on top, transparent, and do not intercept mouse inputs.
#Include Overlayify.ahk
{
#!T:: Overlayify()          ;Win+Alt+T flips the active window betwen overlay and normal.
#!R:: UnOverlayAll()        ;Win+Alt+R resets windows that have been turned to overlays.
}

; Media controls
{
    Pause::Media_Play_Pause
    ScrollLock::Media_Next
    PrintScreen::Media_Prev
    PgUp::Volume_Up
    PgDn::Volume_Down   
}
; Other Random Hot[key/string]s
{
HotString(":::tm:", "™")
}

; Mask annoying Hotkeys
#Include Shadow.ahk

; Game specific hotkey configs
#Include _submods.ahk