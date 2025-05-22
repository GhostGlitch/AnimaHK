#Requires AutoHotkey v2.0 
#Include <AquaEx\String>


class Apparition_String extends AquaHotkey {
    static WSChars := "`s`t`n`r`v`f"
    class String {
        isApparition => true

        IsSet => IsSet(this)
        IsFloat => IsFloat(this)
        IsInt => IsInteger(this)
        IsNum => IsNumber(this)

        StartsWith(Prefix) {
            return (this.Sub(1, StrLen(Prefix)) = Prefix)
        }
        EndsWith(Suffix) {
            return this.Sub(this.Length - StrLen(Suffix) + 1) = Suffix
        }
        IsIn(Haystack, CaseSense := false, StartingPos := 1, Occurrence := 1) {
            return InStr(Haystack, this, CaseSense, StartingPos, Occurrence)
        }
        Remove(Target := "", CaseSense := false, &OutputVarCount?, Limit := -1) {
            return this.Replace(Target, "", CaseSense, &OutputVarCount, Limit)
        }
        RemoveChars(HitList := ' ', CaseSense := false, &OutputVarCount?) {
            Count := 0
            Chars := StrSplit(HitList)
            for char in Chars {
                this := this.Remove(char, CaseSense, &tempCount)
                Count += tempCount
            }
            if IsSetRef(&OutputVarCount) {
                OutputVarCount := Count
            }
            return this
        }
        RemoveWS(&OutputVarCount?) {
            return this.RemoveChars(Apparition_String.WSChars,,&OutputVarCount?)
        }
        IsSpaceTime() {
            this := this.RemoveWS()
            return this.isTime
        }
    }
}