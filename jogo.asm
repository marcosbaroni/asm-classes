extern scanf, myrand

section .data
	nl	db 10
	nls	times 50 db 10
	msg1	db "%d", 0
	msg2	db "O novo numero eh: "
	len2 equ $ - msg2
	msg3	db "Digite a sequencia: "
	len3 equ $ - msg3
	msg4	db 0x0A, "****** GAME OVER! Voce acertou "
	len4 equ $ - msg4
	msg5	db "numeros. ******", 0x0A
	len5 equ $ - msg5
	msg6	db "A sequencia certa era: "
	len6 equ $ - msg6
	n	dd 0

section .bss
	saida	resb 11			; Variavel de saida
	vetor1	resd 100
	number	resd 1

section .text
	global jogo

jogo:
	enter 0, 0
	pusha

	jogo_loop:
		call print_nls
		call print_msg2
		call print_msg3
		call read_seq
		jmp jogo_loop

fim:
	popa
	leave
	ret


print_msg3:
	pusha

	mov ecx, msg3
	mov edx, len3
	mov eax, 4
	mov ebx, 1
	int 0x80

	popa
	ret


read_seq:
	pusha

	mov edi, 0
	mov esi, vetor1
	read_seq_loop:
		cmp edi, [n]
		jnl read_seq_end
		push number
		push msg1
		call scanf
		add esp, 8
		mov eax, [number]
		cmp eax, [esi]
		jne erro
		inc edi
		add esi, 4
		jmp read_seq_loop

	read_seq_end:
		popa
		ret

	erro:
		mov ecx, msg4
		mov edx, len4
		mov eax, 4
		mov ebx, 1
		int 0x80
		mov eax, [n]
		dec eax
		call print_number
		mov ecx, msg5
		mov edx, len5
		mov eax, 4
		mov ebx, 1
		int 0x80
		mov ecx, msg6
		mov edx, len6
		mov eax, 4
		mov ebx, 1
		int 0x80
		call print_vetor
		call print_nl
		mov eax, 1
		int 0x80


print_msg2:
	pusha

	mov ecx, msg2
	mov edx, len2
	mov eax, 4
	mov ebx, 1
	int 0x80

	call myrand
	call print_number
	call print_nl

	mov ecx, eax
	mov eax, [n]
	mov ebx, 4
	mul ebx
	add eax, vetor1
	mov [eax], ecx
	inc dword [n]

	popa
	ret


print_nls:
	pusha
	mov ecx, nls
	mov edx, 50
	mov eax, 4
	mov ebx, 1
	int 0x80
	;mov ecx, 100

	;print_nls_loop:
	;	call print_nl
	;	loop print_nls_loop

	popa
	ret


print_nl:
	pusha
	mov ecx, nl
	mov edx, 1
	mov eax, 4
	mov ebx, 1
	int 0x80
	popa
	ret


print_vetor:
	pusha

	mov ebx, vetor1
	mov ecx, [n]
	print_vetor_loop:
		mov eax, [ebx]
		call print_number
		add ebx, 4
		loop print_vetor_loop

	popa
	ret

; entrada: numero a ser impresso em eax (altera a variavel saida)
; saida: numero impresso na tela
print_number:
	pusha
	mov ebx, saida
	add ebx, 10			; ebx aponta para a ultimo posicao de saida
	mov [ebx], byte ' '		; inclui um "enter" no final da string
	mov ecx, 10			; porque os numeros serao impressos como decimais
	mov esi, 1			; esi contem o tamanho da string

	cmp eax, 0
	jne print_number_loop
	dec ebx
	mov byte [ebx], '0'
	inc esi
	jmp print_number_end

	print_number_loop:
		cmp eax, 0
		je print_number_end
		dec ebx			; volta uma posicao na string
		xor edx, edx		; faz parte da divisao
		div ecx			; divide o numero por 10
		add dl, '0'		; transforma o ultimo algarismo em caracter
		mov [ebx], dl	; coloca o caracter na string
		inc esi			; incrementa o numero de algarismos
		jmp print_number_loop

	print_number_end:
		mov ecx, ebx		; string a ser impressa
		mov edx, esi		; tamanho da string
		mov ebx, 1
		mov eax, 4
		int 0x80		; imprime
		popa
		ret


