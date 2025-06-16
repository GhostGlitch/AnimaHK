SafeClick(x?, y?, delay := A_MouseDelay, Options*)
{
    oldDelay := SetMouseDelay(0)
    oldSend := SendMode("Event")
    for option in Options {
        if option == "Rel" or option == "Relative" or option == "R" {
            Rel := "R"
        }
    }

    BlockInput "On"
    SystemCursor("Hide")
    MouseGetPos &oldx, &oldy
    x := (x ?? oldx)
    y := (y ?? oldy)
    ;DllCall("SetCursorPos", "int", x, "int", y)  ; The first number is the X-coordinate and the second is the Y (relative to the screen).
    MouseMove(x, y, 0, Rel?)
    Sleep delay//2
    Click("D", Options*)
    Sleep delay
    Click("U", Options*)
    Sleep delay
    MouseMove(oldx, oldy, 0, Rel?)
    SystemCursor("Show")
    BlockInput "Off"
    SetMouseDelay oldDelay
    SendMode oldSend
}


OnExit (*) => SystemCursor("Show")  ; Ensure the cursor is made visible when the script exits.

SystemCursor(cmd)  ; cmd = "Show|Hide|Toggle|Reload"
{
    static visible := true, c := Map()
    static sys_cursors := [32512, 32513, 32514, 32515, 32516, 32642
                         , 32643, 32644, 32645, 32646, 32648, 32649, 32650]
    if (cmd = "Reload" or !c.Count)  ; Reload when requested or at first call.
    {
        for i, id in sys_cursors
        {
            h_cursor  := DllCall("LoadCursor", "Ptr", 0, "Ptr", id)
            h_default := DllCall("CopyImage", "Ptr", h_cursor, "UInt", 2
                , "Int", 0, "Int", 0, "UInt", 0)
            h_blank   := DllCall("CreateCursor", "Ptr", 0, "Int", 0, "Int", 0
                , "Int", 32, "Int", 32
                , "Ptr", Buffer(32*4, 0xFF)
                , "Ptr", Buffer(32*4, 0))
            c[id] := {default: h_default, blank: h_blank}
        }
    }
    switch cmd
    {
    case "Show": visible := true
    case "Hide": visible := false
    case "Toggle": visible := !visible
    default: return
    }
    for id, handles in c
    {
        h_cursor := DllCall("CopyImage"
            , "Ptr", visible ? handles.default : handles.blank
            , "UInt", 2, "Int", 0, "Int", 0, "UInt", 0)
        DllCall("SetSystemCursor", "Ptr", h_cursor, "UInt", id)
    }
}