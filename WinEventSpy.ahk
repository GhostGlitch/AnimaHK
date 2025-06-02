;Modified from: https://www.autohotkey.com/boards/viewtopic.php?t=125593
#Include <Apparition\AllPrims>
#Include <Apparition\Window>
#Include <AquaEx\AquaExtras>
#Include <Apparition\STDStream>

#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent
STD := STDStream()

handleEvent(hHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime) {

    ;for value in Range(0x8001, 0x800E)
    ;    if (value = event)
    ;        return
    if event == 8 or event == 9 or event == 0x800B
        return
    STD.Println("Event: " event.ToHex())
    critical -1
    for _ in [&idObject,&idChild] ;  Int, Int
        %_%:=%_%<<32>>32
    if  (A_PtrSize==8) { ;  (64-bit AHK)  Int64 ->
        for _ in [&event,&dwEventThread,&dwmsEventTime] ;  UInt, UInt, UInt
            %_%&=0xFFFFFFFF
    }
    /*
    Casting between data types
    https://www.autohotkey.com/boards/viewtopic.php?f=82&t=125643
    */

    CoordMode "ToolTip", "Screen"
    CoordMode "Pixel", "Screen"
    TTHWND := Tooltip("hHook`t" hHook
        . "`nevent`t" event
        . "`neventHex`t" "0x" event.ToHex()
        . "`nhwnd`t" hwnd
        . "`nidObject`t" idObject
        . "`nidChild`t" idChild
        . "`nEventThread`t" dwEventThread
        . "`nEventTime`t" dwmsEventTime,
        10000, 0
    )
    TT := Window("ahk_id" TTHWND)
    TT.SetTransparent(140).Show()
    ;ToolTip("WinEventSpy: " TT.Pos.X " " TT.Pos.Y " " TT.Pos.Width " " TT.Pos.Height, 0, 0,2)
    retries := 0
    while  (PixelGetColor(TT.Pos.X + 2, TT.Pos.Y + 2) == 0xF9F9F9 && retries++ < 16) {
        TT.SetTransparent(140).Show()
        STD.Println("WinEventSpy: Had to retry transparency")
    }
    CoordMode "ToolTip", "Client"
    CoordMode "Pixel", "Client"
}

SetWinEventHook(eventMin := 0x0000 ;  EVENT_SYSTEM_MOVESIZESTART
    , eventMax := 0xFFFF ;  EVENT_SYSTEM_MOVESIZEEND
    , hmodWinEventProc := 0
    , handleEvent
    , idProcess := 22124
    , idThread := 0
    , dwflags := 0x0000 ;  WINEVENT_OUTOFCONTEXT
)

