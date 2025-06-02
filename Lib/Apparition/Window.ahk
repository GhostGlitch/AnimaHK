#Requires AutoHotkey v2.0 
#Include <AquaEx\Window>

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
SetWinEventHook(eventMin, eventMax, CallbackFunc, idProcess := 0, hmodWinEventProc := 0,idThread := 0, dwflags := 0) {
    hHook := DllCall("User32.dll\SetWinEventHook"
        , "UInt", eventMin
        , "UInt", eventMax
        , "Ptr", hmodWinEventProc
        , "Ptr", pfnWinEventProc := CallbackCreate(CallbackFunc, "F")
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

class Apparition_Window_Static extends AquaHotkey {
    class Window {
        static SetWinEventHook(eventMin, eventMax, CallbackFunc, idProcess := 0, hmodWinEventProc := 0,idThread := 0, dwflags := 0) {
            SetWinEventHook(eventMin, eventMax, CallbackFunc, idProcess, hmodWinEventProc, idThread, dwflags)
        }
        static RegisterMoveEvent(CallbackFunc, PID := 0)  {
        SetWinEventHook(0x000A ;  EVENT_SYSTEM_MOVESIZESTART
            , 0x000B ;  EVENT_SYSTEM_MOVESIZEEND
            , CallbackFunc
            , PID
            , 0
            , 0
            , 0x0000 ;  WINEVENT_OUTOFCONTEXT
            )
        }
    } 
}

class Apparition_Window extends AquaHotkey {
    class Window {
        SetWinEventHook(eventMin, eventMax, CallbackFunc, idProcess := 0, hmodWinEventProc := 0,idThread := 0, dwflags := 0) {
            Window.SetWinEventHook(eventMin, eventMax, CallbackFunc, this.PID, hmodWinEventProc, idThread, dwflags)
        }
        RegisterMoveEvent(CallbackFunc) {
            Window.RegisterMoveEvent(CallbackFunc, this.PID)
        }
        static __Test() {
            Persistent
            handleMoveSizeEvent(hHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime) {

                critical -1
                for _ in [&idObject, &idChild] ;  Int, Int
                    %_% := %_% << 32 >> 32
                if (A_PtrSize == 8) { ;  (64-bit AHK)  Int64 ->
                    for _ in [&event, &dwEventThread, &dwmsEventTime] ;  UInt, UInt, UInt
                        %_% &= 0xFFFFFFFF
                }
                /*
                Casting between data types
                https://www.autohotkey.com/boards/viewtopic.php?f=82&t=125643
                */
                Tooltip "hHook`t`t: " hHook
                    . "`nevent`t`t: " event
                    . "`nhwnd`t`t: " hwnd
                    . "`nidObject`t`t: " idObject
                    . "`nidChild`t`t: " idChild
                    . "`ndwEventThread`t: " dwEventThread
                    . "`ndwmsEventTime`t: " dwmsEventTime
            }

            win := Window("AutoHotkey v2 Help")
            win.RegisterMoveEvent(handleMoveSizeEvent)
        }
    }
}
if A_ScriptFullPath == A_LineFile {
    Window.__Test()
}