#Requires AutoHotkey v2.0 
;;TODO Either find way to make MsgBox use Mono font, or else do char loop nonsene to double indent for letter/num chars.
#Include <AquaHotkey-G\AquaHotkey>
#Include <Apparition\__ToStr>
#Include <AquaEx\Map>


class Apparition_Map extends AquaHotkey {
    class Map {
        isApparition => true
        isApparitionCollection => true

        ToString(IndentSize?, Vertical := true) { ;Allow direct calling on Gmap instances.
            return __ApparitionToStr(this, IndentSize?, Vertical)
        }
        static Display(obj, IndentSize?, Vertical := true) {
            MsgBox(__ApparitionToStr(obj, IndentSize?, Vertical))
        }
        /**
         * Displays the map's string representation in a message box.
         * 
         * @example
         * 
         * Map(1, 2, 3, 4).Display(, true)
         * 
         * @param {number} [IndentSize] Optional indentation size for nested structures.
         * @param {boolean} [Vertical=true] Optional flag to use an alternate more vertical representation.
         */
        Display(IndentSize?, Vertical := true) {
            MsgBox(this.ToString(IndentSize?, Vertical))
        }
        
        /** 
         * Adds a key-value pair to the map and returns the map itself.
         * Equivalent to 'SomeMap[Key] := Value'.
         *
         * @example
         * 
         * Map(1, 2, 3, 4).Push("foo", "bar")
         * 
         * @param {*} Key The key to add to the map
         * @param {*} Value The value associated with the key
         * @return {this} The current map instance, allowing method chaining
         */
        Push(Key, Value) {
            this[Key] := Value
            return this
        }
        
        ; Alt for Array.Push
        Add(Key, Value) {
            this[Key] := Value
            return this
        }

        ; Alt for Array.Delete
        Pop(Key) {
            return this.Delete(Key)
        }
    } 

    static __Test() {
            MsgBox("Apparition Map Test`nShould display a Map with 9K-V pairs from K0 to K8. With K4 being a map, and K4.0 being an array.`nWill Show in both normal and Vertical mode")
        g := Map(
            "K0", "V0",
            "K1", "V1",
            "K2", "V2",
            "K3", "V3",
            "K4", Map(
                "K4.0", ["V4.0.0", "V4.0.1", "V4.0.2", "V4.0.3"],
                "K4.1", "V4.1",
                "K4.2", "V4.2",
                "K4.3", "V4.3"),
            "K5", "V5",
            "K6", "V6",
            "K7", "V7",
            "K8", 8
        )
        g.Display()
        g.Display(,false)
    }
}
if A_ScriptFullPath == A_LineFile{
    Apparition_Map.__Test()
}