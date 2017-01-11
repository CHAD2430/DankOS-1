


;--------------------------------------------------------------------
check_mouse:
	mov si, CheckingMouseMsg		;Print checking string
	push 0x02
	int 0x80
	
	push ax
	mov ax,0x0000
	int 0x33
	cmp ax,0x0000
	pop ax
	je .failure	
	mov si, MouseDetectedMsg		;Provide visual output the mouse is detected
	push 0x02
	int 0x80
	iret
	
.failure:
	mov si, MouseNotDetectedMsg		;Print out an error
	push 0x02
	int 0x80
	iret
;--------------------------------------------------------------------
;	Shows the flashing cursor
show_mouse_bioscursor:
	push ax
	mov ax,0x0001
	int 0x33
	pop ax
	iret
;--------------------------------------------------------------------
;	Hides the flashing cursor
hide_mouse_bioscursor:
	push ax
	mov ax,0x0001
	int 0x33
	pop ax
	iret
;----------------------------------------------------------------------
;	IN:		[None]
;	OUT:	BX --> Button status
;				Bit 0: 		Left mouse button
;				Bit 1: 		Right mouse button
;				Bit 2: 		Middle mouse button
;			CX --> X Position
;			DX --> Y Position

get_mouse_status:
	push ax
	mov ax,0x0003
	int 0x33
	pop ax
	iret
;----------------------------------------------------------------------
;	IN:		CX --> X Position
;			DX --> Y Position
;	OUT:	[None]
set_mouse_position:
	push ax
	mov ax,0x004
	int 0x33
	pop ax
	iret
;----------------------------------------------------------------------
;	IN:		CX --> Minimum position
;			DX --> Maximum position
;	OUT:	[None]
set_horizontal_range:
	push ax
	mov ax,0x0007
	int 0x33
	pop ax
	iret
;----------------------------------------------------------------------
;	IN:		CX --> Minimum position
;			DX --> Maximum position
;	OUT:	[None]
set_vertical_range:
	push ax
	mov ax,0x0008
	int 0x33
	pop ax
	iret
;--------------------------------------------------------------------
MouseDetectedMsg	db	"Mouse detected.", 0x0A, 0x00
MouseNotDetectedMsg	db	"No mouse detected. Confirm connection.",0x0A,0x00
CheckingMouseMsg	db	"Checking for a mouse.",0x0A,0x00