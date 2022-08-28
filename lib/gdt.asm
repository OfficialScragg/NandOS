; Defining the GDT to enter into 32 bit protected mode

gdt_start:

gdt_null:   ; Add the null segment descriptor at the beginning of the table
    dd 0x0  ; dd = double word = 4 bytes
    dd 0x0

gdt_code:       ; Code segment descriptor
    dw 0 xffff  ; Limit ( bits 0 -15)
    dw 0 x0     ; Base ( bits 0 -15)
    db 0 x0     ; Base ( bits 16 -23)
    db 10011010 b   ; 1st flags , type flags
    db 11001111 b   ; 2nd flags , Limit ( bits 16 -19)
    db 0 x0     ; Base (bits 24-31)

gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gdt_end:

gdt_descriptor: ; Structure that is given to the CPU that describes the GDT (Size and Address)
    dw gdt_end - gdt_start -1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start