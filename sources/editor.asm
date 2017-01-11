;
;
;---------------------------------------------------
org 0x0100
bits 16
;call print_header
read_key:
	; Get keystroke
	mov ah,01h
	int 0x16
	; AH = BIOS scan code
	cmp ah,0x48
	je up
	cmp ah,0x4B
	je left
	cmp ah,0x4D
	je right
	cmp ah,0x50
	je down
	cmp ah,0x08
	je erase
	;cmp ah,0x1B
	;je exit
	
	push 0x01
	int 0x80
	jne read_key   ; loop until Esc is pressed
;---------------------------------------------------
exit:
	push 0x00		; Go back to OS
	int 0x80
;---------------------------------------------------
print_header:
	push bx
	call .backup_attributes
	mov ah, 06h    	; Scroll up function
	xor al, al     	; Clear entire screen
	mov cx, 0000h	; Upper left corner CH=row, CL=column
	mov dx, 184Fh  	; lower right corner DH=row, DL=column 
	mov bh, 1Fh    	; WhiteOnBlue
	int 0x10
	mov al,00
	mov ah,00
	push 0x0E		;Set cursor position
	int 0x80
	call .print_text
	call .restore_attributes
	pop bx
	ret
;---------------------------------------------------
.backup_attributes:
	push ax
	push bx
	push cx
	push dx
	;Save Palette
	mov ax,1007h
	int 0x10
	mov [palette_value],al
	;Save Position
	push 0x0D
	int 0x80
	mov [cursor_position],al
	mov [cursor_position+1],ah
	push 0x0E	;Set cursor position
	int 0x80
	pop dx
	pop cx
	pop bx
	pop ax
	ret
;---------------------------------------------------
.restore_attributes:
	push ax
	push bx
	push cx
	push dx
	;Restore Palette
	mov bl,00h
	mov bh,[palette_value]
	mov ax,1000h
	int 0x10
	;Restore Position
	mov al,[cursor_position]
	mov ah,[cursor_position+1]
	push 0x0E	;Set cursor position
	int 0x80
	pop dx
	pop cx
	pop bx
	pop ax
	ret
;---------------------------------------------------
.print_text:
	push ax
	mov si,titlename 			; Print text editor
	push 0x02
	int 0x80
	
	push 0x0D	;Get cursor position
	int 0x80
	dec ah
	dec ah
	dec ah
	dec ah
	dec ah
	dec ah
	dec ah
	dec ah
	dec ah
	dec ah
	dec ah
	dec ah
	dec ah
	dec ah
	dec ah
	push 0x0E	;Set cursor position
	int 0x80
	mov si,filename 			; Print filename
	push 0x02
	int 0x80
	pop ax
	ret
;---------------------------------------------------
up:
	push ax
	push 0x0D	;Get cursor position
	int 0x80
	
	dec al
	cmp al,0x01	;Reached the top?
	je down		;Go down
	push 0x0E	;Set cursor position
	int 0x80
	pop ax
	jmp read_key
;---------------------------------------------------
down:
	push ax
	push 0x0D	;Get cursor position
	int 0x80
	
	inc al
	cmp al,0x24	;Last line?
	je up		;Go up
	
	push 0x0E	;Set cursor position
	int 0x80
	pop ax
	jmp read_key
;---------------------------------------------------
left:
	push ax
	push 0x0D	;Get cursor position
	int 0x80
	
	dec ah
	
	push 0x0E	;Set cursor position
	int 0x80
	pop ax
	jmp read_key
;---------------------------------------------------
right:
	push ax
	push 0x0D	;Get cursor position
	int 0x80
	
	inc ah
	
	push 0x0E	;Set cursor position
	int 0x80
	pop ax
	jmp read_key
;---------------------------------------------------
erase:
	push 0x0D	;Get cursor position
	int 0x80
	;Use BIOS interrupt 10h, service 0ah to print whitespace
	;at current cursor position (erase)
	mov ah,0ah
	mov al,00
	mov cx,1
	int 10h
	jmp read_key 
;---------------------------------------------------
titlename			db	"DankOS Text Editor         [              ]", 0x00
filename			db	"Untitled.txt", 0x00
palette_value		db 	0x00
cursor_position		db 	0x00,0x00

	 
