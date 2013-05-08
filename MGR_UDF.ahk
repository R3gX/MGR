Win_Minimize(){ ; Minimize active window
	WinMinimize, A
}

Win_Maximize(){ ; Maximize or Restore the window
	WinGet, WinMinMax, MinMax, A
	If (WinMinMax==1)
		WinRestore, A
	Else
		WinMaximize, A
}

Win_Close(){ ; Close the whole current window, not the current tab
	WinClose, A
}

Win_AlwaysOnTop(){ ; Toggle a window between AlwaysOnTop states
	WinSet, AlwaysOnTop, Toggle, A
}

Win_GetProcess(){ ; Get the process name of the current window
	TimeLimit := 3 , t1 := A_TickCount
	While (Seconds<TimeLimit){
		Sleep, 10
		t2 := A_TickCount , Seconds	:= ((t2-t1)//1000)
		WinGet, Process, ProcessName, A
		ToolTip, % "Window class (" TimeLimit-Seconds "s) : " Process
	}
	Clipboard := Process
	ToolTip
}

Win_GetClass(){ ; Get the class of the current window
	TimeLimit := 3 , t1 := A_TickCount
	While (Seconds<TimeLimit){
		Sleep, 10
		t2 := A_TickCount , Seconds	:= ((t2-t1)//1000)
		WinGetClass, CurrentWinClass, A
		ToolTip, % "Window class (" TimeLimit-Seconds "s) : " CurrentWinClass
	}
	Clipboard := CurrentWinClass
	ToolTip
}

Win_Last(){ ; Activate the last window
	IDs := Win_GetList() , Pos := 1
	While (Pos := RegExMatch(IDs, "[^,]+", m, Pos+StrLen(m)))
		ID%A_Index% := m
	WinActivate, % "ahk_id " ID3
}

Win_Next(){ ; Activate the last window
	IDs := Win_GetList() , Pos := 1
	While (Pos := RegExMatch(IDs, "[^,]+", m, Pos+StrLen(m)))
		ID%A_Index% := m
	WinActivate, % "ahk_id " ID4
}

Win_GetList(){
	DetectHiddenWindows := A_DetectHiddenWindows
	DetectHiddenWindows, Off
	WinGet, ID, List
	Loop, % ID
	{
		ID := ID%A_Index%
		WinGetTitle, Title, ahk_id %ID%
		WinGetClass, Class, ahk_id %ID%
		If Title
			If Title not in Program manager,ProgMan,WorkerW,Startup,Démarrer
				If Class not in tooltips_class32
					IDs .= (IDs ? "," : "") ID
	}
	DetectHiddenWindows, % DetectHiddenWindows
	Return, IDs
}

Win_Monitor(WinID){ ; Get the monitor number where the window is
    SysGet, MonitorCount, 80
    WinGetPos, X, Y, W, H, % "ahk_id " WinID
    Loop %MonitorCount%
    {
        SysGet, Mon, Monitor, %A_Index%
        If (X>=(MonLeft-10) && X<=(MonRight+10)
        	&& Y>=(MonTop-10) && Y<=(MonBottom+10))
            Return A_Index
    }
}

Win_MoveLeft(){
    WinGet, WinID, ID, A
    Monitor := Win_Monitor(WinID)
    SysGet, MWA_, MonitorWorkArea, % Monitor
    WinGet, WinMinMax, MinMax, % "ahk_id " WinID
    If (WinMinMax==1)
        WinRestore, % "ahk_id " WinID
    X := MWA_Left , Y := MWA_Top
    W := (MWA_Right-MWA_Left)/2 , H := MWA_Bottom
    WinMove, % "ahk_id " WinID,, % X, % Y, % W, % H
}

Win_MoveRight(){
    WinGet, WinID, ID, A
    Monitor := Win_Monitor(WinID)
    SysGet, MWA_, MonitorWorkArea, % Monitor
    WinGet, WinMinMax, MinMax, % "ahk_id " WinID
    If (WinMinMax==1)
        WinRestore, % "ahk_id " WinID
    X := MWA_Left+((MWA_Right-MWA_Left)/2) , Y := MWA_Top
    W := (MWA_Right-MWA_Left)/2 , H := MWA_Bottom
    WinMove, % "ahk_id " WinID,, % X, % Y, % W, % H
}

Cpbd_PastePlainText(){ ; Paste the clipboard in plain text format
	WinActivate, A
	Clipboard := Clipboard
	Send, ^v
}

; Get the user's selection and converts it to text format
GetSelection(PlainText=1){
	LastClipboard := ClipboardAll , Clipboard := ""
	SendInput, ^c
	ClipWait, 2, 1
	If ErrorLevel
		Return
	If not PlainText
		Return, ClipboardAll
	Selection := Clipboard , Clipboard := LastClipboard
	Return, Selection
}

SaveSelection(){ ; Save the user's selection in a txt file
	If !(Selection := GetSelection())
		Return
	InputBox, FileName, Save Clipboard:, File name ?,, 250, 115
	If (!FileName || ErrorLevel )
		Return
	If !FileExist(A_ScriptDir "\SavedTexts")
		FileCreateDir, % A_ScriptDir "\SavedTexts"
	Path := A_ScriptDir "\SavedTexts\" FileName
	FileDelete, % Path
	FileAppend, % Selection, % Path
	Return, Path
}

MClick(x=0, y=0){
	If !(x~="^\d$" || y~="^\d$")
		x := 0 , y := 0
	MouseGetPos, MouseX, MouseY
	MouseClick, Left , % x, % y, 1, 0
	MouseMove, % MouseX, % MouseY, 0
}