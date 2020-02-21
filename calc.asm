section .bss
     resultado resb 11

section .data
;     resultado resb 11
     nopf  db 0
     ntop db 0
     op   db 0
     a    dd 0
     b    dd 0
     msg  db 49

section.txt
     global _start

_start:
     pop eax
     mov edx,0
     mov ebx,2
     div eax
     dec eax
     mov [ntop],al
     pop eax
     pop edx
call armazena
     mov [a], eax
     pop eax
     mov eax,[eax]
     jmp leroperacao



armazena;
;*******************************************************
;Funcao q armazena um numero em string em eax em binario
;edx ponteiro para primeiro char    
;ebx char em uso
;eax soma jah em bin
     mov eax,0
     mov ecx,0

armazenaloop:
     mov ebx,10
     push edx
     mul ebx
     pop edx
     mov ebx,[edx]
     sub ebx,48
     add eax,ebx
     add ecx,1
     mov ebx,[edx+ecx]
     cmp ebx,0
     jne armazenaloop
     ret




     
leroperacao:

     mov [op],al

     mov ecx,0
     mov [b],ecx
     pop edx
call armazena
     
     mov [b],eax
     mov eax,[a]
     mov ebx,[b]
     mov edx,[nopf]
     add edx,1
     mov [nopf],edx
     mov edx,[op]
     cmp edx,'+'
     je somar
jmp termina
     cmp edx,'-'
     je subtrair
     cmp edx,'/'
     je dividir
     cmp edx,'*'
     je multiplicar

continua:
     mov ebx,[ntop]
     mov edx,[nopf]
     cmp ebx,edx
     je termina
     jmp leroperacao

somar:
     
     add eax,ebx
     mov [a],eax
     
     pop eax
     mov eax,[eax]
     jmp continua
     
subtrair:

     sub eax,ebx
     mov [a],eax
     
     pop eax
     mov eax,[eax]
     
     jmp continua
     
dividir:
     mov edx,0
     div ebx
     mov [a],eax     

     pop eax
     mov eax,[eax]
     
     jmp continua
     
multiplicar:

     mul ebx
     mov [a],eax

     pop eax
     mov eax,[eax]

     jmp continua

termina:
     mov eax,[a]
     mov edx,0
     mov ebx,10
     mov ecx,10
loopresultado:
     div ebx
     mov [resultado+ecx],edx

     cmp eax,0
     je imprimi

     mov edx,0
     dec ecx
     jmp loopresultado


imprimi:







fim:
add eax,[a+1]
add eax,71
mov [msg],al

; Escrever a string para o stdout
        mov     edx, 1
	mov     ecx, msg
	mov     ebx,1	; file handle (stdout)
	mov     eax,4	; numero da chamada do sistema (sys_write)
	int     0x80	; chamada do kernel


; Sair
	mov	ebx, 0	; exit code
	mov     eax, 1	; numero da chamada do sistema (sys_exit)
	int     0x80	; chamada do 


; /  47
; +  43
; - 45
;
