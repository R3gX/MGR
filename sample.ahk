#Include %A_ScriptDir%\MGR.ahk
#Include %A_ScriptDir%\MGR_UDF.ahk

mgr_Config := A_ScriptDir "\Gestures.ini"
Return

Label_Test:
MsgBox, % "Current subroutine : " A_ThisLabel
Return

#&::ExitApp

Msg(txt)
{
	MsgBox, % A_ThisFunc "()`n" txt
}