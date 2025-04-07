; NSISPong - Copyright 2025 David S. Shelley
; MIT Licensed – Free to use, modify, and distribute.

!ifndef GRAPHICS_NSH
!define GRAPHICS_NSH

!include "${NSISDIR}\Include\LogicLib.nsh"
!include "${NSISDIR}\Examples\System\System.nsh"

; Expected Inputs: $R0 = X, $R1 = Y, etc.
; Do NOT pass $0–$9 into this macro
!macro RenderRectangleMacro xVar yVar widthVar heightVar dcVar r g b
	push $0
	push $1
	push $2
	push $3
	push $4
	push $5
	push $6
	push $7
	push $8

	; Compute half-width and half-height
	IntOp $7 ${widthVar} / 2
	IntOp $8 ${heightVar} / 2

	; Compute rectangle bounds (centered)
	IntOp $0 ${xVar} - $7
	IntOp $1 ${yVar} - $8
	IntOp $2 ${xVar} + $7
	IntOp $3 ${yVar} + $8

	; Compute RGB color value
	IntOp $4 ${r} + 0         ; R
	IntOp $5 ${g} << 8        ; G
	IntOp $4 $4 | $5
	IntOp $5 ${b} << 16       ; B
	IntOp $4 $4 | $5

	; Create and select brush
	System::Call 'gdi32::CreateSolidBrush(i $4) i .r6'
	System::Call 'gdi32::SelectObject(i ${dcVar}, i r6) i .r5'

	; Draw rectangle
	System::Call 'gdi32::Rectangle(i ${dcVar}, i $0, i $1, i $2, i $3)'

	; Restore brush and clean up
	System::Call 'gdi32::SelectObject(i ${dcVar}, i r5)'
	System::Call 'gdi32::DeleteObject(i r6)'

	pop $8
	pop $7
	pop $6
	pop $5
	pop $4
	pop $3
	pop $2
	pop $1
	pop $0
!macroend
!define RenderRectangle "!insertmacro RenderRectangleMacro"


; Expected Inputs: $R0 = X, $R1 = Y, etc.
; Do NOT pass $0–$9 into this macro
!macro RenderEllipseMacro xVar yVar widthVar heightVar dcVar r g b
	push $0
	push $1
	push $2
	push $3
	push $4
	push $5
	push $6
	push $7
	push $8

	; Compute half-width and half-height
	IntOp $7 ${widthVar} / 2
	IntOp $8 ${heightVar} / 2

	; Compute ellipse bounds (centered)
	IntOp $0 ${xVar} - $7
	IntOp $1 ${yVar} - $8
	IntOp $2 ${xVar} + $7
	IntOp $3 ${yVar} + $8

	; Compute RGB color value
	IntOp $4 ${r} + 0         ; R
	IntOp $5 ${g} << 8        ; G
	IntOp $4 $4 | $5
	IntOp $5 ${b} << 16       ; B
	IntOp $4 $4 | $5

	; Create and select brush
	System::Call 'gdi32::CreateSolidBrush(i $4) i .r6'
	System::Call 'gdi32::SelectObject(i ${dcVar}, i r6) i .r5'

	; Draw ellipse
	System::Call 'gdi32::Ellipse(i ${dcVar}, i $0, i $1, i $2, i $3)'

	; Restore brush and clean up
	System::Call 'gdi32::SelectObject(i ${dcVar}, i r5)'
	System::Call 'gdi32::DeleteObject(i r6)'

	pop $8
	pop $7
	pop $6
	pop $5
	pop $4
	pop $3
	pop $2
	pop $1
	pop $0
!macroend
!define RenderEllipse "!insertmacro RenderEllipseMacro"



; Do NOT pass $0–$9 into this macro
; Clears screen to black color
Function ClearScreenImp
	Exch $0 ; Get the $WindowDeviceContext
	push $1
	push $2
	push $3
	push $4
	push $5

	push $R0
	push $R1
	push $R2
	push $R3
	push $R4

	; Create RECT struct
	System::Call "*${stRECT} .r1"
	; Find Window info for the window we're displaying
	System::Call "User32::GetWindowRect(i, i) i ($HWNDPARENT, r1) .r2"
	; Get left/top/right/bottom
	System::Call "*$1${stRECT} (.r2, .r3, .r4, .r5)"
	System::Free $1
	; Calculate width/height of our window
	IntOp $2 $4 - $2 ;width
	IntOp $3 $5 - $3 ;height

	; Convert number registries to R registries
	IntOp $R0 $2 / 2
	IntOp $R1 $3 / 2
	IntOp $R2 $2 + 0
	IntOp $R3 $3 + 0
	IntOp $R4 $0 + 0

	${RenderRectangle} $R0 $R1 $R2 $R3 $R4 0 0 20

	pop $R4
	pop $R3
	pop $R2
	pop $R1
	pop $R0
	
	pop $5
	pop $4
	pop $3
	pop $2
	pop $1
	pop $0
FunctionEnd
!macro ClearScreenMacro cdVar
	push ${cdVar}
	Call ClearScreenImp
!macroend
!define ClearScreen "!insertmacro ClearScreenMacro"


!endif