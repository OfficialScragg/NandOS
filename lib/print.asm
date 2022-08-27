;   print_string -> Print the string at address stored in dx 
;   Parameters:
;       bx = Address of string (mov bx, VAR)
print_string:
    pusha   ; Push all registers to stack
    mov ah, 0x0e    ; Print to screen interrupt
    mov dx, $$
ps_loop:
    mov al, [bx]  ; Select next character in string
    cmp al, 0   ; If char is termination character then end
    je ps_end   ; Jump if al = 0
    int 0x10    ; Execute interrupt
    add bx, 1
    jmp ps_loop ; Loop back
ps_end:
    popa    ; Restore all register values from stack
    ret     ; Return

;   print_hex -> Prints a hex value as a string.
;   Parameters:
;       dx = Hex value to be printed as ASCII (mov dx, 0xAAAA)
;       bx = Address of hex output variable (HEX_RES: db "0x0000", 0x00) -> (mov bx, HEX_RES)
print_hex:
    pusha
    add bx, 2
    mov ax, dx     ;Original number
    and al, 15     ;Keep 4 bits
    add al, '0'    ;Make text
    cmp al, '9'
    jbe ph_one     ;Already fine for '0' to '9'
    add al, 7      ;Bridge the gap to reach 'A' to 'F'
ph_one:
    mov [bx + 3], al
    mov ax, dx     ;Original number
    shr ax, 4
    and al, 15     ;Keep 4 bits
    add al, '0'    ;Make text
    cmp al, '9'
    jbe ph_two     ;Already fine for '0' to '9'
    add al, 7      ;Bridge the gap to reach 'A' to 'F'
ph_two:
    mov [bx + 2], al
    mov ax, dx     ;Original number
    shr ax, 8
    and al, 15     ;Keep 4 bits
    add al, '0'    ;Make text
    cmp al, '9'
    jbe ph_three     ;Already fine for '0' to '9'
    add al, 7      ;Bridge the gap to reach 'A' to 'F'
ph_three:
    mov [bx + 1], al
    mov ax, dx     ;Original number
    shr ax, 12
    and al, 15     ;Keep 4 bits
    add al, '0'    ;Make text
    cmp al, '9'
    jbe ph_four     ;Already fine for '0' to '9'
    add al, 7      ;Bridge the gap to reach 'A' to 'F'
ph_four:
    mov [bx], al
ph_end:
    popa
    ret