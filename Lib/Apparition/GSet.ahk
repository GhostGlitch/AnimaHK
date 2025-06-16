#Include <Apparition\Map>
#Include <Apparition\Array>

class GSet extends Map {
    Ordered := Array()
    __New(keys*) {
        this.Default := false
        return this.Push(keys*)
    }
    ;__Enum(n) => this.Ordered.__Enum(n)

    Push(keys*) {
        for index, value in keys {
            this.Ordered.Push(value)
            this[value] := true
        }
        this.Ordered := this.Ordered.Distinct()
        return this
    }
    Set(keys*) {
        return this.Push(keys*)
    }

    PushIfAbsent(Keys*) {
        for index, value in Keys {
            if !this.Has(value) {
                this.Ordered.Push(value)
                this[value] := true
            }
        }
        this.Ordered := this.Ordered.Distinct()
        return this
    }
    PutIfAbsent(Keys*) {
        return this.PushIfAbsent(Keys*)
    }
    SetIfAbsent(Keys*) {
        return this.PushIfAbsent(Keys*)
    }

    Delete(key) {
        super.Delete(key)
        this.Ordered := this.Ordered.RemoveIf(x => x == key)
        return this
    }

    ToString(IndentSize?, Vertical := true) { 
        return __ApparitionToStr(this.Ordered, IndentSize?, Vertical)
    }

    Values() {
        return this.Keys()
    }
}
