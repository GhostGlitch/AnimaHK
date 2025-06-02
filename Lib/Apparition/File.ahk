#Requires AutoHotkey v2.0 
#Include <Apparition\Object>
#Include <AquaEx\File>

FileSafeDelete(FilePath) {
  if FileExist(FilePath) {
    FileDelete FilePath
  }
}

JoinPath(Base, Paths*) {

    if Instr(Base, "/") {
        sep := "/"
    } else {
        sep := "\"
    }

    for Path in Paths {
        if (Path == "") {
            continue
        }

        firstPChar := SubStr(Path, 1, 1)
        lastBChar := SubStr(Base, -1)
        if (firstPChar == ".") {
            Base .= Path
            continue
        }

        if (firstPChar == "\" or firstPChar == "/") {
            Path := SubStr(Path, 2)
        }
        if (lastBChar == "\" or lastBChar == "/") {
            Path := SubStr(Path, 1,-1)
        }

        Base .= sep . Path
    }
    return Base
}