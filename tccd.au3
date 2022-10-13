#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=tccd.exe
;#AutoIt3Wrapper_Outfile_x64=tccd64.exe
;#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#NoTrayIcon
#include <AutoItConstants.au3>
#include <SendMessage.au3>
#include <WindowsConstants.au3>
AutoItSetOption("MustDeclareVars", 1)


;get Total Commander window handler
Local $hTcWin = WinGetHandle("[CLASS:TTOTAL_CMD]")
If $hTcWin = 0 Then
    ConsoleWrite("Total Commander window is not found")
EndIf

;get path control handles
Local $hLeftPath =  DllCall("user32.dll", "handle", "SendMessage", "hwnd", $hTcWin, "uint", 1074, "wparam", 9,  "lparam", 0)[0]
Local $hRightPath = DllCall("user32.dll", "handle", "SendMessage", "hwnd", $hTcWin, "uint", 1074, "wparam", 10, "lparam", 0)[0]
Local $iSide =  DllCall("user32.dll", "handle", "SendMessage", "hwnd", $hTcWin, "uint", 1074, "wparam", 1000,  "lparam", 0)[0]

;simpler way than sending the messages above but suspected not to work reliably, thus disabled
;Local $sLeftPath  = ControlGetText($hTcWin, "", "[CLASSNN:Window13]")
;Local $sRightPath = ControlGetText($hTcWin, "", "[CLASSNN:Window18]")

;get path text
Local $sLeftPath  = ControlGetText($hTcWin, "", $hLeftPath)
Local $sRightPath = ControlGetText($hTcWin, "", $hRightPath)

;trim trailing non-path chars
$sLeftPath  = StringRegExpReplace($sLeftPath, "\\[^\\]+$", "")
$sRightPath = StringRegExpReplace($sRightPath, "\\[^\\]+$", "")

;mark active path with asterisk
If $iSide = 1 Then
    Local $sLeftPrefix =  "*l: "
    Local $sRightPrefix = " r: "
Else
    Local $sLeftPrefix =  " l: "
    Local $sRightPrefix = "*r: "
EndIf

If $CmdLine[0] = "" Then
    ConsoleWrite($sLeftPrefix & $sLeftPath & @CRLF)
    ConsoleWrite($sRightPrefix & $sRightPath & @CRLF)

ElseIf ($CmdLine[1] = "d") Then
    ConsoleWrite("TC window " & $hTcWin & @CRLF)
    ConsoleWrite("Left path " & $hLeftPath & @CRLF)
    ConsoleWrite("Right path " & $hRightPath & @CRLF)
    ConsoleWrite("Active " & $iSide & @CRLF)

ElseIf ($CmdLine[1] = "l" Or $CmdLine[1] = "1") Then
    _ChangeFolder($sLeftPath)

ElseIf ($CmdLine[1] = "r" Or $CmdLine[1] = "2") Then
    _ChangeFolder($sRightPath)

ElseIf ($CmdLine[1] = "s" And $iSide = 2 ) Then
    _ChangeFolder($sRightPath)

ElseIf ($CmdLine[1] = "s" And $iSide = 1 ) Then
    _ChangeFolder($sLeftPath)

ElseIf ($CmdLine[1] = "t" And $iSide = 1 ) Then
    _ChangeFolder($sRightPath)

ElseIf ($CmdLine[1] = "t" And $iSide = 2 ) Then
    _ChangeFolder($sLeftPath)

ElseIf $CmdLine[1] = "." Then
    ConsoleWrite("SEND" & @CRLF)
    WinActivate($hTcWin)
    WinWaitActive($hTcWin, 1)
    ControlClick($hTcWin, "", "[CLASSNN:Window13]")
    Sleep(1000)
    Send(@WorkingDir & @CRLF, $SEND_RAW)

ElseIf $CmdLine[1] = "/?" Then
    ConsoleWrite("TCCD by jackhab"                                            & @CRLF & _
        "This utility reads left and right panel paths from Total Commander"  & @CRLF & _
        "and sends them to current console."                                  & @CRLF & _
        "Usage:"                                                              & @CRLF & _
        "    tccd       print left and right paths"                           & @CRLF & _
        "    tccd l|1   cd to left path"                                      & @CRLF & _
        "    tccd r|2   cd to right path"                                     & @CRLF & _
        "    tccd s     cd to source path"                                    & @CRLF & _
        "    tccd t     cd to target path"                                    & @CRLF & _
        "    tccd .     set Total Commander to current path"                  & @CRLF & _
        @CRLF )
EndIf

Exit


Func _ChangeFolder($sPath)    
    DllCall("kernel32.dll", "bool", "FreeConsole")
    Send('cd "' & $sPath & '"' & @CRLF, $SEND_RAW)
EndFunc
