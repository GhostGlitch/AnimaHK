#Requires AutoHotkey v2.0
#SingleInstance Force
; Modified from the script at: https://www.autohotkey.com/docs/v2/lib/Hotstring.htm

HotstringHelper(){
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
    ShowInputBox(":T:::" ClipContent)

    ;; Helper Functions:
    ShowInputBox(DefaultValue){
        ; This will move the input box's caret to a more friendly position:
        SetTimer MoveCursor, 10
        ; Show the input box, providing the default hotstring:
        IB := InputBox("
        (
        Type your abbreviation at the indicated insertion point. You can also edit the replacement text if you wish.

        Example entry: :T:btw::by the way
        )", "New Hotstring", , DefaultValue)
        
        if IB.Result = "Cancel"  ; The user pressed Cancel.
            return

        if RegExMatch(IB.Value, "(?P<Label>:.*?:(?P<Abbreviation>.*?))::(?P<Replacement>.*)", &Input)
        {
            if !Input.Abbreviation
                ErrText := "You didn't provide an abbreviation."
            else if !Input.Replacement
                ErrText := "You didn't provide a replacement."
            else
            {
                Hotstring Input.Label, Input.Replacement  ; Enable the hotstring now.
                FileAppend "`n" IB.Value, _HH_OutputPath  ; Save the hotstring for later use.
            }
        }
        else
            ErrText := "The hotstring appears to be improperly formatted."

        if IsSet(ErrText)
        {
            Result := MsgBox(ErrText "`nWould you like to try again?",, 4)
            if Result = "Yes"
                ShowInputBox(DefaultValue)
        }
        
        MoveCursor(){
            WinWait "New Hotstring"
            ; Otherwise, move the input box's insertion point to where the user will type the abbreviation.
            Send "{Home}{Right 3}"
            SetTimer , 0
        }
    }
}


