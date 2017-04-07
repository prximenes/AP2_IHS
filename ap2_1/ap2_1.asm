org 0x0500

jmp 0x0000:ISR_20

__printf:
   xor cl, cl

   _in:
	lodsb 
	cmp al, cl
	je .sair

	mov ah, 0xe
	xor bh, bh
	mov bl, 3
	int 10h

	jmp _in

   .sair:
       ret

%define msg	[BP+8]
ISR_20:
	push bp
	mov bp, sp
	push si
	mov si, word msg
	call __printf
	pop si
	pop bp
	iret