class AquaHotkey_Primitive extends AquaHotkey {
/**
 * AquaHotkey - Primitive.ahk
 * 
 * Author: 0w0Demonic
 * 
 * https://www.github.com/0w0Demonic/AquaHotkey
 * - src/Builtins/Primitive.ahk
 */
class Primitive {
    /**
     * Outputs this variable as text in a message box.
     * @example
     * 
     * "Hello, world!".MsgBox("AquaHotkey", MsgBox.Icon.Info)
     * 
     * @param   {String?}     Title    message box title
     * @param   {Primitive?}  Options  additional `MsgBox` options
     * @return  {this}
     */
    MsgBox(Title?, Options?) {
        MsgBox(this, Title?, Options?)
        return this
    }

    /**
     * Outputs this variable on a tooltip control.
     * @example
     * 
     * "Hello, world!".ToolTip(50, 50, 1)
     * 
     * @param   {Integer?}  x             x-coordinate of the tooltip
     * @param   {Integer?}  y             y-coordinate of the tooltip
     * @param   {Integer?}  WhichToolTip  which tooltip to operate on
     * @return  {this}
     */
    ToolTip(x?, y?, WhichToolTip?) {
        ToolTip(this, x?, y?, WhichToolTip?)
        return this
    }

    /**
     * Outputs this variable using the `Send()` function.
     * @example
     * 
     * "Four score and seven years ago".Send()
     * 
     * @return  {this}
     */
    Send() {
        Send(this)
        return this
    }

    /**
     * Outputs this variable using the `SendText()` function.
     * @example
     * 
     * "Four score and seven years ago".SendText()
     * 
     * @return  {this}
     */
    SendText() {
        SendText(this)
        return this
    }

    /**
     * Outputs this variable using the `SendPlay()` function.
     * @example
     * 
     * "Four score and seven years ago".SendPlay()
     * 
     * @return  {this}
     */
    SendPlay() {
        SendPlay(this)
        return this
    }

    /**
     * Outputs this variable using the `SendEvent()` function.
     * @example
     * 
     * "Four score and seven years ago".SendEvent()
     * 
     * @return  {this}
     */
    SendEvent() {
        SendEvent(this)
        return this
    }

    /**
     * Converts this variable into a float.
     * @example
     * 
     * (1).ToFloat() ; 1.0
     * 
     * @return  {Float}
     */
    ToFloat() => Float(this)

    /**
     * Converts this variable into a number.
     * @example
     * 
     * "912".ToNumber() ; 912
     * "8.2".ToNumber() ; 8.2
     * 
     * @return  {Number}
     */
    ToNumber() => Number(this)

    /**
     * Converts this variable into an integer.
     * @example
     * 
     * (8.34).ToInteger() ; 8
     * 
     * @return  {Integer}
     */
    ToInteger() => Integer(this)

    /**
     * Converts this variable into a string.
     * @example
     * 
     * (12).ToString() ; "12"
     * 
     * @return  {String}
     */
    ToString() => String(this)

    /**
     * Puts this variable into the system clipboard.
     * @example
     * 
     * "This is the new clipboard content".ToClipboard()
     * 
     * @return  {this}
     */
    ToClipboard() => (A_Clipboard := this)

    /**
     * Formats this variable into the given format pattern `Pattern`, followed
     * by zero or more additional arguments `Args*`.
     * @example
     * 
     * "world".FormatTo("{2}, {1}!", "Hello") ; "Hello, world!"
     * 
     * @param   {String}  Pattern  the format pattern to use
     * @param   {Any*}    Args     zero or more additional arguments
     * @return  {String}
     */
    FormatTo(Pattern, Args*) {
        StringReprs := Array()
        StringReprs.Capacity := Args.Length
        for Value in Args {
            if (IsSet(Value)) {
                StringReprs.Push(String(Value))
            } else {
                StringReprs.Length++
            }
        }
        return Format(Pattern, this, StringReprs*)
    }
} ; class Primitive
} ; class AquaHotkey_Primitive extends AquaHotkey