;scanf muda valor de eax, ecx e edx
;
;scanf ("%d",&number)
;push number
;push msg1
;call scanf

;nasm -f elf tsp.asm
;gcc -0 tsp main.c tsp.o

;esp                                                 ebp
;0|0| | | | | | | | | | | | | | | | | | | | | | | | | |
; esp+4

extern scanf

section .data
     msg1 db "%d",0   ; primeiro argumento do scanf("%d",&n);
     n    db 0        ;numero de leituras
     vet  dd 0        ;vetor
section .text
     global ler

ler:
     enter 0,0
     pusha
     
     mov eax,[ebp+8]
     mov [n],eax

     mul eax
     mov ebx,4
     mul ebx
     mov esi, eax

     sub esp,esi
     mov [vet],esp
     mov esi,0
loopleitura:
     cmp esi,eax
     je fimleitura

     mov edx,[vet]
     add edx,esi
     push edx
     push msg1
     call scanf
     add esp,8

     add esi,4
     jmp loopleitura

fimleitura:
     mov eax,[n]
     mul eax
     
     mov edx,eax
     mov ecx,vet
     mov ebx,1
     mov eax,4
     int 0x80

     popa
     leave
     ret