;nasm -f elf hello.asm
;ld -s -o hello hello.o
;./hello

section .data

jogada	db	"A -> B",0x0A

a       db      0
b       db      0

section .text
	global _start

;------------------------------
;Funcao Imprime
;Entrada: al -> cl
;------------------------------
_imprime:

     mov [jogada],al
     mov [jogada+5],cl

     mov edx,7
     mov ecx,jogada
     mov ebx,1	; file handle (stdout)
     mov eax,4	; numero da chamada do sistema (sys_write)
     int 0x80	; chamada do kernel

     ret

;--------------------------
;Funcao Hanoi
;Entrada: edx: numero de discos
;         eax: posicao inicial
;         ebx: posicao auxiliar
;         ecx: posicao final
;--------------------------

_hanoi:

     cmp edx,1
     jne _else

     jmp _imprime

_else:

     dec edx
     push edx
     push eax
     push ebx
     push ecx

     push ebx
     mov ebx,ecx
     pop ecx
     call _hanoi

     pop ecx
     pop ebx
     pop eax
     pop edx

     call _imprime

     push edx
     push eax
     push ebx
     push ecx

     push eax
     mov eax, ebx
     pop ebx
     call _hanoi

     pop ecx
     pop ebx
     pop eax
     pop edx

     ret

_start:
     mov al,'A'
     mov bl,'B'
     mov cl,'C'
     mov edx,2
     call _hanoi

; Sair
	mov	ebx, 0	; exit code
	mov     eax, 1	; numero da chamada do sistema (sys_exit)
	int     0x80	; chamada do kernel
