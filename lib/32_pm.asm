; Switch CPU to 32bit protected mode.

switch_to_32bit_pm: ; Switch to 32bit protected mode
    cli ; Clear/Disable interrupts
    lgdt [gdt_descriptor]   ; Point to our GDT descriptor
    mov eax, cr0    ; ----
    or eax, 0x1     ;   Tell the CPU to switch to 32bit PM
    mov cr0, eax    ; ----

    jmp CODE_SEG:init_pm    ; Perform far jump to clear pipeline of 16bit instructions

[bits 32]   ; 32bit protected mode code
init_pm:    ; Initialise registers and stack in PM
    mov ax, DATA_SEG    ; -----
    mov ds, ax          ;
    mov ss, ax          ;   Set all segment pointers to
    mov es, ax          ;   data segment in GDT.
    mov fs, ax          ;
    mov gs, ax          ; -----

    mov ebp, 0x90000    ; Set stack position to 0x90000
    mov esp, ebp        ; which is the top of the free space.

    call start_pm