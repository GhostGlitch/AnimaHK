#Requires AutoHotkey v2.0

; Tis-100 game hotkeys
; numpad hotkeys type common TIS-100 commands
; 1-4 on the toprow click the onscreen buttons for running 
#HotIf WinActive("TIS-100")
{
    NumpadClear:: Send("mov ")
    NumpadUp:: Send("Up ")
    NumpadDown:: Send("Down ")
    NumpadLeft:: Send("Left ")
    NumpadRight:: Send("Right ")
    NumpadHome:: Send("acc ")
    NumpadAdd:: Send("add ")
    NumpadSub:: Send("sub ")
    ; Click playback butons (only works on 1080p screen)
    1:: {
        BlockInput "On"
        MouseGetPos &xpos, &ypos
        Click 80, 1000
        MouseMove xpos, ypos
        BlockInput "Off"
    }
    4:: {
        BlockInput "On"
        MouseGetPos &xpos, &ypos
        Click 190, 1000
        MouseMove xpos, ypos
        BlockInput "Off"
    }
    3:: {
        BlockInput "On"
        MouseGetPos &xpos, &ypos
        Click 300, 1000
        MouseMove xpos, ypos
        BlockInput "Off"
    }
    2:: {
        BlockInput "On"
        MouseGetPos &xpos, &ypos
        Click 410, 1000
        MouseMove xpos, ypos
        BlockInput "Off"
    }
}
#HotIf