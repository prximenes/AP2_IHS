org 0x7c00
jmp 0x0000:__start

    msg: DB 'Aula de IHS', 0x0A, 0x0D, 0

%macro setIVT 3                 ; %1 = número da interrupção / %2 = CS / %3 = IP
    PUSH DS                     ; Salvando DS na pilha
    XOR AX, AX                  ; Zerando AX
    MOV DS, AX                  ; Setando DS com o endereço 0
    MOV BX, %1                  ; BX recebe o número da interrupção
    SHL BX, 2                   ; BX = BX * 4 
    MOV DI, BX                  ; Offset  da interrupção %1 na IVT
    MOV WORD[DS:DI], %3         ; Salvando o IP
    MOV WORD[DS:DI + 2], %2     ; Salvando o CS
    POP DS                      ; Recuperando o DS antigo
%endmacro

__start:
    xor ax, ax
    mov ds, ax

    xor ah, ah
    mov al, 0xe
    xor bh, bh
    int 10h

    mov ah, 0xb
    xor bh, bh
    mov bl, 15
    int 10h

zerarDisco:
    xor ah, ah
    xor dl, dl
    int 13h
    jc zerarDisco

    setIVT 20h, 0x0050, 0x0000

lerDisco: 
    mov ah, 02h
    mov al, 2
    xor ch, ch
    mov cl, 2 
    xor dx, dx
    mov bx, 0x0050
    mov es, bx
    xor bx, bx
    int 13h
    jc lerDisco

interrupcao:
    push msg
    int 20h

times 510 -($-$$) db 0
dw 0xaa55 
