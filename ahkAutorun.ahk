#Requires AutoHotkey v2.0
#SingleInstance Force
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