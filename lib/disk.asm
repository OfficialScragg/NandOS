;
; Load DH sectors to ES:BX from drive DL
;
disk_load:
    push dx ; Store DX on stack to check if we read all expected sectors
    mov ah, 0x02    ; BIOS read sector function
    mov al, dh      ; Read DH (number of) sectors
    mov ch, 0x00    ; Select cylinder 0
    mov dh, 0x00    ; Select head 0
    mov cl, 0x02    ; Start reading from 2nd sector (skip boot sector)

    int 0x13    ; BIOS interrupt

    jc disk_error_unkn   ; Jump if error (i.e. if carry flag set)

    pop dx  ; Retrieve DX from stack to see if all sectors were read
    cmp dh, al  ; if AL != DH (Not all sectors were read => error)
    jne disk_error_miss  ; Jump to display error
    ret ; Return

disk_error_unkn: ; Handle disk read errors
    mov bx, DISK_ERROR_MESSAGE_UNKN  ; Retrieve error message
    call print_string   ; Print error message
    jmp $   ; Jump to current location forever

disk_error_miss: ; Handle disk read errors
    mov bx, DISK_ERROR_MESSAGE_MISS  ; Retrieve error message
    call print_string   ; Print error message
    jmp $   ; Jump to current location forever

; Variables
DISK_ERROR_MESSAGE_UNKN: db "Disk read error: Unknown.", 0
DISK_ERROR_MESSAGE_MISS: db "Disk read error: Partial read.", 0
