#Requires AutoHotkey v2.0
#Include <Apparition\__Base>
class STDStream extends Object {
    In := 0
    Out := 0
    Err := 0

    __New() {
        ;StdIn and StdOut only exist when the script is executed in certain contexts.
        try {
            this.In := FileOpen("*", "r", "UTF-8")
        }
        try {
            this.Out := FileOpen("*", "w", "UTF-8")
        } 
        try {
            this.Err := FileOpen("**", "w", "UTF-8")
        }
    }


    static Print(msg) {
        try {
            StdOut := FileOpen("*", "w", "UTF-8")
        } catch {
            return
        }
        StdOut.Write(msg)
        StdOut.Close()
    }
    Print(msg) {
        if this.Out == 0
            return
        this.Out.Write(msg)
        this.Out.Read() ; Flushes the stream.
    }

    static Println(msg) {
        STDStream.Print(msg . "`n")
    }
    Println(msg) {
        this.Print(msg . "`n")
    }


    static PrintErr(msg) {
        try {
        stdErr := FileOpen("**", "w", "UTF-8")
        } catch {
            STDStream.__noStdErr(msg)
            return
        }
        stdErr.Write(msg)
        stdErr.Close()
    }
    PrintErr(msg) {
        if this.Err == 0 {
            STDStream.__noStdErr(msg)
            return
        }
        this.Err.Write(msg)
    }

    static Read(msgLen := 0xfff) {
        try {
            StdIn := FileOpen("*", "r", "UTF-8")
        } catch {
            STDStream.__noStdIn()
            return
        }
        out := StdIn.Read(msgLen)
        StdIn.Close()
        return out
    }
    Read(msgLen := 0xfff) {
        if this.In == 0 {
            STDStream.__noStdIn()
            return
        }
        return this.In.Read(msgLen)
    }

    static Readln() {
        try {
            StdIn := FileOpen("*", "r", "UTF-8")
        } catch {
            STDStream.__noStdIn()
            return
        }
        out := StdIn.ReadLine()
        StdIn.Close()
        return out
    }
    Readln() {
        if this.In == 0 {
            STDStream.__noStdIn()
            return
        }
        return this.In.ReadLine()
    }

    static __noStdErr(msg) {
        e := "StdErr does not exist."
        try {
            e .= "`nError was: "  . msg
        }
        throw TargetError(e, -2)
    }
    static __noStdIn() {
        throw TargetError("Stdin does not exist", -2)
    }


    __tryClose(file) {
        if file != 0
            file.Close()
    }

    __Delete() {
        this.__tryClose(this.Out)
        this.__tryClose(this.Err)
        this.__tryClose(this.In)
    }
}