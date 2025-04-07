; NSISPong - Copyright 2025 David S. Shelley
; MIT Licensed – Free to use, modify, and distribute.

!ifndef SOUNDS_NSH
!define SOUNDS_NSH

!include "${NSISDIR}\Include\LogicLib.nsh"
!include "${NSISDIR}\Examples\System\System.nsh"


Function InitSound
	InitPluginsDir
	File /oname=$PLUGINSDIR\hit.wav "resources\hit.wav"
	File /oname=$PLUGINSDIR\gameover.wav "resources\gameover.wav"
FunctionEnd

Function playSndFile
	Exch $0
	push $1
	
	IntOp $1 "SND_ASYNC" || 1
	System::Call 'winmm::PlaySound(t r0, i 0, i r1) b'
	Pop $1
	Pop $0
FunctionEnd
!macro playSndMacro pathToSnd
	push ${pathToSnd}
	call playSndFile
!macroend
!define playSound "!insertmacro playSndMacro"


!endif