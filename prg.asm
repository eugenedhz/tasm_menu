.model small

.data
    a dw ?
    b dw ?
    x dw ? ; Результат выполнения

    menu1 db 'A > B -> X = (2+B)/A','$'
    menu2 db 'A = B -> X = -2','$'
    menu3 db 'A < B -> X = (A-5)/B','$'
    menu4 db 'Enter A and B by enter (to EXIT enter equal A and B)',13,10,13,10,'$'

    m db 'X = (2+B)/A',13,10,'$'
    e db 'X = -2',13,10,'$'
    l db 'X = (A-5)/B',13,10,'$'

    select db 'input>','$'     

.code
    mov ax, @data
    mov ds, ax

    ; устанавливаем видеорежим и цвет фона и цвет шрифта в bh
    mov ax, 0600h
    mov bh, 00110000b
    mov cx, 0
    mov dx, 185fh
    int 10h

    ; установка курсора
    mov ah, 2h
    mov dh, 9
    mov dl, 27
    mov bh, 0
    int 10h

    mov ah, 09h
    mov dx, offset menu1
    int 21h

    ; установка курсора
    mov ah, 2h
    mov dh, 10
    mov dl, 27
    mov bh, 0
    int 10h

    mov ah, 09h
    mov dx, offset menu2
    int 21h

    ; установка курсора
    mov ah, 2h
    mov dh, 11
    mov dl, 27
    mov bh, 0
    int 10h

    mov ah, 09h
    mov dx, offset menu3
    int 21h

    ; установка курсора
    mov ah, 2h
    mov dh, 13
    mov dl, 15
    mov bh, 0
    int 10h

    mov ah, 09h
    mov dx, offset menu4
    int 21h

    select_loop:
        mov ah, 09h
        mov dx, offset select
        int 21h

        mov ah, 01h
        int 21h

        mov cx, 0
        mov cl, al
        mov a, cx

        call entr

        mov ah, 09h
        mov dx, offset select
        int 21h

        mov ah, 01h
        int 21h

        mov bx, 0
        mov bl, al
        mov b, bx

        call entr

        mov ax, a
        mov bx, b

        cmp ax, bx
        jg more

        cmp ax, bx
        jl less

        cmp ax, bx
        je equal

        jmp select_loop

    more:
        add bx, 2
        xchg ax, bx
        div bx
        mov x, ax

        mov ah, 09h
        mov dx, offset m
        int 21h

        jmp select_loop

    less:
        sub ax, 5
        div bx
        mov x, ax

        mov ah, 09h
        mov dx, offset l
        int 21h

        jmp select_loop

    equal:
        mov x, -2

        mov ah, 09h
        mov dx, offset e
        int 21h

        jmp exit

    exit:
        mov ax, 4c00h
        int 21h

    entr:
        mov ah, 02h
        mov dl, 0Ah
        int 21h

        ret
        
end
