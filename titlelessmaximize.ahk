#Persistent
;SetBatchLines, -1
;Process, Priority,, High
;
Gui +LastFound
hWnd := WinExist()

DllCall( "RegisterShellHookWindow", UInt,hWnd )
MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
OnMessage( MsgNum, "ShellMessage" )
Return

ShellMessage( wParam,lParam )
{
    If wParam in 32772
    {
        WinGet MinMax, MinMax, A
        WinGet Style, Style, A
        if((MinMax = 1) && (Style & 0x00800000)) {
            WinSet, Style, -0x800000, A
            ;force redraw
            ;WinSet, Redraw
            WinHide, A
            WinShow, A
        }
    }
    ;if (wParam = 5)
    ;{
    ;    MsgBox HOGE
    ;    ;WinGet MinMax, MinMax, A
    ;    ;WinGet Style, Style, A
    ;    ;if(!(Style & 0x800000)) {
    ;    ;    WinSet, Style, +0x800000, A
    ;    ;}
    ;}
}

