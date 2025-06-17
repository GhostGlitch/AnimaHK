#Requires AutoHotkey v2.0
; Tis-100 game hotkeys
; Numpad should be capable of fully writing a program.
; 1-4 on the toprow click the onscreen buttons for running.
; F Keys work as VSCode defaults.

#HotIf WinActive("ahk_exe tis100.exe")
TIS := Game("ahk_exe tis100.exe", Array(
    Game.VButton("Stop", 0.043, 0.911),
    Game.GameFunc("Step", "{F6}"), ;0.098, 0.911),
    Game.GameFunc("Play", "{F5}"), ;0.155, 0.911),
    Game.VButton("Fast", 0.212, 0.911)))

;||REG(SHIFT)||
    NumpadClear::  Send("MOV ")         ;5
    ;|DIR|
        NumpadUp::     Send("UP ")      ;8
        NumpadDown::   Send("DOWN ")    ;2
        NumpadLeft::   Send("LEFT ")    ;4
        NumpadRight::  Send("RIGHT ")   ;6
    ;|SPECIAL|
        NumpadPgup::   Send("ACC ")     ;9
        NumpadHome::   Send("ANY ")     ;7
        NumpadPgdn::   Send("LAST ")    ;3
        NumpadEnd::    Send("NIL ")     ;1
        NumpadIns::BackSpace            ;0
;||MATH(Any)||
    *NumpadAdd::    Send("{Text}ADD ")  ;+
    *NumpadSub::    Send("{Text}SUB ")  ;-
    *NumpadDiv::    Send("{Text}NEG ")  ;/
    *NumpadMult::   Send("{Text}NOP ")  ;*
;||ALT||
    ;|JMP|
        !Numpad5::  Send("{Text}JEZ ")  ;!5
        !Numpad8::  Send("{Text}JGZ ")  ;!8
        !Numpad2::  Send("{Text}JLZ ")  ;!2
        !Numpad4::  Send("{Text}JNZ ")  ;!4
        !Numpad6::  Send("{Text}JMP ")  ;!6
        !Numpad9::  Send("{Text}JRO ")  ;!9

    ;|BAK|
        !Numpad7:: Send("{Text}SAV ")  ;!7
        !Numpad1::  Send("{Text}SWP ") ;!1
;||NAV(CTRL)||
    ;|CURSOR|
        ^Numpad8::Up                    ;^8            
        ^Numpad2::Down                  ;^2
        ^Numpad4::Left                  ;^4
        ^Numpad6::Right                 ;^6
        ^Numpad0::Delete                ;^0
    ;|NODE(SHIFT)|
        ^+Numpad8::^Up                  ;^8            
        ^+Numpad2::^Down                ;^2
        ^+Numpad4::^Left                ;^4
        ^+Numpad6::^Right               ;^6
;||DBG||
    ;|NUMROW|
        *1::TIS.Press("Stop")
        *2::F6
        *3::F5
        *4::TIS.Press("Fast")
    ;|VSCODE|
        +F5:: TIS.Press("Stop")
        ^+F5::{
            TIS.Press("Stop")
            TIS.Press("Play")
        }
        F11:: TIS.Press("Step")
#HotIf