; NSISPong - Copyright 2025 David S. Shelley
; MIT Licensed – Free to use, modify, and distribute.

!ifndef PADDLES_NSH
!define PADDLES_NSH

!include "${NSISDIR}\Include\LogicLib.nsh"
!include "${NSISDIR}\Examples\System\System.nsh"

!include "include\board.nsh"
!include "include\graphics.nsh"


; Paddle location
Var PaddleXLoc
Var PaddleYLoc
Var PaddleXLocTop
Var PaddleYLocTop
Var PaddleWidth
Var PaddleHeight
Var PaddleWidthHalf
Var PaddleHeightHalf

Function InitPaddles
	Call InitBoard
	
	Strcpy $PaddleWidth 50
	Strcpy $PaddleHeight 10

	IntOp $PaddleXLoc $boardCenterX + 0
	Strcpy $PaddleYLoc 278

	IntOp $PaddleXLocTop $boardCenterX + 0
	Strcpy $PaddleYLocTop 36
	
	IntOp $PaddleWidthHalf $PaddleWidth / 2
	IntOp $PaddleHeightHalf $PaddleHeight / 2
FunctionEnd


; UPDATE
!macro MOVE_PADDLE PaddleXLoc KeyLeft KeyRight
	push $0

	System::Call "user32::GetAsyncKeyState(i ${KeyLeft}) i .r0 ? !e"
	IntOp $0 $0 & 0x8000
	${If} 0 <> $0
		IntOp ${PaddleXLoc} ${PaddleXLoc} - 10
	${EndIf}

	System::Call "user32::GetAsyncKeyState(i ${KeyRight}) i .r0 ? !e"
	IntOp $0 $0 & 0x8000
	${If} 0 <> $0
		IntOp ${PaddleXLoc} ${PaddleXLoc} + 10
	${EndIf}

	${If} ${PaddleXLoc} <= 0
		Strcpy ${PaddleXLoc} 1
	${EndIf}

	${If} ${PaddleXLoc} >= $boardWidth
		Strcpy ${PaddleXLoc} $boardWidth
	${EndIf}

	pop $0
!macroend
!define MovePaddle "!insertmacro MOVE_PADDLE"

Function moveTopPaddle
	${MovePaddle} $PaddleXLocTop 0x64 0x66
	${MovePaddle} $PaddleXLocTop 0x34 0x36
FunctionEnd

Function moveBotPaddle
	${MovePaddle} $PaddleXLoc 0x25 0x27
FunctionEnd

Function UpdatePaddles
	Call moveTopPaddle
	Call moveBotPaddle
FunctionEnd




; RENDER
Function RenderTwoPaddlesImp
	Exch $R0
	${RenderRectangle} $PaddleXLocTop $PaddleYLocTop $PaddleWidth $PaddleHeight $R0 0 200 255
	${RenderRectangle} $PaddleXLoc $PaddleYLoc $PaddleWidth $PaddleHeight $R0 255 100 0
	pop $R0
FunctionEnd
!macro RenderTwoPaddlesMacro dcVar
	push ${dcVar}
	Call RenderTwoPaddlesImp
!macroend
!define RenderTwoPaddles "!insertmacro RenderTwoPaddlesMacro"

!endif