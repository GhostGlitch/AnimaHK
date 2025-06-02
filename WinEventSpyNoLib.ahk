;Modified from: https://www.autohotkey.com/boards/viewtopic.php?t=125593

#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent
SetWinEventHook(eventMin, eventMax, hmodWinEventProc, Callback, idProcess, idThread, dwflags) {
    hHook := DllCall("User32.dll\SetWinEventHook"
        , "UInt", eventMin
        , "UInt", eventMax
        , "Ptr", hmodWinEventProc
        , "Ptr", pfnWinEventProc := CallbackCreate(Callback, "F")
        , "UInt", idProcess
        , "UInt", idThread
        , "UInt", dwflags
        , "Ptr")
    OnExit(ExitFunc)
    ExitFunc(ExitReason, ExitCode) {
        if (hHook)
            DllCall("User32.dll\UnhookWinEvent", "Ptr", hHook)
    }
}

/*
WINEVENTPROC Wineventproc;

void Wineventproc(
HWINEVENTHOOK hWinEventHook,
DWORD event,
HWND hwnd,
LONG idObject,
LONG idChild,
DWORD idEventThread,
DWORD dwmsEventTime
)
{...}
*/
RegisterWinMoveEvent(Callback) {
    SetWinEventHook(eventMin := 0x0000 ;  EVENT_SYSTEM_MOVESIZESTART
        , eventMax := 0xFFFF ;  EVENT_SYSTEM_MOVESIZEEND
        , hmodWinEventProc := 0
        , Callback
        , idProcess := 0
        , idThread := 0
        , dwflags := 0x0000 ;  WINEVENT_OUTOFCONTEXT
        )
}


handleMoveSizeEvent(hHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime) {
    for index, value in [0x8001, 0x8002, 0x8003, 0x8004, 0x8006, 0x8007, 0x8008, 0x8009, 0x800A, 0x800B, 0x800C, 0x800E, 0x8010]
        if (value = event)
            return

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
            . "`neventHex`t" "0x" Format("{:X}", event)
            . "`nhwnd`t" hwnd
            . "`nidObject`t" idObject
            . "`nidChild`t" idChild
            . "`nEventThread`t" dwEventThread
            . "`nEventTime`t" dwmsEventTime,
            10000, 0
        )
    WinSetTransparent(140, "ahk_id" TTHWND)
    WinShow("ahk_id" TTHWND)
    WinExist("ahk_id" TTHWND)
    WinGetPos(&X, &Y, &W, &H, "ahk_id" TTHWND)
    ;ToolTip("WinEventSpy: " X " " Y " " W " " H, 0, 0,2)
    ;ToolTip(PixelGetColor(X + 2, Y + 2), 0, 0, 3)
    retries := 0
    while  (PixelGetColor(X + 2, Y + 2) == 0xF9F9F9 && retries++ < 16) {
        WinSetTransparent(140, "ahk_id" TTHWND)
        WinShow("ahk_id" TTHWND)
        StdOut := FileOpen("*", "w", "UTF-8")
        StdOut.Write("WinEventSpy: Had to retry transparency")
        StdOut.Close()
    }
    CoordMode "ToolTip", "Client"
    CoordMode "Pixel", "Client"
}

RegisterWinMoveEvent(handleMoveSizeEvent)