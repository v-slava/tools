#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;next song
+F1:: ;the + means shift
Send {Media_Next}
return

;previous song
+F2::
Send {Media_Prev}
return

;play/pause
+F3::
Send {Media_Play_Pause}
return

;stop
+F4::
Send {Media_Stop}
return