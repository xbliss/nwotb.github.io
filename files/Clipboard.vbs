Set fso = CreateObject("Scripting.FileSystemObject")
strFilePath = Replace(WScript.ScriptFullName, WScript.ScriptName, "") & "Clipboard.txt"

'On Error Resume Next

If fso.FileExists(strFilePath) Then

'   msgbox ("Файл --> Буфер")

'Конвертирование UTF-8 --> Unicode
   Set str= CreateObject("ADODB.Stream")
   str.Type = 2
   str.Charset = "UTF-8"
   str.Open()
   str.LoadFromFile(strFilePath)
   Text = str.ReadText
   str.Close()
   str.Charset = "Unicode"
   str.Open()
   str.WriteText(Text)
   str.SaveToFile strFilePath, 2
   str.Close()

'Открытие файла для чтения
   Set file = fso.OpenTextFile(strFilePath, 1, True, -1)
   strContent = file.ReadAll

' Запись в буфер
   Set WshShell = WScript.CreateObject("WScript.Shell")
   WshShell.Run "cmd.exe /c clip < Clipboard.txt", 0, True


'Очистка файла
   file.Close
   fso.DeleteFile(strFilePath), True

Else

'   msgbox ("Буфер --> Файл")

'Открытие файла для записи
   Set file = fso.OpenTextFile(strFilePath, 2, True, -1)

' Чтение буфера и запись в файл
   strClip = CreateObject("htmlfile").ParentWindow.ClipboardData.GetData("text")
   file.Write(strClip)

End if

file.Close
Wscript.Quit