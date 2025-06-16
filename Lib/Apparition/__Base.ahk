#Requires AutoHotkey v2.0
#Include <AquaHotkey-G\AquaHotkey>

class Appa extends Class {
    static __New() {
        this.__ := Map(
            "Debug", false,
            "Prod", false
        )
        this.quiet := false
    }
    static Debug[verbose := true]
    {
        get => this.__["Debug"]
        set => this.SetDebug(value, verbose)
    }
    static SetDebug(mode := true, verbose := true) {
        if this.__["Prod"] {
            return
        }
        if mode and !this.__["Debug"] and verbose {
            MsgBox("Apparition Debug Mode Enabled")
        }
        this.__["Debug"] := mode
    }
    static Prod {
        get => this.__["Prod"]
        set => this.SetProd(Value)
    }
    static SetProd(mode := true) {
        if mode {
            this.__["Prod"] := true
            this.__["Debug"] := false
        } else {
            this.__["Prod"] := false
        }
    }
}

DebugBox(Text?, Title?, Options?) {
    if Appa.Debug {
        return MsgBox(Text?, Title?, Options?)
    }
}