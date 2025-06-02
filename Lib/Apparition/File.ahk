#Requires AutoHotkey v2.0 
#Include <Apparition\Object>
#Include <AquaEx\File>

FileSafeDelete(FilePath) {
  if FileExist(FilePath) {
    FileDelete FilePath
  }
}