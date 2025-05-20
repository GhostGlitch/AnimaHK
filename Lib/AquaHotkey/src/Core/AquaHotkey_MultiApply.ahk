/**
 * AquaHotkey - AquaHotkey_MultiApply.ahk
 * 
 * Author: 0w0Demonic
 * 
 * https://www.github.com/0w0Demonic/AquaHotkey
 * - src/Core/AquaHotkey_MultiApply.ahk
 * 
 * `AquaHotkey_MultiApply` is a special class that allows you to copy its
 * contents into multiple specified target classes.
 * 
 * This is especially useful when multiple unrelated classes (like `Gui.Button`
 * and `Gui.CheckBox`) should share a common set of methods or properties
 * defined only once in the script.
 * 
 * To use this class, create a subclass of `AquaHotkey_MultiApply` and call
 * `super.__New()` within the static constructor, passing the class(es)
 * you want to copy into.
 * 
 * @example
 * 
 * class Tanuki extends AquaHotkey {
 *     class Gui {
 *         class Button {
 *             ButtonProp() => MsgBox("I'm a Button!")
 *         }
 * 
 *         class ButtonControlsCommon extends AquaHotkey_MultiApply {
 *             static __New() {
 *                 super.__New(Tanuki.Gui.Button, Tanuki.Gui.CheckBox)
 *             }
 * 
 *             CommonProp() => MsgBox("I'm a CheckBox or a Button!")
 *         }
 * 
 *         class CheckBox {
 *             CheckBoxProp() => MsgBox("I'm a CheckBox!")
 *         }
 *     }
 * }
 */
class AquaHotkey_MultiApply extends AquaHotkey_Ignore {
    /**
     * Static class initializer that copies properties and methods into one or
     * many destination classes. An error is thrown if a subclass calls this
     * method without passing any parameters.
     * 
     * @example
     * 
     * ; class Tanuki extends AquaHotkey {
     * ; class Gui {
     * class CommonButtonControls extends AquaHotkey_MultiApply {
     *     static __New() {
     *         ; specify one or more sources to copy from
     *         super.__New(Tanuki.Gui.Button, Tanuki.Gui.ComboBox)
     *     }
     * }
     * class Button   { ... }
     * class ComboBox { ... }
     * ; }
     * ; }
     * 
     * @param   {Object*}  Targets  where to copy properties and methods into
     */
    static __New(Targets*) {
        if (this == AquaHotkey_MultiApply) {
            return
        }
        if (!Targets.Length) {
            throw ValueError("No target class provided")
        }

        ; Use the same method as `AquaHotkey_Backup`, but with the parameters
        ; swapped around.
        for Target in Targets {
            (AquaHotkey_Backup.__New)(Target, this)
        }
    }
}