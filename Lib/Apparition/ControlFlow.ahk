#Requires AutoHotkey v2.0
#Include <Apparition\__Base>

/**
 * Calls a function when a condition is met, if it isn't it waits until it is in a non-blocking way.
 * 
 * @param {Func} Condition Any function which returns a bool indicating when the callback should be executed.
 * @param {Func} Callback The function to execute when the condition is true
 * @param {Integer} [Period=1000] How frequently to poll the condition in milliseconds.
 * @param {Integer} [Priority=0] Thread priority of the timer.
 */
When(Condition, Callback, Period := 1000, Priority := 0) {
    tryDo() {
        if Type(Condition) == "Func" or Type(Condition) == "BoundFunc" {
            Condition := Condition()
        }

        if Condition {
            Callback()
            SetTimer(tryDo, 0) ; Delete timer after success
            return true
        }
        return false
    }
    if !tryDo() {
        SetTimer(tryDo, Period, Priority)
    }
}