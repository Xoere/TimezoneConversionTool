#SingleInstance, Force
SetWorkingDir %A_ScriptDir%  

/*
Goal: Allow user to input target time zone and time, then print a converted string in the format of "<local time> <local time zone> | <utc time> UTC / GMT | <target time> <target time zone>
Next steps: 
Add more time zones to drop down menu.
Add functionality for calculating a specified time using user inputs.
Remove "ExitApp" when ready.
*/

;Gui, Add, Text,, Local Time Zone:
;Gui, Add, DropDownList, vLocalTimeZone, PST (UTC -7)|MST (UTC -6)|CST (UTC -5)|EST (UTC -4)
;Gui, Add, Text,, Enter local time values and select the target time zone to convert it.
Gui, Add, Text,, Enter Local Hour (H):
Gui, Add, Text,, Enter Local Minute (MM):
Gui, Add, Text,, AM/PM:
Gui, Add, Text,, Target Time Zone:
Gui, Add, Edit, vTargetTimeHour ym
Gui, Add, Edit, vTargetTimeMinute
Gui, Add, DropDownList, vAMPM, AM|PM
Gui, Add, DropDownList, vTargetTimeZone, PST (UTC -7)|MST (UTC - 6)|CST (UTC -5)|EST (UTC -4) |IST (UTC +5:30)|CEST (UTC +2)
Gui, Add, Text,, Press Shift + Scroll Lock to print current time.
Gui, Add, Text,, Press Alt + Scroll Lock to print target time.

Gui, Add, Button, default, OK  ; The label ButtonOK (if it exists) will be run when the button is pressed.
Gui, Show,, Time Zone Converter
return  ; End of auto-execute section. The script is idle until the user does something.

GuiClose:
ButtonOK:
Gui, Submit  ; Save the input from the user to each control's associated variable.

; Calculate local time zone name START

T1 := A_now ; var for local time
T2 := A_NowUTC ; var for UTC time

EnvSub, T1, %T2%, hours

localTZDiff := T1 ; variable for local time zone difference

if (localTZDiff = "-4"){
	localTZName := "EST"
	}
else if (localTZDiff = "-5")
{
	localTZNAme := "CST"	
	}
else if (localTZDiff = "-6")
{
	localTZNAme := "CST"	
	}
else if (localTZDiff = "-7")
{
	localTZNAme := "MST"	
	}
else if (localTZDiff = "-8")
{
	localTZNAme := "PST"	
	}
else
{
	localTZNAme := "Not programmed"	
	}

;MsgBox %localTZDiff% - local TZ difference. %targetTZNAme% - target TZ name. ; FOR DEBUGGING
;MsgBox %localTZNAme% - local TZ name. %targetTZNAme% - target TZ name. ; FOR DEBUGGING

; Calculate local time zone name END

; Calculate TARGET time's UTC offset START

omitcharacters := "ABCDEFGHIJKLMNOPQRSTUVXYZ, +()"
TargetTimeOffset := Trim(TargetTimeZone, omitcharacters)
;MsgBox %TargetTimeOffset% - target time offset from UTC.  ; FOR DEBUGGING


; Calculate TARGET time's UTC offset END

; Calculate TARGET time by adding UTC + offset START
;MsgBox %T2% - T2 ; FOR DEBUGGING
targetTime := T2
targetTime += TargetTimeOffset, hours

;MsgBox %targetTime% - targetTime. %T2% - T2 ; FOR DEBUGGING

;MsgBox %localTZNAme% - local TZ name. %targetTZNAme% - target TZ name. ; FOR DEBUGGING


; Calculate TARGET time by adding UTC + offset END

; Calculate TARGET TZ START

omitcharacters := " "
targetTZName := SubStr(TargetTimeZone,1,4)
targetTZName := Trim(targetTZName, omitcharacters)

MsgBox %targetTZNAme% - target TZ name. ; FOR DEBUGGING

; Calculate TARGET TZ END

;MsgBox %LocalTimeZone% - local time zone. %TargetTimeZone% - target time zone. ; FOR DEBUGGING



FormatTime, localTime, , h:mm tt ; Calculate and format local time
FormatTime, utcTime, %T2%, h:mm tt ; Calculate and format UTC time
FormatTime, targetTime, %targetTime%, h:mm tt ; Format target time


localAndUtcOnly := localTime " " localTZNAme " | " utcTime " UTC / GMT | " targetTime " " targetTZName ; Add all variables to string
localAndUtcOnly := RTrim(localAndUtcOnly," |") ; Remove empty symbols if no target time zone provided

+ScrollLock::SendInput %localAndUtcOnly% ; Shift + Scroll Lock to type out times
;+ScrollLock::SendInput %localTime% %localTZNAme% | %utcTime% UTC / GMT | %targetTime% %targetTZName%; Shift + Scroll Lock to type out times

;ExitApp