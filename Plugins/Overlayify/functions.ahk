#Requires AutoHotkey v2.0
#SingleInstance Force

OverlayedWins := Map()      ; A dictionary of all windows that have been altered, and their original properties.

/**
  Alternate a given window between its normal state and an "overlay" state.
    Overlay windows are always on top, transparent, and do not intercept mouse inputs.
  @param {int}  Win      Target window HWND. Default: Active Window.
  @param {int}  Trans    Transparency (0-255). Ignored if window already modified. Default: 187.
  @param {bool} Verbose  If true, print he current list of windows after run. Default: false.
 */
Overlayify(Win := "", Trans := 187, verbose := false) {
  if not Win
    Win := WinExist("A")                  ; "A" specifies active window
  else
    Win := WinExist("ahk_id" Win)         ; If a specific HWIND is passed, use that

if not OverlayedWins.Has(Win) {           ; Update window properties.
    OldEx := WinGetExStyle()
    OverlayedWins[Win] := Map(            ; Store orignal values for undoing. 
      "Ex", OldEx,
      "Trans", WinGetTransparent(),
      "Top", OldEx & 0x8 == 0x8 
    )
    WinSetAlwaysOnTop true
    WinSetExStyle +0x80020                ; Magic number that makes the window clickthru.
    WinSetTransparent Trans
  } else {                                ; Set all properties to their original value
    WinSetAlwaysOnTop OverlayedWins[Win]["Top"]   
    WinSetExStyle OverlayedWins[Win]["Ex"]
    WinSetTransparent OverlayedWins[Win]["Trans"]
    OverlayedWins.Delete(Win)
  }
  if verbose
    MsgBox ArrToStr(OverlayedWins)        ; Debug Print
}

; Returns all windows to their default state.
UnOverlayAll() {
  WinList := []
  for i, v in OverlayedWins {
    WinList.Push(i)
  }
  for win in WinList {
    Overlayify(win)
  }
} 

; Flattens any array or map to a string. Should be slpit into a lib. But I'm lazy.
ArrToStr(Array) {
  Str := ""
  For k, v In Array {                         
    if IsObject(v) {                      ; If the array is nested, unpack internal with recursion
      v := "[ " . ArrToStr(v) " ]"
    }
    Str .= " | " . k  " = " . v
    Str := LTrim(Str, " | ") ; Remove leading pipes (|)
  }
  return Str
}