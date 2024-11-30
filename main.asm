section .data
	print_format 	db "%d", 10, 0

section .text
	extern list_createNode
	extern list_pushFront
	extern list_pushBack
	extern list_print
	extern list_free

	extern printf
	extern free
	
	global _start

_start:
	push	ebp
	mov 	ebp, esp

	; alloc space for the list
	sub 	esp, 4
	mov 	dword [esp], 0

	; push 3
	mov 	ecx, esp
	push	3
	push	ecx
	call	list_pushFront
	add 	esp, 8

	; push 2
	mov 	ecx, esp
	push	2
	push	ecx
	call	list_pushFront
	add 	esp, 8

	; push 1
	mov 	ecx, esp
	push	1
	push	ecx
	call	list_pushFront
	add 	esp, 8

	; push 4
	mov 	ecx, esp
	push	4
	push	ecx
	call	list_pushBack
	add 	esp, 8

	; print
	push	dword [esp]
	call 	list_print
	add 	esp, 4

	; free
	push	dword [esp]
	call	list_free
	add 	esp, 4

	add 	esp, 4

	mov 	esp, ebp
	pop 	ebp

	xor 	ebx, ebx
	mov 	eax, 1
	int 	80h