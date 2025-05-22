#Requires AutoHotkey v2.0 
;;TODO Either find way to make MsgBox use Mono font, or else do char loop nonsene to double indent for letter/num chars.
#Include <AquaEx\Array>

#Include <Apparition\__ToStr>


class Apparition_Array extends AquaHotkey {
    class Array {
        isApparition => true
        isApparitionCollection => true

        ToString(IndentSize?, Vertical := true) { ;Allow direct calling on Gmap instances.
            return __ApparitionToStr(this, IndentSize?, Vertical)
        }
        static Display(obj, IndentSize?, Vertical := true) {
            MsgBox(__ApparitionToStr(obj, IndentSize?, Vertical))
        }
        Display(IndentSize?, Vertical := true) {
            MsgBox(this.ToString(IndentSize?, Vertical))
        }
    }
    static __Test() {
            MsgBox("Apparition Array Test`nShould display an Array with 9 values from K0 to K8. With K4 being a map, and K4.0 being an array.`nWill Show in both normal and Vertical mode")
        g := Array(
            "K0", "K1", "K2", "K3", 
            Map(
                "K4.0", ["V4.0.0", "V4.0.1", "V4.0.2", "V4.0.3"],
                "K4.1", "V4.1",
                "K4.2", "V4.2",
                "K4.3", "V4.3"),
            "K5", "K6", "K7", "K8"
        )
        g.Display()
        g.Display(,false)
    }
}
if A_ScriptFullPath == A_LineFile{
    Apparition_Array.__Test()
}
