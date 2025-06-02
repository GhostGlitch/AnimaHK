#Requires AutoHotkey v2.0
#Include <Apparition\String>
JoinPath(Base, Paths*) {

    if Base.Contains("\") {
        sep := "\"
    } else {
        sep := "/"
    }

    for Path in Paths {
        if (Path == "") {
            continue
        }
        Path := Path.Replace("/", sep)
        Path := Path.Replace("\", sep)
        firstPChar := Path.Sub(1, 1)
        lastBChar := Base.Sub(-1)
        if (firstPChar == ".") {
            Base .= Path
            continue
        }

        if (firstPChar == sep) {
            Path := Path.Sub(2)
        }
        if (lastBChar == sep) {
            Base := Base.Sub(1,-1)
        }

        Base .= sep . Path
    }
    return Base
}