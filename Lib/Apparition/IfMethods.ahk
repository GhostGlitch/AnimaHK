#Requires AutoHotkey v2.0 
#Include <AquaHotkey-G\AquaHotkey>
#Include <Apparition\__ToStr>

TryToString(Value, params*) {
    try return Value.ToString(params*)
    try return String(Value)
    return Type(Value)
}

class Apparition_IfMethods extends AquaHotkey {
    class Any {
        TryToString(params*) => TryToString(this, params*)
    }
}