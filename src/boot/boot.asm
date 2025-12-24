ORG 0x7C00
BITS 16

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

_start:
    jmp short start
    nop

times 33 db 0

start:
    jmp 0: step2


step2:    
    cli ; Clear interrupts
    mov ax, 0x00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti ; Enable interrupts

.load_protected:
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:load32

;GDT
gdt_start:
    
gdt_null:
    dd 0x0
    dd 0x0

;offset 0x08    
gdt_code:        ; CODE SEGMENT SHOULD POINT TO THIS
    dw 0xFFFF    ;SEGMENT LIMIT FIRST 0-15 BITS
    dw 0         ;BASE FIRST 0-15 BITS         
    db 0         ;BASE 16-23 BITS
    db 0x9A      ;ACCESS BYTE
    db 11001111b ;HIGH 4 BIT FLAGS AND LOW 4 BITS OF FLAGS
    db 0         ;BASE 24-31 BITS

gdt_data:       ; DS, SS, ES, FS, GS SHOULD POINT TO THIS
    dw 0xFFFF    ;SEGMENT LIMIT FIRST 0-15 BITS
    dw 0         ;BASE FIRST 0-15 BITS
    db 0         ;BASE 16-23 BITS
    db 0x92      ;ACCESS BYTE
    db 11001111b ;HIGH 4 BIT FLAGS AND LOW 4 BITS OF FLAGS
    db 0         ;BASE 24-31 BITS

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

[BITS 32]
load32:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x00200000
    mov esp, ebp

    ; Enable A20 line
    in al, 0x92
    or al, 2
    out 0x92, al

    jmp $

times 510-($ - $$) db 0
dw 0xAA55
