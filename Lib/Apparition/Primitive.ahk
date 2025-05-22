#Requires AutoHotkey v2.0 
#Include <AquaEx\Primitive>

class Apparition_Primitive extends AquaHotkey {
    class Primitive {
        IsFloat => IsFloat(this)
        IsInt => IsInteger(this)
        IsNum => IsNumber(this)
    }
}