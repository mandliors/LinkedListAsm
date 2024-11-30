; struct node
; {
;     int data;
;     struct node* next;
; }

section .rodata
    list_opener_string      db "[ ", 0
    list_closer_string      db "]" , 10, 0
    list_print_format       db "%d ", 0


section .text
    extern malloc
    extern free
    extern printf
	
    global list_createNode  ; list_createNode(node** dest, int value)
    global list_pushFront   ; list_pushFront(node** list, int value)
    global list_pushBack    ; list_pushBack(node** list, int value)
    global list_print       ; list_print(node* list)
    global list_free        ; list_free(node* list)


list_createNode:
    push    ebp
    mov     ebp, esp

    push    8
    call    malloc              ; malloc 8 bytes for the new node
    add     esp, 4

    mov     ecx, dword [ebp+8]  ; node** dest
    mov     edx, dword [ebp+12] ; int value

    mov     dword [ecx], eax    ; *dest = node
    mov     dword [eax], edx    ; node->data = value
    lea     eax, dword [eax+4]  
    mov     dword [eax], 0      ; node->next = NULL

    mov     esp, ebp
    pop     ebp
    ret


list_pushFront:
    push    ebp
    mov     ebp, esp

    sub     esp, 4              ; allocate 4 bytes for the new node

    mov     edx, dword [ebp+12] ; int value
    mov     ecx, esp

    push    edx
    push    ecx
    call    list_createNode     ; list_createNode(esp, value)
    add     esp, 8

    mov     ecx, dword [ebp+8]  ; node** list
    mov     eax, dword [ecx]    ; save *list in eax

    mov     edx, dword [esp]    ; edx = &newNode
    mov     dword [ecx], edx    ; *list = edx

    lea     edx, dword [edx+4]  ; ecx = &newNode.next
    mov     dword [edx], eax    ; newNode.next = *list

    add     esp, 4              ; clean up stack

    mov     esp, ebp
    pop     ebp
    ret


list_pushBack:
    push    ebp
    mov     ebp, esp

    sub     esp, 4              ; allocate 4 bytes for the new node

    mov     edx, dword [ebp+12] ; int value
    mov     ecx, esp

    push    edx
    push    ecx
    call    list_createNode     ; list_createNode(esp, value)
    add     esp, 8

    mov     ecx, dword [ebp+8]
    mov     ecx, [ecx]
    cmp     ecx, 0
    je      _list_pushBack_empty

_list_pushBack_loop_start:
    lea     ecx, dword [ecx+4]
    mov     edx, ecx            ; save &node->next
    mov     ecx, dword [ecx]
    cmp     ecx, 0
    jne      _list_pushBack_loop_start

    mov     ecx, dword [esp]    ; &newNode
    mov     dword [edx], ecx    ; node->next = &newNode

    add     esp, 4              ; clean up stack

    mov     esp, ebp
    pop     ebp
    ret

_list_pushBack_empty:
    mov     ecx, dword [ebp+8]  ; list**
    mov     edx, dword [esp]    ; &newNode
    mov     dword [ecx], edx    ; *list = &newNode

    mov     esp, ebp
    pop     ebp
    ret


list_print:
    push    ebp
    mov     ebp, esp

    mov     edx, list_opener_string
    push    edx
    call    printf              ; printf("[ ")
    add     esp, 4

    mov     ecx, dword [ebp+8]  ; ecx = list

_list_print_loop_start:
    cmp     ecx, 0
    je      _list_print_end

    push    ecx                 ; save current node
    mov     edx, dword [ecx]    ; edx = node->value
    push    edx
    push    list_print_format
    call    printf              ; printf("%d ", ecx)
    add     esp, 8

    pop     ecx                 ; load back current node
    lea     ecx, dword [ecx+4]
    mov     ecx, dword [ecx]    ; ecx = node->next

    jmp     _list_print_loop_start

_list_print_end:
    mov     edx, list_closer_string
    push    edx
    call    printf              ; printf("]\n")
    add     esp, 4

    mov     esp, ebp
    pop     ebp
    ret


list_free:
    push    ebp
    mov     ebp, esp

    mov     edx, dword [ebp+8]  ; edx := list

_list_free_loop_start:
    cmp     edx, 0
    je      _list_free_end

    lea     ecx, dword [edx+4]
    mov     ecx, [ecx]          ; ecx := node->next
    push    ecx                 ; save ecx
    push    edx
    call    free                ; free(node)
    add     esp, 4
    pop     ecx                 ; load saved ecx
    mov     edx, ecx            ; node = ecx

    jmp     _list_free_loop_start

_list_free_end:
    mov     esp, ebp
    pop     ebp
    ret