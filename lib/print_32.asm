;   32 bit printing functions
[bits 32]

VIDEO_MEM equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; prints a null-terminated string at EDX
print_string_32:
    pusha   ; Push register values to stack
    mov edx, VIDEO_MEM  ; Set EDX to start of VIDEO_MEM
ps32_loop:
    mov al, [ebx]   ; Store char from EBX in AL
    mov ah, WHITE_ON_BLACK  ; Store attributes of character in AH
    cmp al, 0   ; If current char is 0, terminate
    je ps32_done    ; Jump to done if string is finished
    mov [edx], ax   ; Store character with attributes at current char cell in vid mem.
    add ebx, 1  ; Increment to next char
    add edx, 2  ; Move to next char cell in vid mem
    jmp ps32_loop   ; Jump to start of loop
ps32_done:
    popa    ; Restore register values from stack
    ret     ; Return to caller
