; NSISPong - Copyright 2025 David S. Shelley
; MIT Licensed – Free to use, modify, and distribute.

!ifndef STATE_NSH
!define STATE_NSH

!include "${NSISDIR}\Include\LogicLib.nsh"
!include "${NSISDIR}\Examples\System\System.nsh"

Var gameState
Function SetGameState_Menu
	Strcpy $gameState "mainmenu"
FunctionEnd

Function SetGameState_Active
	Strcpy $gameState "active"
FunctionEnd

Function SetGameState_GameOver
	Strcpy $gameState "gameover"
FunctionEnd


!endif