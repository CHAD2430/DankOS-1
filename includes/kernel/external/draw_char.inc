
;----------------------------------------------------------------------
;	DISPLAY ONE CHARACTER IN "AL" WITH "COLOR".
;    IN: AL --> Character
;        CX --> How many times to display
;        
;
;
draw_char:
	push ax
	push bx
	push cx
	mov  ah, 9
	mov  bh, 0
	int  10h
	pop cx
	pop bx
	pop ax
	iret