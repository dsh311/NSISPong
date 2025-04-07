; NSISPong - Copyright 2025 David S. Shelley
; MIT Licensed – Free to use, modify, and distribute.

!ifndef BOARD_NSH
!define BOARD_NSH

!include "${NSISDIR}\Include\LogicLib.nsh"
!include "${NSISDIR}\Examples\System\System.nsh"


Var WindowDeviceContext
Var HWND_DesktopWindow

Var boardWidth
Var boardHeight

Var boardCenterX
Var boardCenterY

Var titleBarHeight

Var boardTopYBoundary
Var boardBotYBoundary

Function InitBoard
	Push $0
	Push $1
	Push $2
	Push $3
	Push $4
	Push $5

	Strcpy $titleBarHeight 25
	IntOp $boardTopYBoundary $titleBarHeight + 20
	IntOp $boardBotYBoundary $boardHeight - 20

	; Create RECT struct
	System::Call "*${stRECT} .r1"
	; Find Window info for the window we're displaying
	System::Call "User32::GetWindowRect(i, i) i ($HWNDPARENT, r1) .r2"
	; Get left/top/right/bottom
	System::Call "*$1${stRECT} (.r2, .r3, .r4, .r5)"
	System::Free $1
	; Calculate width/height of our window
	IntOp $2 $4 - $2 ; $2 now contains the width
	IntOp $3 $5 - $3 ; $3 now contains the height

	Strcpy $boardWidth $2
	Strcpy $boardHeight $3

	IntOp $boardCenterX $boardWidth / 2
	IntOp $boardCenterY $boardHeight / 2

	System::Call 'user32.dll::GetForegroundWindow(v) i .r0'
	Strcpy $HWND_DesktopWindow $0
	System::Call 'user32::GetWindowDC(i $HWND_DesktopWindow) i .r1'
	Strcpy $WindowDeviceContext $1

	Pop $5
	Pop $4
	Pop $3
	Pop $2
	Pop $1
	Pop $0
FunctionEnd

!macro SetTitlebar Str
	SendMessage $HWNDPARENT ${WM_SETTEXT} 0 "STR:${Str}"
!macroend
!define SetTitleBar "!insertmacro SetTitleBar"


Function ChangeLicensePageButtons
	; Find the window with the License page buttons
	FindWindow $0 "#32770" "" $HWNDPARENT
	FindWindow $1 "Button" "" $0

	; Set the "I Agree" button text to "Accept"
	StrCpy $2 "Play"
	System::Call 'user32::SetWindowText(i $1, t $2)'
FunctionEnd

!endif
