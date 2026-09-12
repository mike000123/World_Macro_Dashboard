' Starts the dev server minimized (small taskbar icon, doesn't pop up on screen),
' then opens the dashboard in your browser after it's ready.
' This uses VBScript's window-state control instead of "start /min", which is
' more reliable on Windows 11 (the batch /min flag is often ignored when
' Windows Terminal is set as the default console host).

Set fso = CreateObject("Scripting.FileSystemObject")
Set WshShell = CreateObject("WScript.Shell")

folder = fso.GetParentFolderName(WScript.ScriptFullName)

' Window style 7 = minimized, without stealing focus or popping up
WshShell.Run "cmd.exe /c cd /d """ & folder & """ && npm run dev", 0, False

' Give the server a few seconds to boot up before opening the browser
WScript.Sleep 4000

' Open the dashboard in the default browser
WshShell.Run "http://localhost:5173/", 1, False
