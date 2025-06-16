#Requires AutoHotkey v2.0
#Include <Apparition\AllPrims>
#Include <Apparition\Map>
#Include <Apparition\Array>
#Include <Apparition\GSet> 
;;TODO: Improve Hotkey Cleanup in getters, make it handle more special symbols.
;;TODO: Make Key Repeat Option.


class ToggleKey extends Object {
    static DebugMode := false
    static InputToTarget := Map().SetDefault(false)
    static TargetToInst := Map().SetDefault(false)
    static InputToOptions := Map()

    static Call(inputKey, targetKey := inputKey, RepeatInterval?, TargetWin?, Options?,  UseHook := false) {
        ;Register in maps
        if ToggleKey.TargetToInst.Has(targetKey) {
            Instance := ToggleKey.TargetToInst[targetKey]
            Instance.AddInputKeys(inputKey)
        } else {
            Instance := ToggleKey.TKInstance(targetKey,RepeatInterval?,TargetWin?,inputKey)
        }
        ToggleKey.TargetToInst[targetKey] := Instance

        if ToggleKey.InputToTarget.Has(inputKey) {
            oldTarget := ToggleKey.InputToTarget[InputKey]
            ToggleKey.TargetToInst[oldTarget].DeleteInputKey(inputKey)
            if ToggleKey.TargetToInst[oldTarget].InputKeys.Count == 0 {
               ToggleKey.TargetToInst.Delete(oldTarget)
            }
        }
        ToggleKey.InputToTarget[inputKey] := targetKey
        if IsSet(Options) {
            ToggleKey.InputToOptions[inputKey] := Options
        }
        ;Registeration finished

        if ToggleKey.InputToOptions.Has(inputKey) {
            Options := ToggleKey.InputToOptions[inputKey]
        }
        if !IsSet(RepeatInterval) {
            TkCallback := ToggleKey__Callback
        } else {
            Instance.Interval := RepeatInterval
            TkCallback := ToggleKey__Repeat_Callback
        }

        if IsSet(TargetWin) {
            Instance.TargetWin := TargetWin
            HotIfWinActive(TargetWin)
        } else {
            Instance.TargetWin := ""
        }

        if targetKey == inputKey or UseHook {
            Hotkey("$" inputKey, TkCallback, Options?)
        } else {
            Hotkey(inputKey, TkCallback, Options?)
        }

        if IsSet(TargetWin) {
            HotIf
        }
        return Instance
    }

    static __Enum => this.TargetToInst.__Enum
    static Display(Title?) => this.TargetToInst.Display(,false,Title?)

    static GetByInput(InputKey) {
        InputKey := InputKey.Remove("$")
        return ToggleKey.TargetToInst[ToggleKey.InputToTarget[InputKey]]
    }
    static GetByTarget(TargetKey) {
        TargetKey := TargetKey.Remove("$")
        return ToggleKey[TargetKey]
    }
    static GetTarget(InputKey) {
        InputKey := InputKey.Remove("$")
        return ToggleKey.InputToTarget[InputKey]
    }

    class TKInstance extends Object {
        __New(OutputKey, Interval := 100, TargetWin?, InputKeys*) {
            this.OutputKey := OutputKey
            this.InputKeys := GSet(InputKeys*)
            this.IsDown := false
            this.TargetWin := IsSet(TargetWin) ? TargetWin : ""
            this.Interval := Interval
            this.timer := ObjBindMethod(this, "Press")
            this.IsRepeating := false
        }
        AddInputKeys(InputKeys*) {
            this.InputKeys.Push(InputKeys*)
        }
        AddInputKey(InputKey) {
            this.InputKeys.Push(InputKey)
        }
        DeleteInputKey(InputKey) {
            this.InputKeys.Delete(InputKey)
        }

        StartRepeat() {
            SetTimer this.timer, this.Interval
            this.IsRepeating := true
        }
        Release() {
            SetTimer this.timer, 0
            SendInput("{" this.OutputKey " up}")
            this.IsRepeating := false
        }
        Press() {
            if this.TargetWin != "" and !WinActive(this.TargetWin) {
                this.Release()
                return
            }
            SendInput("{" this.OutputKey " up}")
            SendInput("{" this.OutputKey " down}")
        }

        ToString() {
            held := this.IsDown ? "HELD, " : ""
            return "ToggleKey(" held "Key: " this.OutputKey " => " this.InputKeys.ToString()  ")"
        }

    }

    static __test() {
        ;MsgBox("Should create Toggle Hotkeys of a=>w, s=>q, d=>q, and f=>f, and display those in a MsgBox.", "ToggleKey Test")
        ToggleKey("a", "q")
        ToggleKey("s", "q")
        ToggleKey("d", "q")
        ToggleKey("a", "w")
        ToggleKey("s", "w")
        ToggleKey("s", "q")
        ToggleKey("f")
        ToggleKey("g", "g", 100)
        ToggleKey("h", "g")
        ToggleKey("j", "g", 100)
        ToggleKey.Display("ToggleKey Test")
    }
}


ToggleKey__Callback(HotkeyName) {
    target := ToggleKey.GetTarget(HotkeyName)
    Instance := ToggleKey.GetByInput(HotkeyName)
    Instance.IsDown := !Instance.IsDown
    If Instance.IsDown {
        Instance.Press()
    } else {
        Instance.Release()
    }
}
ToggleKey__Repeat_Callback(HotkeyName) {
    target := ToggleKey.GetTarget(HotkeyName)
    Instance := ToggleKey.GetByInput(HotkeyName)
    if !Instance.IsRepeating {
        Instance.IsDown := true
    } else {
        Instance.IsDown := false
    }
    If Instance.IsDown {
        Instance.StartRepeat()
    } else {
        Instance.Release()
    }
}

If A_ScriptFullPath == A_LineFile {
    ToggleKey.__test()
}
#HotIf A_ScriptFullPath == A_LineFile or ToggleKey.DebugMode
F1:: {
    ToggleKey.Display()
}
#HotIf