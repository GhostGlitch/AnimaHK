#Requires AutoHotkey v2.0
#SingleInstance Force

SetTimer(ExitOnParentDeath, 5000)
ExitOnParentDeath(){
    if !ProcessExist(A_Args[1])
        ExitApp
}

#Include hotstrings.ahk