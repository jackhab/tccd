#NoTrayIcon

#include <AutoItConstants.au3>

AutoItSetOption("MustDeclareVars", 1)

;get Total Commander window handler
Local $hTcWin = WinGetHandle("[CLASS:TTOTAL_CMD]")
If $hTcWin = 0 Then
    ConsoleWrite("Total Commander window is not found")
    Exit
EndIf

;get path handles
Local $hLeftPath =  DllCall("user32.dll", "handle", "SendMessage", "hwnd", $hTcWin, "uint", 1074, "wparam", 9,  "lparam", 0)[0]
Local $hRightPath = DllCall("user32.dll", "handle", "SendMessage", "hwnd", $hTcWin, "uint", 1074, "wparam", 10, "lparam", 0)[0]

;get path text
Local $sLeftPath  = ControlGetText($hTcWin, "", $hLeftPath)
Local $sRightPath = ControlGetText($hTcWin, "", $hRightPath)

;Local $sLeftPath  = ControlGetText($hTcWin, "", "[CLASSNN:Window13]")
;Local $sRightPath = ControlGetText($hTcWin, "", "[CLASSNN:Window18]")

;trim trailing non-path chars
$sLeftPath  = StringRegExpReplace($sLeftPath, "\\[^\\]+$", "")
$sRightPath = StringRegExpReplace($sRightPath, "\\[^\\]+$", "")

;since current process cannot send "cd path" keys to current console
;because it's blocking it we will relaunch outselves in a new process
;that actually send the keys
If $CmdLine[0] = "" Then
    ConsoleWrite($sLeftPath & @CRLF)
    ConsoleWrite($sRightPath & @CRLF)

ElseIf ($CmdLine[1] = "d") Then
    ConsoleWrite("TC window " & $hTcWin & @CRLF)
    ConsoleWrite("Left path " & $hLeftPath & @CRLF)
    ConsoleWrite("Right path " & $hRightPath & @CRLF)

ElseIf ($CmdLine[1] = "l" Or $CmdLine[1] = "1") Then
    ShellExecute (@ScriptFullPath, "cdl", "", "", @SW_HIDE)

ElseIf ($CmdLine[1] = "r" Or $CmdLine[1] = "2") Then
    ShellExecute (@ScriptFullPath, "cdr", "", "", @SW_HIDE)

ElseIf $CmdLine[1] = "cdl" Then
    Send('cd "' & $sLeftPath & '"' & @CRLF, $SEND_RAW)

ElseIf $CmdLine[1] = "cdr" Then
    Send('cd "' & $sRightPath & '"' & @CRLF, $SEND_RAW)    

ElseIf $CmdLine[1] = "/?" Then
    ConsoleWrite("TCCD by jackhab"                                            & @CRLF & _
        "This utility reads left and right panel paths from Total Commander"  & @CRLF & _
        "and sends them to current console."                                  & @CRLF & _
        "Usage:"                                                              & @CRLF & _
        "    tccd       print left and right paths"                           & @CRLF & _
        "    tccd l     cd to left path"                                      & @CRLF & _
        "    tccd r     cd to right path"                                     & @CRLF & _
        @CRLF)
EndIf

