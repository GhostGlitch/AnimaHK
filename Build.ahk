#Requires AutoHotkey v2.0
#SingleInstance Force
DEFSCRIPT := "ahkAutorun.ahk" ; name AND extension of the script if no arg.
DEFICON := "AHK" ; name of the icon if no arg.

if A_Args.Length > 3  {
    MsgBox "Usage: AhkCompile.ahk [SourcePath] [IconName]? [CompilerPath]?"
    ExitApp
}

; Set all Params to either empty or passed args
SrcPath := ""
IconName := ""
CompPath := ""
if A_Args.Length > 0 {
    SrcPath := A_Args[1]
    if A_Args.Length >1 {
        IconName := A_Args[2] 
        if A_Args.Length >2  {
            CompPath := A_Args[3] 
        }
    }
}

; Set Default Compiler Path if not passed.
if not CompPath {
    CompPath := RegRead("HKLM\SOFTWARE\AutoHotkey", "InstallDir") "\Compiler\Ahk2Exe.exe"
}

; Set File Path to default if not passed (DEFSCRIPT in script DIR)
if not SrcPath {
    SrcPath := JoinPath(A_ScriptDir, DEFSCRIPT)
}

; Get Script Name and Dir
SplitPath(SrcPath,, &ScriptDir,, &ScriptName)

; Set Icon to Script.ico if not passed.
if not IconName {
    IconName := ScriptName
    ;IconName := DEFICON
}

; Build Paths
OutputPath := JoinPath(ScriptDir, ScriptName, ".exe")
IconPath := JoinPath(ScriptDir, IconName, ".ico")
MahkPath := JoinPath(ScriptDir, ScriptName, ".m.ahk")

; Run the script's Mahk if it has one.
if FileExist(MahkPath) {
    RunWait MahkPath
}

; Kill and remove previous ver (Compiler get's mad if old file exists)
While ProcessExist(ScriptName . ".exe")
    ProcessClose ScriptName . ".exe"
FileTryDelete(OutputPath)

; Build the Compiler Arguments. Including setting icon to Script.ico or DEFICON.ico or nothing.
CompArgs :=
    " /in " . SrcPath .
    " /out " . OutputPath
if FileExist(IconPath) {
    CompArgs .= " /icon " . IconPath
} else if (DEFICON != "") {
    IconPath := JoinPath(ScriptDir, DEFICON, ".ico")
    if FileExist(IconPath) {
        CompArgs .= " /icon " . IconPath
    }
}

; Compile
RunWait CompPath CompArgs
; RUN
Run OutputPath


; Should be a lib.
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

; Should be a lib.
FileTryDelete(FilePath) {
    if FileExist(FilePath) {
        FileDelete FilePath
    }
}