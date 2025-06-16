#Requires AutoHotkey v2.0
#Include <Apparition\AllPrims>
#Include <Apparition\IfMethods>
__ApparitionToStr(obj, IndentSize?, Vertical := true, __nlvl__ := 0) {
    ;Base case.
    if !IsObject(obj) {
        if Type(obj) == "String"
            return '"' . obj . '"'
        if obj.HasMethod("ToString")
            return obj.ToString()
        return "| Type:" Type(obj) " |"
    } 

    ;Set vars per mode.
    if Vertical {
        if !IsSet(IndentSize) {
            IndentSize := 1
        }
        Indent := " ".Repeat(__nlvl__*IndentSize)
        Prefix := "|`n" . Indent
        NestPrefix := "[`n"
        NestSuffix := "`n" .  Indent .  "]"
        ;NextLevel relies on k
    } else {
        if !IsSet(IndentSize) {
            IndentSize := 8
        }
        Indent := " ".Repeat(__nlvl__*IndentSize)
        Prefix := ""
        NestPrefix := "`n "
        NestSuffix := "`n" .  Indent
        nextLevel := __nlvl__ + 1
    }
    ;Build the formatted string.
    if !obj.HasProp("isApparitionCollection") {
        return Indent "| " TryToString(obj, "Object:") " |"
    }

    Str := ""
    For k, v In obj {
        if IsObject(k) {
            k := TryToString(k)
        }
        kLine := "| " . k " = "
        if Vertical {
            nextLevel := __nlvl__ + StrLen(kLine) + StrLen(k) + 1 ;The one is for the "[" at the end of the key line. Adding k length is a hack to allign non mono font. does not fully work, but seems to make it closer.
        }
        ; If the array is nested, unpack internal with recursion
        if IsObject(v){
            v := __ApparitionToStr(v, IndentSize, Vertical, nextLevel)
            v := NestPrefix . v .  NestSuffix
        } else {
            v := __ApparitionToStr(v, IndentSize, Vertical, nextLevel)
        }
        Str .= Prefix . kLine . v " "
    }
    Str .= '|'
    if Vertical { ;few cleanups for edge cases.
        Str := Str.LTrim(' |`n')
        Str := '| ' Str
        Str := Str.Replace('] |', ']')
    }
    return Indent Str 
}