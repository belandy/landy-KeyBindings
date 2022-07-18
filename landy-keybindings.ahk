#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

;-----------------------------------------------------------
; Change Keyによって変更されているキー
; 	半角/全角　= F13
;	CapsLock  = F14
;-----------------------------------------------------------

; IMEの設定でスペースは常に半角にしている


; https://w.atwiki.jp/eamat/pages/17.html より拝借
;-----------------------------------------------------------
; IMEの状態の取得
;   WinTitle="A"    対象Window
;   戻り値          1:ON / 0:OFF
;-----------------------------------------------------------
IME_GET(WinTitle="A")  {
	ControlGet,hwnd,HWND,,,%WinTitle%
	if	(WinActive(WinTitle))	{
		ptrSize := !A_PtrSize ? 4 : A_PtrSize
	    VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
	    NumPut(cbSize, stGTI,  0, "UInt")   ;	DWORD   cbSize;
		hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
	             ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
	}

    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          ,  Int, 0x0005  ;wParam  : IMC_GETOPENSTATUS
          ,  Int, 0)      ;lParam  : 0
}
;-----------------------------------------------------------
; IMEの状態をセット
;   SetSts          1:ON / 0:OFF
;   WinTitle="A"    対象Window
;   戻り値          0:成功 / 0以外:失敗
;
;-----------------------------------------------------------
IME_SET(SetSts, WinTitle="A")    {
	ControlGet,hwnd,HWND,,,%WinTitle%
	if	(WinActive(WinTitle))	{
		ptrSize := !A_PtrSize ? 4 : A_PtrSize
	    VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
	    NumPut(cbSize, stGTI,  0, "UInt")   ;	DWORD   cbSize;
		hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
	             ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
	}

    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          ,  Int, 0x006   ;wParam  : IMC_SETOPENSTATUS
          ,  Int, SetSts) ;lParam  : 0 or 1
}


;-----------------------------------------------------------
; 割り当て置換キーバインド
; 対象のキーに別の機能を割り当てる
;-----------------------------------------------------------
; 変換キーでIMEをONの状態にする
vk1C::IME_SET(1)

; 無変換キーでIMEをOFFの状態にする
vk1D::IME_SET(0)

; 全角"（ "入力で半角"("を入力
; UseHookで囲わないとエラーが出る
#UseHook
+8::
ime_mode := IME_GET()
IME_SET(0)
Send, +8
IME_SET(ime_mode)
return
#UseHook Off

; 全角" ） "入力で半角" ) "を入力
#UseHook
+9::
ime_mode := IME_GET()
IME_SET(0)
Send, +9
IME_SET(ime_mode)
return
#UseHook Off

;-----------------------------------------------------------
; アプリ起動キーバインド
; 特定のアプリを起動する
; F14に変換されているCapsLockキー(vk7d)を軸に設定
;-----------------------------------------------------------
; CapsLock + OでObsidian起動
vk7d & O::
	Process, Exist, Obsidian.exe
	if ErrorLevel<>0
		WinActivate, ahk_pid %ErrorLevel%
	else
		Run, "C:\Users\belan\AppData\Local\Obsidian\Obsidian.exe"
return

; CapsLock + VでVivaldi起動
vk7d & V::
	Process, Exist, Vivaldi.exe
	if ErrorLevel<>0
		WinActivate, ahk_pid %ErrorLevel%
	else
		Run, "C:\Users\belan\AppData\Local\Vivaldi\Application\vivaldi.exe"
return




; シャットダウン
; shutdown.ahkを使用
#Del::Run, shutdown.ahk