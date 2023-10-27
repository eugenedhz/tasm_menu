.model small 

.stack 100h

ax_outpt macro
local cnv, wr 
    push cx 
    push di 
 
    mov cx, 10   
    xor di, di   


    push ax  
    push bx 
    push dx 
 
    or ax, ax     
    jns cnv   
          
    push ax 
 
    mov dx, '-' 
    mov ah, 02h  ; 02h - функция вывода символа на экран 
    int 21h      
 
    pop ax      
    neg ax      
     
cnv:   
    xor dx, dx 
 
    div cx        
    add dl, '0'  
    inc di        
 
    push dx      
 
    or ax, ax     
    jnz cnv    
 
wr:            
    pop dx      
 
    mov ah, 02h 
    int 21h      
    dec di      
    jnz wr

    pop di         
    pop dx 
    pop cx 
    pop bx 
    pop ax 

endm


ax_inpt macro buf,size
local inpt,startOfConvert,endOfConvert

    push bx 
    push cx
    push dx

inpt:
    mov [buf],size 
    mov dx,offset [buf]
    mov ah,0Ah 
    int 21h
    
    mov ah,02h ;02h - функция вывода символа на экран
    mov dl,0Dh
    int 21h 

    mov ah,02h ;02h - функция вывода символа на экран
    mov dl,0Ah
    int 21h 

    xor ah,ah
    cmp ah,[buf][1] 
    jz inpt 
    
    xor cx,cx
    mov cl,[buf][1] 

    xor ax,ax
    xor bx,bx
    xor dx,dx
    mov bx,offset [buf][2] 

    cmp [buf][2],'-' 
    jne startOfConvert 
    inc bx
    dec cl

startOfConvert:
    mov dx,10
    mul dx 
    cmp ax,8000h
    jae inpt 

    mov dl,[bx] 
    sub dl,'0' 

    add ax,dx 
    cmp ax,8000h
    jae inpt

    inc bx 
    loop startOfConvert

    cmp [buf][2],'-' 
    jne endOfConvert 
    neg ax 

endOfConvert:
    pop dx 
    pop cx
    pop bx

endm

.data
    a dw ?
    b dw ?
    x dw ? ; Результат выполнения
    m dw 5

    buff db 10 dup (0)

    m1 db 'A > B -> X = (2+B)/A','$'
    m2 db 'A = B -> X = -2','$'
    m3 db 'A < B -> X = (A-5)/B','$'
    m4 db 'Enter A and B by enter (to EXIT enter equal A and B)','$'
    m5 db 'Toropkin E.V. IUK2-31B',13,10,13,10,'$'

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
    mov dx, offset m1
    int 21h

    mov ah, 2h
    mov dh, 10
    mov dl, 27
    mov bh, 0
    int 10h

    mov ah, 09h
    mov dx, offset m2
    int 21h

    mov ah, 2h
    mov dh, 11
    mov dl, 27
    mov bh, 0
    int 10h

    mov ah, 09h
    mov dx, offset m3
    int 21h

    mov ah, 2h
    mov dh, 13
    mov dl, 15
    mov bh, 0
    int 10h

    mov ah, 09h
    mov dx, offset m4
    int 21h

    mov ah, 02h
    mov dx, 0h
    mov bh, 0

    int 10h

    mov ah, 09h
    mov dx, offset m5
    int 21h

    mov ah, 2h
    mov dh, 15
    mov dl, 0
    mov bh, 0

    int 10h

    select_loop:
        mov ah, 09h
        mov dx, offset select
        int 21h

        ax_inpt buff,5
        mov a, ax

        mov ah, 09h
        mov dx, offset select
        int 21h

        ax_inpt buff,5
        mov b, ax

        mov ax, a
        mov bx, b
        xor dx, dx

        cmp ax, bx
        jg more

        cmp ax, bx
        jl less

        jmp equal

    less:
        cmp ax, m
        jl lessn
        jmp lessp

    lessn:
        mov ax, a
        sub ax, 5
        neg ax

        idiv bx
        neg ax


        ax_outpt
        call entr

        jmp select_loop

    more:
        cmp bx, -2
        jl moren
        jmp morep

    moren:
        mov ax, b
        add ax, 2
        neg ax
        idiv a
        neg ax
        
        ax_outpt
        call entr

        jmp select_loop

    morep:
        mov ax, b
        add ax, 2

        idiv a
        
        ax_outpt
        call entr

        jmp select_loop

    lessp:
        mov ax, a
        sub ax, 5

        div bx


        ax_outpt
        call entr

        jmp select_loop

    equal:
        mov ax, -2


        ax_outpt
        call entr


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
