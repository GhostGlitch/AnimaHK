#Requires AutoHotkey v2.0 
#Include <AquaHotkey-G\AquaHotkey>
#Include <Apparition\Primitive>
#Include <AquaEx\String>

class Apparition_String extends AquaHotkey {
    static WSChars := "`s`t`n`r`v`f"
    class String {
        isApparition => true
        Indent(Level := 2, PaddingStr := " ") {
            return this.LPad(PaddingStr, Level)
        }
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
            return this.RemoveChars(Apparition_String.WSChars, , &OutputVarCount?)
        }
        LRTrim(OmitCharsL?, OmitCharsR?) {
            return this.LTrim(OmitCharsL?).RTrim(OmitCharsR?)
        }
        LRPad(PaddingStrL := " ", PaddingStrR := " ", n := 1) {
            return this.LPad(PaddingStrL, n).Rpad(PaddingStrR, n)
        }
        IsSpaceTime() {
            this := this.RemoveWS()
            return this.isTime
        }
        PrependIfNot(Prefix) {
            return this.StartsWith(Prefix) ? this : Prefix . this
        }
        AppendIfNot(Suffix) {
            return this.EndsWith(Suffix) ? this : this . Suffix
        }
        SurroundIfNot(Prefix, Suffix := Prefix) {
            return this.PrependIfNot(Prefix).AppendIfNot(Suffix)
        }
    }
}

class Apparition_String_Static extends AquaHotkey {
    static WSChars := "`s`t`n`r`v`f"
    class String {
        static IsDigit(Str)  => IsDigit(Str)
        static IsHexit(Str)  => IsXDigit(Str)
        static IsAlpha(Str)  => IsAlpha(Str)
        static IsUpper(Str)  => IsUpper(Str)
        static IsLower(Str)  => IsLower(Str)
        static IsAlnum(Str)  => IsAlnum(Str)
        static IsSpace(Str)  => IsSpace(Str)
        static IsTime(Str)   => IsTime(Str)

        static IsEmpty(Str) => (Str == "")

        static Lines(Str) => Str.Lines()
        static Before(Str, Pattern, CaseSense := false, StartingPos := 1, Occurrence := 1) {
            return Str.Before(Pattern, CaseSense, StartingPos, Occurrence)
        }
        static BeforeRegex(Str, Pattern, StartingPos := 1) {
            return Str.BeforeRegex(Pattern, StartingPos)
        }
        static Until(Str, Pattern, CaseSense := false, StartingPos := 1, Occurrence := 1) {
            return Str.Until(Pattern, CaseSense, StartingPos, Occurrence)
        }
        static UntilRegex(Str, Pattern, StartingPos := 1) {
            return Str.UntilRegex(Pattern, StartingPos)
        }
        static From(Str, Pattern, CaseSense := false, StartingPos := 1, Occurrence := 1) {
            return Str.From(Pattern, CaseSense, StartingPos, Occurrence)
        }
        static FromRegex(Str, Pattern, StartingPos := 1) {
            return Str.FromRegex(Pattern, StartingPos)
        }
        static After(Str, Pattern, CaseSense := false, StartingPos := 1, Occurrence := 1) {
            return Str.After(Pattern, CaseSense, StartingPos, Occurrence)
        }
        static AfterRegex(Str, Pattern, StartingPos := 1) {
            return Str.AfterRegex(Pattern, StartingPos)
        }
        static Repeat(Str, n) {
            return Str.Repeat(n)
        }
        static Reversed(Str) {
            return Str.Reversed()
        }

        static SplitPath(Str) {
            return SplitPath(Str)
        }

        static RegExMatch(Str, Pattern, &MatchObj?, StartingPos := 1) {
            return Str.RegExMatch(Pattern, &MatchObj, StartingPos)
        }

        static RegExReplace(Str, Pattern, Replace?, &Count?, Limit?, Start?) {
            return Str.RegExReplace(Pattern, Replace?, &Count, Limit?, Start?)
        }

        static Match(Str, Pattern, StartingPos := 1) {
            return Str.Match(Pattern, StartingPos)
        }

        static MatchAll(Str, Pattern, StartingPos := 1) {
            return Str.MatchAll(Pattern, StartingPos)
        }

        static Capture(Str, Pattern, StartingPos := 1) {
            return Str.Capture(Pattern, StartingPos)
        }

        static CaptureAll(Str, Pattern, StartingPos := 1) {
            return Str.CaptureAll(Pattern, StartingPos)
        }

        static Insert(Str1, Str2, Position := 1) {
            return Str1.Insert(Str2, Position)
        }

        static Overwrite(Str1, Str2, Position := 1) {
            return Str1.Overwrite(Str2, Position)
        }

        static Delete(Str, Position, Length := 1) {
            return Str.Delete(Position, Length)
        }

        static LPad(Str, PaddingStr := " ", n := 1) {
            return Str.LPad(PaddingStr, n)
        }

        static RPad(Str, PaddingStr := " ", n := 1) {
            return Str.RPad(PaddingStr, n)
        }

        static WordWrap(Str, n := 80) {
            return Str.WordWrap(n)
        }

        static Trim(Str, OmitChars?) => Trim(Str, OmitChars?)

        static LTrim(Str, OmitChars?) => LTrim(Str, OmitChars?)

        static RTrim(Str, OmitChars?) => RTrim(Str, OmitChars?)

        static Format(Str, Args*)     => Format(Str, Args.Map(String)*)
        static FormatWith(Str, Args*) => Format(Str, Args.Map(String)*)

        static Lower(Str) => StrLower(Str)
        static ToLower(Str)  => StrLower(Str)

        static Upper(Str)      => StrUpper(Str)
        static ToUpper(Str)    => StrUpper(Str)
        static Capitalize(Str) => StrUpper(Str)
        static Cap(Str)        => StrUpper(Str)

        static Title(Str) => StrTitle(Str)
        static ToTitle(Str)  => StrTitle(Str)

        static Replace(Str, Pattern, Rep := "", CaseSense := false, &Out?, Limit := -1) {
            return Str.Replace(Pattern, Rep, CaseSense, &Out, Limit)
        }

        static Split(Str, Delimiters := "", OmitChars?, MaxParts?) {
            return Str.Split(Delimiters, OmitChars?, MaxParts?)
        }

        static InStr(Str, Pattern, CaseSense := false, StartingPos := 1, Occurrence := 1) {
            return InStr(Str, Pattern, CaseSense, StartingPos, Occurrence)
        }
        static Contains(Str, Pattern, CaseSense := false, StartingPos := 1, Occurrence := 1) {
            return InStr(Str, Pattern, CaseSense, StartingPos, Occurrence)
        }
        static Has(Str, Pattern, CaseSense := false, StartingPos := 1, Occurrence := 1) {
            return InStr(Str, Pattern, CaseSense, StartingPos, Occurrence)
        }

        static Sub(Str, Start, Length?) => SubStr(Str, Start, Length?)

        static Len(Str)  => StrLen(Str)

        static Size(Str, Encoding?) { ;Might not work
            return Str.Size(Encoding?)
        }

        static Compare(Str, Other, CaseSense := false) => StrCompare(Str, Other, CaseSense)
                Indent(Level := 2, PaddingStr := " ") {
            return this.LPad(PaddingStr, Level)
        }
        static StartsWith(Str, Prefix) {
            return Str.StartsWith(Prefix)
        }
        static EndsWith(Str, Suffix) {
            return Str.EndsWith(Suffix)
        }
        static Remove(Str, Target := "", CaseSense := false, &OutputVarCount?, Limit := -1) {
            return Str.Remove(Target, CaseSense, &OutputVarCount, Limit)
        }
        static RemoveChars(Str, HitList := ' ', CaseSense := false, &OutputVarCount?) {
            return Str.RemoveChars(HitList, CaseSense, &OutputVarCount)
        }
        static RemoveWS(Str, &OutputVarCount?) {
            return Str.RemoveWS(&OutputVarCount)
        }
        static LRTrim(Str, OmitCharsL?, OmitCharsR?) {
            return Str.LRTrim(OmitCharsL?, OmitCharsR?)
        }
        static LRPad(Str, PaddingStrL := " ", PaddingStrR := " ", n := 1) {
            return Str.LRPad(PaddingStrL, PaddingStrR, n)
        }
        static IsSpaceTime(Str) {
            return Str.IsSpaceTime()
        }
        static PrependIfNot(Str, Prefix) {
            return Str.StartsWith(Prefix) ? Str : Prefix . Str
        }
        static AppendIfNot(Str, Suffix) {
            return Str.EndsWith(Suffix) ? Str : Str . Suffix
        }
        static SurroundIfNot(Str, Prefix, Suffix := Prefix) {
            return Str.PrependIfNot(Prefix).AppendIfNot(Suffix)
        }
    }
} 