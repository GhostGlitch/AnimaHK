; Modified from the "HotstringHelper" script at: https://www.autohotkey.com/docs/v2/lib/Hotstring.htm

#Requires AutoHotkey v2.0
#SingleInstance Force
;;|||TODO|||
 ;;-||Escape-Char|| make \ an escape character.
 ;;-||Bugs||
  ;;+ The 'on the fly' HotString does not respect `n as a newline in it's output. 

MakeHotstring() {
    DefaultInput := "||" GetClip()
    Input := GetInput(DefaultInput)
    While Input and Input.Err {
        Retry := MsgBox(Input.Err "`nWould you like to try again?", , 4)
        if Retry = "Yes" {
            Input := GetInput(DefaultInput)
        } else {
            return false
        }
    }
    if !Input
        return
    
    Hotstring(Input.Options)
    Hotstring(Input.Label, Input.Replacement)  ; Enable the hotstring now.
    ;if Input.Options {
    ;    output := Input.Hotstring
    ;} else {
    output := '`nHotstring("' . Input.Label . '", "' . Input.Replacement . '")'
    ;}
    FileAppend(output, _HH_OutputPath) ; Write the hotstring to source.
    

    ;; Helper Functions:

    ; Does Magic to get the user's clipboard, and parses certain special chars.
    GetClip() {
        ; Get the text currently selected. The clipboard is used instead of
        ; EditGetSelectedText because it works in a greater variety of editors
        ; (namely word processors). Save the current clipboard contents to be
        ; restored later. Although this handles only plain text, it seems better
        ; than nothing:
        ClipboardOld := A_Clipboard
        A_Clipboard := "" ; Must start off blank for detection to work.
        Send "^c"
        if !ClipWait(1)  ; ClipWait timed out.
        {
            A_Clipboard := ClipboardOld ; Restore previous contents of clipboard before returning.
            return
        }
        ; Replace CRLF and/or LF with `n for use in a "send-raw" hotstring:
        ; The same is done for any other characters that might otherwise
        ; be a problem in raw mode:
        ClipContent := StrReplace(A_Clipboard, "``", "````")  ; Do this replacement first to avoid interfering with the others below.
        ClipContent := StrReplace(ClipContent, "`r`n", "``n")
        ClipContent := StrReplace(ClipContent, "`n", "``n")
        ClipContent := StrReplace(ClipContent, "`t", "``t")
        ClipContent := StrReplace(ClipContent, "`;", "```;")
        A_Clipboard := ClipboardOld  ; Restore previous contents of clipboard.
        return ClipContent
    }
    
    ;Makes an Input Box, and parses the user's input. Returning a dict.
    GetInput(DefaultInput) {
        ;Set up the return dict.
        Result := {}
        Result.Err := ""
        Result.Options := ""
        Result.Pattern := ""
        Result.Label := ""
        Result.Replacement := ""
        Result.Hotstring := ""

        ; This will move the input box's caret to a more friendly position:
        SetTimer MoveCursor, 10
        ; Show the input box, providing the default hotstring:
        IB := InputBox("
        (
        Type your abbreviation at the indicated insertion point. You can also edit the replacement text if you wish.

        The format is: Options|Pattern|Replacement

        Example entry: T|btw|by the way
        Would cause "btw" to be replaced with "by the way" in text mode.
        )", "New Hotstring", , DefaultInput)

        if IB.Result = "Cancel"  ; The user pressed Cancel.
            return false

        if RegExMatch(IB.Value, "(?P<Options>.*?)\|(?P<Pattern>.*?)\|(?P<Replacement>.*)", &RexRes)
        {
            ;Set the output dict based on the Regex.
            Result.Options := RexRes.Options
            Result.Pattern := RexRes.Pattern
            Result.Replacement := RexRes.Replacement
            Result.Label := ":" Result.Options ":" Result.Pattern
            Result.Hotstring := Result.Label "::" Result.Replacement
            ;Set Errors
            if !Result.Pattern
                Result.Err := "Pattern Empty."
            else if !Result.Replacement
                Result.Err := "Replacement Empty."
        } else {
            Result.Err := 'Could not parse hotstring.`nMake sure to use the "Options|Pattern|Replacement" format (the first | is needed even with no Options).'
        }
        return Result
    }
    ;Sets the cursor to the start of the Pattern section.
    MoveCursor(){
        WinWait "New Hotstring"
        ; Otherwise, move the input box's insertion point to where the user will type the abbreviation.
        Send "{Home}{Right 1}"
        SetTimer , 0
    }
    
}


