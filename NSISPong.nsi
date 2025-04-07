; NSISPong - Copyright 2025 David S. Shelley
; MIT Licensed – Free to use, modify, and distribute.

; The name of the installer
Name "NSIS PONG"

; The file to write
OutFile "NSISPong.exe"

; The default installation directory
InstallDir $DESKTOP\Example1

!include "${NSISDIR}\Include\LogicLib.nsh"
!include "${NSISDIR}\Examples\System\System.nsh"

!include "include\state.nsh"
!include "include\board.nsh"
!include "include\ball.nsh"
!include "include\paddles.nsh"
!include "include\graphics.nsh"
!include "include\sounds.nsh"

LicenseData "resources\Document.rtf"
LicenseText " " "Play"
Page license
Page license ChangeLicenseBtnText StartGame stayInLicense

RequestExecutionLevel user

 Function stayInLicense
	Call StartGame
	Abort
 FunctionEnd
 
Function ChangeLicenseBtnText
	; Back button
	GetDlgItem $0 $HWNDPARENT 3
	ShowWindow $0 ${SW_HIDE}
	
	; Cancel button
	GetDlgItem $0 $HWNDPARENT 2
	SendMessage $0 ${WM_SETTEXT} "0" "STR:Exit Game"
	
	; Next button
	GetDlgItem $0 $HWNDPARENT 1
	SendMessage $0 ${WM_SETTEXT} "0" "STR:Play Again"
FunctionEnd

Function ChangeCancelButtonText
	FindWindow $0 "#32770" "" $HWNDPARENT
	GetDlgItem $1 $0 2
	System::Call 'user32::SetWindowText(i $1, t "Exit")'
FunctionEnd

Function .onInit
	Call SetGameState_Menu
	Call ChangeLicensePageButtons
FunctionEnd

Function InitGame
	Call SetGameState_Active
	Call InitBoard
	Call InitPaddles
	Call InitBall
	Call InitSound
FunctionEnd

Function sleepMilliSeconds
	Exch $0
	System::Call 'kernel32::Sleep(i r0) l'
	Pop $0
FunctionEnd
!macro sleepMacro milSecs
	push ${milSecs}
	call sleepMilliSeconds
!macroend
!define sleep "!insertmacro sleepMacro"

Function StartGame
	Call InitGame
	${SetTitleBar} "Press Escape key to exit game..."

loopStart:
	${sleep} "1"

	; Game Over
	${If} $gameState == "gameover"
		${playSound} "$PLUGINSDIR\gameover.wav"
		goto loopEnd
	${EndIf}
	
	; Escape key
	System::Call "user32::GetAsyncKeyState(i 0x1B) i .r0 ? !e"
	IntOp $0 $0 & 0x8000
	${If} 0 <> $0
	  goto loopEnd
	${EndIf}

	; Process Messages - This prevents the window freezing when the user clicks it during the game
	System::Call "user32::PeekMessage(i 0, i 0, i 0, i 0, i 0, i 0) i .r1"
	${If} $1 <> 0
		System::Call "user32::GetMessage(i 0, i 0, i 0, i 0, i .r2) i .r3"
		${If} $3 <> 0
			System::Call "user32::TranslateMessage(i $2)"
			System::Call "user32::DispatchMessage(i $2)"
		${EndIf}
	${EndIf}


	Call UpdateScene
	Call RenderScene

	goto loopStart

loopEnd:
	Call ChangeLicenseBtnText
functionEnd

Function UpdateScene
	Call UpdatePaddles
	Call UpdateBall
FunctionEnd

Function RenderScene
	${ClearScreen} $WindowDeviceContext
	${RenderTwoPaddles} $WindowDeviceContext
	${RenderBall} $WindowDeviceContext
FunctionEnd

Section ""
	Call StartGame
SectionEnd


