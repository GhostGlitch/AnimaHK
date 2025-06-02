#Requires AutoHotkey v2.0 
#Include <Apparition\Object>
#Include <AquaEx\File>

FileSafeDelete(FilePath) {
  if FileExist(FilePath) {
    FileDelete FilePath
  }
}

JoinPath(Base, Paths*) {

    if Instr(Base, "\") {
        sep := "\"
    } else {
        sep := "/"
    }

    for Path in Paths {
        if (Path == "") {
            continue
        }
        Path := StrReplace(Path, "/", sep)
        Path := StrReplace(Path, "\", sep)
        firstPChar := SubStr(Path, 1, 1)
        lastBChar := SubStr(Base, -1)
        if (firstPChar == ".") {
            Base .= Path
            continue
        }

        if (firstPChar == sep) {
            Path := SubStr(Path, 2)
        }
        if (lastBChar == sep) {
            Base := SubStr(Base, 1,-1)
        }

        Base .= sep . Path
    }
    return Base
}