ORG 0
BITS 16
_start:
    jmp short start
    nop

times 33 db 0

start:
    jmp 0x7C0: step2


step2:    
    cli ; Clear interrupts
    mov ax, 0x07C0
    mov ds, ax
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7C00
    sti ; Enable interrupts

    mov ah, 2 ; READ SECTORS COMMAND
    mov al, 1 ; NUMBER OF SECTORS TO READ
    mov ch, 0 ; CYLINDER LOW 8 BITS
    mov cl, 2 ; READ SECTOR 2 (1 BASED)
    mov dh, 0 ; HEAD NUMBER
    mov bx, buffer ; BUFFER TO STORE DATA
    int 0x13 ; BIOS DISK SERVICE
    jc error ; JUMP IF CARRY SET (ERROR)


    mov si, buffer
    call print

    jmp $

error:
    mov si, error_message
    call print

    jmp $


print:
    mov bx, 0
.loop:
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp .loop
.done:
    ret

print_char:
    mov ah, 0eh
    int 0x10
    ret

error_message: db 'failed to read sector!', 0

times 510-($ - $$) db 0
dw 0xAA55

buffer:
