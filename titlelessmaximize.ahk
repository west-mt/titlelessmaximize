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
 
        Sleep, 10
        ;WinGet currWin, ID, A
        WinGet MinMax, MinMax, ahk_id %currWin%
        WinGet Style, Style, ahk_id %currWin%

        OutputDebug %Style% %MinMax%

        if(Style & 0x01000000){   ; Maximized
            HideTitleBar(currWin)
        }

        WinGet Style, Style, ahk_id %prevWin%
        if(!(Style & 0x00800000)){   ; Titlebar hidden
            ShowTitleBar(prevWin)
        }

        ;if((MinMax = 1) && (Style & 0x00800000)) {
        ;    WinSet, Style, -0x800000, A
        ;    ;force redraw
        ;    ;WinSet, Redraw
        ;    WinHide, A
        ;    WinShow, A
        ;}

        prevWin := lParam
        ;Global prevWin := lParam
    }
}

HideTitleBar(win){
    WinSet, Style, -0x00800000, ahk_id %win%
    ;WinMaximize, ahk_id %win%
    WinHide, ahk_id %win%
    WinShow, ahk_id %win%
}

ShowTitleBar(win){
    WinSet, Style, +0x00800000, ahk_id %win%
    ;WinMaximize, ahk_id %win%
    ;WinHide, ahk_id %win%
    ;WinShow, ahk_id %win%
}
