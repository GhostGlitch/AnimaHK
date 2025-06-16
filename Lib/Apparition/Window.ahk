#Requires AutoHotkey v2.0
#Include <Apparition\__Base>
#Include <Apparition\ControlFlow>
#Include <AquaEx\Window>

/**
 * Wrapper for WinEventProc from Win32 API.
 * 
 * Creates a Windows event hook which listens for certain events and calls a function when they occur.
 * 
 * @param {UInt} eventMin The start of the event code range to hook.
 * @param {UInt} eventMax The end of the event code range to hook.
 * @param {Func} Callback The function to call when the event occurs.
 * @param {UInt} [PID=0] Optional process ID to filter by.
 * @param {Ptr} [hmodWinEventProc=0] Optional handle to the module containing the hook procedure.
 * @param {UInt} [ThreadID=0] Optional thread ID to filter by.
 * @param {UInt} [dwflags=0] Optional flags to modify hook behavior.
 * @returns {Ptr} A handle to the installed hook.
 * 
 * @remarks Automatically unhooks the event when the script exits.
 */
SetWinEventHook(eventMin, eventMax, Callback, PID := 0, hmodWinEventProc := 0,ThreadID := 0, dwflags := 0) {
    hHook := DllCall("User32.dll\SetWinEventHook"
        , "UInt", eventMin
        , "UInt", eventMax
        , "Ptr", hmodWinEventProc
        , "Ptr", pfnWinEventProc := CallbackCreate(Callback, "F")
        , "UInt", PID
        , "UInt", ThreadID
        , "UInt", dwflags
        , "Ptr")
    OnExit(ExitFunc)
    ExitFunc(ExitReason, ExitCode) {
        if (hHook)
            DllCall("User32.dll\UnhookWinEvent", "Ptr", hHook)
    }
    return hHook
}

/**
 * Contains various static functions to extend AquaHotkey's Window class
 */
class Apparition_Window_Static extends AquaHotkey {
    class Window {
        /**
         * Wrapper for WinEventProc from Win32 API.
         * 
         * Creates a Windows event hook which listens for certain events and calls a function when they occur.
         * 
         * @param {UInt} eventMin The start of the event code range to hook.
         * @param {UInt} eventMax The end of the event code range to hook.
         * @param {Func} Callback The function to call when the event occurs.
         * @param {UInt} [PID=0] Optional process ID to filter by.
         * @param {Ptr} [hmodWinEventProc=0] Optional handle to the module containing the hook procedure.
         * @param {UInt} [ThreadID=0] Optional thread ID to filter by.
         * @param {UInt} [dwflags=0] Optional flags to modify hook behavior.
         * @returns {Ptr} A handle to the installed hook.
         * 
         * @remarks Automatically unhooks the event when the script exits.
         */
        static SetWinEventHook(eventMin, eventMax, Callback, PID := 0, hmodWinEventProc := 0,ThreadID := 0, dwflags := 0) {
            SetWinEventHook(eventMin, eventMax, Callback, PID, hmodWinEventProc, ThreadID, dwflags)
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

/**
 * Contains various functions to extend instances of AquaHotkey's Window class
 */
class Apparition_Window extends AquaHotkey {
    class Window {
        EventHook := 0

        /** @private
         * 
         * Gets the Window's PID if it exists, gives a more detailed throw otherwise.
         * 
         * @returns {Integer} The PID of the Window.
         * @throws {TargetError} If the window does not exist.
         */
        __tryPid() {
            try {
                return this.PID
            } catch {
                throw TargetError("Window does not exist.", -2, this.WinTitle)
            }
        }
        /**
         * Wrapper for WinEventProc from Win32 API.
         * 
         * Creates a Windows event hook which listens for certain events from this window and calls a function when they occur.
         * 
         * @param {UInt} eventMin The start of the event code range to hook.
         * @param {UInt} eventMax The end of the event code range to hook.
         * @param {Func} Callback The function to call when the event occurs.
         * @param {Ptr} [hmodWinEventProc=0] Optional handle to the module containing the hook procedure.
         * @param {UInt} [ThreadID=0] Optional thread ID to filter by.
         * @param {UInt} [dwflags=0] Optional flags to modify hook behavior.
         * @returns {Ptr} A handle to the installed hook.
         * @throws {TargetError} If the window does not exist.
         * 
         * @remarks Uses the window's PID to set the event hook.
         */
        SetWinEventHook(eventMin, eventMax, Callback, hmodWinEventProc := 0, ThreadID := 0, dwflags := 0) {
            hHook := SetWinEventHook(eventMin, eventMax, Callback, this.__tryPID(), hmodWinEventProc, ThreadID, dwflags)
            this.EventHook := hHook
            return hHook
        }
        SetWinEventHookEventual(eventMin, eventMax, Callback, hmodWinEventProc := 0, ThreadID := 0, dwflags := 0, PollingPeriod := 1000, Priority := 0) {
            Condition := WinExist.Bind(this*)
            SetHook() {
                this.SetWinEventHook(eventMin, eventMax, Callback, hmodWinEventProc, ThreadID, dwflags)
            }
            When Condition, SetHook, PollingPeriod, Priority
        }
        RegisterMoveEvent(Callback) {
            hHook := Window.RegisterMoveEvent(Callback, this.__tryPID())
            this.EventHook := hHook
            return hHook
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