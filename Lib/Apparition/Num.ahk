#Requires AutoHotkey v2.0 
#Include <Apparition\Primitive>
#Include <AquaEx\Number>

class Apparition_Num extends AquaHotkey {
    class Number {
        IsEven => Mod(this, 2) == 0
        IsOdd => Mod(this, 2) == 1
    }
}