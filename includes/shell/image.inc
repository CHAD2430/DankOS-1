; **** image command ****

image_cmd:

	mov si, command_line_switches
	cmp byte [si], 0x00
	je .missing_parameter

	push es				; Set up target segment:offset
	mov ax, word [CatBuffer]
	mov es, ax
	xor bx, bx
	mov dx,es
	pop es
	
	push 0x80		; Enter graphics mode
	int 0x80
	
	push 0x84	
	int 0x80			;Draw PCX file
   ;jc .falure          ; Exit if open failed
	
	
	pop ds
	push 0x18		; Pause
	int 0x80

	push 0x82		; Exit graphics mode
	int 0x80
	jmp prompt_loop
	
.missing_parameter:

	mov si, .missing_parameter_msg
	push 0x02
	int 0x80
	jmp prompt_loop

.failure:
	pop es
	mov si, .failure_msg
	push 0x02
	int 0x80
	jmp prompt_loop





.missing_parameter_msg	db 'Required parameter missing: file name.', 0x0A, 0x00
.failure_msg			db 'File not found.', 0x0A, 0x00
.failure_not_image_msg	db 'This file is not an image.', 0x0A, 0x00
