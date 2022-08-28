; Simple boot sector program
[org 0x7c00]
    mov [BOOT_DRIVE], dl    ; BIOS stores the boot drive in DL, save it for later

    mov bp, 0x8000  ; Set stack position
    mov sp, bp      ; Move stack head to start of stack

    mov ah, 0x00    ; Clear screen
    mov al, 0x03    ; Text mode
    int 0x10        ; Call BIOS interrupt to print.

    mov bx, HEADER  ; NandOS header
    call print_string   ; Print header

    mov bx, 0x9000  ; Load data to 0x9000
    mov dh, 2   ; Load 2 sectors
    mov dl, [BOOT_DRIVE]    ; Load sectors from drive 0 (Stored in BOOT_DRIVE variable)
    call disk_load  ; Call disk_load function

    mov dx, [0x9000]    ; Get data from address 0x9000
    mov bx, HEX_RES     ; Set return data address
    call print_hex      ; Send data from 0x9000 to HEX_RES
    call print_string   ; Print data in HEX_RES

    mov bx, [SECTOR_SIZE]   ; Set BX to 512 for use in effective address expression
    mov dx, [0x9000 + bx]   ; Retrieve bytes from sector 3
    mov bx, HEX_RES         ; Set return address for data
    call print_hex          ; Send data from 0x9000+SECTOR_SIZE to HEX_RES
    call print_string      ; Print data in HEX_RES

    jmp $   ; Jump to current location forever

; External functions
%include "./lib/print.asm"      ; Load printing functions
%include "./lib/print_32.asm"   ; Load 32bit printing functions
%include "./lib/disk.asm"       ; Load disk related functions
%include "./lib/gdt.asm"        ; Load GDT definition function

; Variables
HEADER: db "+--------+", 0x0A, 0x0D, "| NandOS |", 0x0A, 0x0D, "+--------+", 0x0A, 0x0D, 0x00
HEX_RES: db "0x0000", 0x0A, 0x0D, 0x00  ; Used to retrieve HEX string value
BOOT_DRIVE: db 0    ; Number of the drive with our boot sector on it (Given by BIOS)
SECTOR_SIZE: dw 512 ; Sectors on disks are 512 bytes

; Padding and magic BIOS number
    times 510-($-$$) db 0
    dw 0xaa55

; Filling following sectors for testing
    times 256 dw 0xdead
    times 256 dw 0xface