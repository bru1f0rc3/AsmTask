; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "press any key...$"
    A DB ?
    X DB ?
    Y DB ?
    Y1 DB ?
    Y2 DB ?
    VVOD_A DB 13,10,"VVEDITE A=$"
    VVOD_X DB 13,10,"VVEDITE X=$",13,10
    VIVOD_Y DB "Y=$"
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here  
XOR AX, AX
MOV DX, OFFSET VVOD_A
MOV AH, 9
INT 21H

SLED2:
    MOV AH, 1
    INT 21H
    CMP AL, "-"
    JNZ SLED1
    MOV BX, 1
    JMP PRIOBRAZ
    
SLED1:
    SUB AL, 30H
    TEST BX, BX
    JZ SLED3
    NEG AL
    
PRIOBRAZ:
    NEG AL
SLED3:
    MOV A, AL
    XOR AX, AX
    XOR BX, BX
    MOV DX, OFFSET VVOD_X
    MOV AH, 9
    INT 21H

SLED4:
    MOV AH, 1
    INT 21H
    CMP AL, "-"
    JNZ SLED5
    MOV BX, 1
    JMP PRIOBRAZ1
    
SLED5:
    SUB AL, 30H
    TEST BX, BX
    JZ SLED6
    NEG AL

PRIOBRAZ1:
    NEG AL
SLED6:    
    MOV X, AL

MOV AL, X
CMP AL, 3
JG Y1_GREATER_BRANCH
MOV AL, X
CMP AL, 0
JGE Y1_POSITIVE_X
NEG AL

Y1_POSITIVE_X:
    MOV Y1, AL
    MOV AL, A
    CMP AL, 0
    JGE Y1_POSITIVE_A
    NEG AL 
    
Y1_POSITIVE_A:
    ADD Y1, AL
    JMP Y1_CALCULATED

Y1_GREATER_BRANCH:
MOV AL, X
IMUL A
MOV Y1, AL

Y1_CALCULATED:
MOV AL, A
CMP AL, X
JE Y2_EQUAL_BRANCH
MOV AL, A
SUB AL, X
MOV Y2, AL
JMP Y2_CALCULATED

Y2_EQUAL_BRANCH:
    MOV AL, A
    CMP AL, X
    JNE Y2_NOT_EQUAL
    MOV Y2, 3
    JMP Y2_CALCULATED
Y2_NOT_EQUAL:
    MOV AL, A
    SUB AL, X
    MOV Y2, AL
Y2_CALCULATED:
    MOV AL, Y1
    SUB AL, Y2
    MOV Y, AL
    ADD AL, 30H

    MOV AH, 2 
    MOV DL, AL
    INT 21H
ENDS 
            
    lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.