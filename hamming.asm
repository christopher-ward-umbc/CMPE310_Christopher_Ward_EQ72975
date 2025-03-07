section .data
	foo db "1111", 0 ;the word
	lenFoo equ $ - foo ;length of the word
	bar db "0000", 0  ;the other word
	lenBar equ $ - bar ;length of the other word

	newline db 0x0A, 0 ; variables i used for testing output statements. no longer necessary
	testVar db "Enter a binary string\t " 
	testLen equ $ - testVar
	statement2 db "Enter another binary String\t"
	stateLen equ $ - statement2

	hamming dw 0, 0
	count dw 0, 0

section .bss
	distance resb 5
	user_input1: resb 25 
	user_input_size1 equ $- user_input1
	user_input2: resb 25
	uesr_input_size2 equ $- user_input2

section .text
	global _start

_start:
	mov eax, 4
	mov ebx, 1
	mov ecx, testVar
	mov edx, testLen
	int 0x80

	mov eax, 3
	mov ebx, 0
	mov ecx, foo
	mov edx, lenFoo
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, statement2
	mov edx, stateLen
	int 0x80

	mov eax, 3
	mov ebx, 0
	mov ecx, bar
	mov edx, lenFoo
	int 0x80
	
	xor esi, esi
	xor ecx, ecx
	xor edx, edx
	xor bl, bl
	jmp largerFoo

largerFoo:
	mov al, [foo + edx]	
	cmp al, byte 0
	je largerBar

	inc edx
	jmp largerFoo

largerBar:
	mov ah, [bar + esi]
	cmp ah, byte 0
	je label

	inc esi
	jmp largerBar


label:
	cmp ecx, 255
	jge out
	
	mov al, [foo + ecx]
	mov ah, [bar + ecx]

	cmp al, byte 0
	je sumLoop	

	cmp ah, byte 0
	je sum2


	cmp al, ah
	je equal
	
	inc bl


equal:
	add ecx, 1
	cmp al, ah
	
	jmp label
	

;bunch of functions because i thought I had to add the longer string's extra length to the distance. I don't but this works so i'm not changing it!!!
sum2:
	cmp esi, edx
	je finale2
	
	sub esi, 1

finale2:
	cmp ecx, edx
	je out
	
	inc ecx

sumLoop:
	xor ecx, ecx
	cmp esi, edx
	je finale

	sub edx, 1

finale:
	cmp ecx, esi
	je out

	inc ecx

out:
	sub bl, 1
	add bl, '0' ;converts bl into a string
	mov [hamming], bl ;moves value of "bl" into hamming distance

	mov eax, 4
	mov ebx, 1	
	mov ecx, hamming
	mov edx, lenFoo
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, 1
	int 0x80

	mov eax, 1
	xor ebx, eax
	int 0x80
