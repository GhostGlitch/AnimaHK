#Requires AutoHotkey v2.0 
#Include <AquaHotkey-G\AquaHotkey>
#Include <Apparition\__Base>
#Include <Apparition\IfMethods>


class Apparition_MsgBox extends AquaHotkey {
    class MsgBox {
        static Call(Text?, Title?, Options?) {
            try return (Func.Prototype.Call)(Text?, Title?, Options?)
            try {
                if IsSet(Text) {
                    Text := Text.TryToString()
                }
                if IsSet(Title) {
                    Title := Title.TryToString().Replace("`n", "\n")
                }
                return (Func.Prototype.Call)(this, Text?, Title?, Options?)
            } catch Error as e {
                throw Error(e.Message, -2, e.Extra)
            }
        } 
    }
}