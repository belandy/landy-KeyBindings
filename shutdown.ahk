#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

; GUIウィンドウを表示
GUI, Add, Text,,本当にシャットダウンしますか？:
GUI, Add, Button, y+10 Default GShutdown, シャットダウン
GUI, Add, Button, x+5 GReboot, 再起動
GUI, Add, Button, x+5 GCancel, キャンセル
GUI, Show,,シャットダウン
Return

Shutdown:
    Shutdown, 5
    ExitApp
    
Reboot:
    Shutdown, 6
    ExitApp

Cancel:
    GuiClose:
    ExitApp