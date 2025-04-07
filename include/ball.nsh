; NSISPong - Copyright 2025 David S. Shelley
; MIT Licensed – Free to use, modify, and distribute.

!ifndef BALL_NSH
!define BALL_NSH

!include "${NSISDIR}\Include\LogicLib.nsh"
!include "${NSISDIR}\Examples\System\System.nsh"

!include "include\board.nsh"
!include "include\graphics.nsh"
!include "include\paddles.nsh"
!include "include\sounds.nsh"
!include "include\state.nsh"


; Ball
Var BallXLoc
Var BallYLoc

Var BallIncX
Var BallIncY

Var BallWidth
Var BallHeight

Var HitPaddle

Function InitBall
	IntOp $BallXLoc $boardCenterX + 0
	IntOp $BallYLoc $boardCenterX + 0

	Strcpy $BallIncX 1
	Strcpy $BallIncY -1

	Strcpy $BallWidth 10
	Strcpy $BallHeight 10
FunctionEnd

; UPDATE
Function UpdateBall
	push $0
	push $1
	push $2

	; Increment the x and y values of the ball
	IntOp $BallXLoc $BallXLoc + $BallIncX
	IntOp $BallYLoc $BallYLoc + $BallIncY
	
	; SIDE WALL HITS-----------------------------------------------
	; Reverse the direction if they hit the wall
	${If} $BallXLoc <= 0
		${playSound} "$PLUGINSDIR\hit.wav"
		; Make sure the ball is clear of the wall
		Strcpy $BallXLoc 1
		IntOp $BallIncX $BallIncX * -1
	${EndIf}

	${If} $BallXLoc >= $boardWidth
		${playSound} "$PLUGINSDIR\hit.wav"
		; Make sure the ball is clear of the wall
		IntOp $0 $boardWidth - 1
		Strcpy $BallXLoc $0
		IntOp $BallIncX $BallIncX * -1
	${EndIf}
	; ----------------------------------------------------------


	; TOP WALL HIT----------------------------------------------
	Strcpy $HitPaddle "false"
	${If} $BallYLoc <= $boardTopYBoundary
		${playSound} "$PLUGINSDIR\hit.wav"
		
		;Check if ball hit top paddles
		IntOp $1 $BallXLoc - $PaddleWidthHalf
		IntOp $2 $BallXLoc + $PaddleWidthHalf
		${If} $PaddleXLocTop >= $1
			${If} $PaddleXLocTop <= $2
				Strcpy $HitPaddle "true"
			${EndIf}
		${EndIf}
		
		${If} $HitPaddle == "false"
			Call SetGameState_GameOver
		${EndIf}
		
		IntOp $BallIncY $BallIncY * -1
	${EndIf}
	

	IntOp $0 $PaddleYLoc - 10
	${If} $BallYLoc >= $boardBotYBoundary
		${playSound} "$PLUGINSDIR\hit.wav"
		
		; Check if ball hit bottom paddles
		IntOp $1 $BallXLoc - $PaddleWidthHalf
		IntOp $2 $BallXLoc + $PaddleWidthHalf
		${If} $PaddleXLoc >= $1
			${If} $PaddleXLoc <= $2
				Strcpy $HitPaddle "true"
			${EndIf}
		${EndIf}
		
		${If} $HitPaddle == "false"
			Call SetGameState_GameOver
		${EndIf}
		
		IntOp $BallIncY $BallIncY * -1
	${EndIf}
	; ----------------------------------------------------------
	
	pop $2
	pop $1
	pop $0
FunctionEnd


; RENDER
Function RenderBallImp
	Exch $R0
	${RenderEllipse} $BallXLoc $BallYLoc $BallWidth $BallHeight $R0 255 0 255
	pop $R0
FunctionEnd
!macro RenderBallMacro dcVar
	push ${dcVar}
	Call RenderBallImp
!macroend
!define RenderBall "!insertmacro RenderBallMacro"


!endif