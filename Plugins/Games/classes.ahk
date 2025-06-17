#Include <Apparition\Window>
#Include <Apparition\Collections>

class Game extends Window {

    __New(WinTitle, VButtons?) {
        super.__New(WinTitle)
        this.LastW := 0
        this.LastH := 0
        this.VButtons := Map()
        if IsSet(VButtons) {
            for button in VButtons {
                this.VButtons[button.name] := button
            }
        }
        if WinExist(WinTitle)
            this.SetVButtonPos()
        this.Hook()
    }
    class VButton {
        __New(name, XMul, YMul) {
            this.name := name
            this.XMul := XMul
            this.YMul := YMul
            this.X := 0
            this.Y := 0
            this.Recalc()
        }
        Recalc(W := A_ScreenWidth, H := A_ScreenHeight) {
            if !(H == 0) {
                this.Y := H * this.YMul
            }
            if !(W == 0) {
                this.X := W * this.XMul
            }
        }
        Press() {
            SafeClick(this.X, this.Y, 25)
        }
    }
    class GameFunc {
        __New(name, key) {
            this.name := name
            this.key := key
        }
        Press() {
            Send(this.key)
        }
        Recalc(*) {
            return
        }
    }

    SetVButtonPos() {
        WinGetClientPos(, , &W, &H, this*)
        if W == this.LastW and H == this.LastH {
            return
        }
        this.LastW := W
        this.LastH := H
        for button in this.VButtons.keys() {
            this.VButtons[button].Recalc(W, H)
        }
    }

    Hook() {
        SetVars(hHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime) {
            if !(event = 0x8004 or event = 0x800C)
                return
            this.SetVButtonPos()
        }
        this.SetWinEventHookEventual(0x8004, 0x800C, SetVars)
    }

    Press(button) {
        this.VButtons[button].Press()
    }
}