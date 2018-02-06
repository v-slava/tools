#SingleInstance, Force
CoordMode, Mouse, Screen
SysGet, MonCount, MonitorCount
Loop, %MonCount%
{
	SysGet, Mon, Monitor, %A_Index%
	Width := MonRight - MonLeft
	Height := MonBottom - MonTop
	if (Width = 1920) && (Height = 1080)
		break
}
MouseGetPos, LX, LY
Loop
{
	MouseGetPos, MX, MY
	if ((MX >= MonLeft) && (MX <= MonRight) && (MY >= MonTop) && (MY <= MonBottom))
	&& not ((LX >= MonLeft) && (LX <= MonRight) && (LY >= MonTop) && (LY <= MonBottom))
		MouseMove, LX, LY, 0
	else
	{
		LX := MX
		LY := MY
	}
	Sleep, 50
}

^Esc::ExitApp