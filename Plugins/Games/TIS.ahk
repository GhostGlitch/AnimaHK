#Requires AutoHotkey v2.0

; Tis-100 game hotkeys
; numpad hotkeys type common TIS-100 commands
; 1-4 on the toprow click the onscreen buttons for running 

#HotIf WinActive("ahk_exe tis100.exe")
TIS := Game("ahk_exe tis100.exe", Array(
    Game.VButton("Stop", 0.043, 0.911),
    Game.GameFunc("Step", "{F6}"), ;0.098, 0.911),
    Game.GameFunc("Play", "{F5}"), ;0.155, 0.911),
    Game.VButton("Fast", 0.212, 0.911)))

NumpadClear:: Send("mov ")
NumpadUp::    Send("Up ")
NumpadDown::  Send("Down ")
NumpadLeft::  Send("Left ")
NumpadRight:: Send("Right ")
NumpadHome::  Send("acc ")
NumpadAdd::   Send("add ")
NumpadSub::   Send("sub ")

1::     TIS.Press("Stop")
2::     F6
3::     F5
4::     TIS.Press("Fast")

+F5:: TIS.Press("Stop")
^+F5:: {
    TIS.Press("Stop")
    TIS.Press("Play")
}
F11:: TIS.Press("Step")

#HotIf