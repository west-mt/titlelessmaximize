#Persistent
Gui +LastFound
hWnd := WinExist()
Global prevWin

WinGet prevWin, ID, A
WinGet Style, Style, ahk_id %prevWin%
if((Style & 0x01000000) && (Style & 0x00800000)){   ; Maximized
    HideTitleBar(prevWin)
}


DllCall( "RegisterShellHookWindow", UInt,hWnd )
MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
OnMessage( MsgNum, "ShellMessage" )
Return

ShellMessage( wParam,lParam )
{
    If (wParam = 0x8004) {
        currWin := lParam
        WinGet, ProcessName, ProcessName, ahk_id %currWin%
        ;OutputDebug %Style% %MinMax%

        ;Ignore Store apps.
        if (ProcessName == "WWAHost.exe" || ProcessName == "explorer.exe"){
            prevWin := lParam
            Return
        }


        Sleep, 10
        ;WinGet currWin, ID, A
        WinGet MinMax, MinMax, ahk_id %currWin%
        WinGet Style, Style, ahk_id %currWin%

        ;OutputDebug %Style% %MinMax%

        if((Style & 0x01000000) && (Style & 0x00800000)){   ; Maximized
            HideTitleBar(currWin)
        }

        if(prevWin != currWin){
            ;OutputDebug Different window! %currWin% %prevWin%
            WinGet Style, Style, ahk_id %prevWin%
            if(!(Style & 0x00800000)){   ; Titlebar hidden
                ShowTitleBar(prevWin)
            }
            prevWin := lParam
        }

    }
}

HideTitleBar(win){
    WinSet, Style, -0x00800000, ahk_id %win%
    ;WinMaximize, ahk_id %win%
    ;Force Redraw
    ;WinHide, ahk_id %win%
    ;WinShow, ahk_id %win%
}

ShowTitleBar(win){
    WinSet, Style, +0x00800000, ahk_id %win%
    ;WinMaximize, ahk_id %win%
    ;WinHide, ahk_id %win%
    ;WinShow, ahk_id %win%
}
