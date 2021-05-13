IDEAL
MODEL small 
STACK 256

MACRO delay	time 
local outer
push cx
mov	cx, time
outer:		;зовнiшнiй цикл 
push cx
mov	cx, 0FFFFh
loop $	;внутрiшнiй цикл, стрибати на
;	мiсцi cx раз (9,10)
pop	cx	;вiдновлення cx (11)
loop outer	;сx <-cx-1 i, якщо cx<>0, то перехiд outer, 
pop	cx
ENDM
 


DATASEG
string db 254		;string variable def. There is max len , 
str_len db	0		;под запись реально
					; числа символов: 
db 254 dup ('*')	; Буфер

system_message_1 DB "Input somthing\ " ,'$' 
display_message_0 DB "------------menu bagin	", 13, 10, '$'
display_message_1 DB "n - for count", 13, 10, '$' 
display_message_2 DB "M - for beep", 13, 10, '$' 
display_message_3 DB ", - for exit",	13, 10, '$'
display_message_4 DB "----------programm for lab is END !!! - for exit", 13, 10, '$' 
display_message_5 DB "------------menu end	", 13, 10, '$'
message DB ?

test_message_1 DB "COUNT",	13, 10, '$'
test_message_2 DB "BEEP",	13, 10, '$'
test_message_3 DB "EXIT",	13, 10, '$' 

;------Константи для функції звуку 
_100Hz DW	11930	;вихiдне значення лiчильника ПТ
len_snd DW	45	;тривалiсть звучання
null db 13,10, '$'
;---------------------------------------------------
a1 dw -2
a2 dw 3
a3 dw 1
a4 db 2
a5 db 3

CODESEG

Start:
mov ax, @data 
mov ds, ax

Main_cусle:
 
call display_foo_main 
call input_foo
cmp ax, 06eh ; c ascii =6eh 
je Count
cmp ax, 04dh ; M ascii =4dh 
je Beep
cmp ax, 02ch ; q ascii =2ch 
je Exit
jmp Main_cусle

Count:
mov dx, offset test_message_1 
call display_foo
call calc
jmp Main_cусle

;---------------------------------------------------	 
Beep:
	; виклик функції звуку 
mov dx, offset test_message_2
call display_foo 
call zvukF1 
jmp Main_cусle

;---------------------------------------------------
Exit:
mov dx, offset test_message_3
call display_foo
mov ax,04C00h	;
int 21h	; пpеpывания DOS

;---------------------------------------------------
PROC display_foo_main
mov dx, offset display_message_0 
call display_foo
mov dx, offset display_message_1 
call display_foo
mov dx, offset display_message_2
call display_foo
mov dx, offset display_message_3 
call display_foo
mov dx, offset system_message_1 
call display_foo
mov dx, offset display_message_5 
call display_foo
ret
ENDP display_foo_main
;---------------------------------------------------
PROC display_foo; input dx is offset
mov ah,9 
int 21h 
xor dx, dx 
ret
ENDP display_foo
;----------------------------------------------------
PROC input_foo	; input string out ax
mov ah, 0ah		; ah <- 0ah input 
mov dx, offset string	; dx <- offset string
int 21h	; call 0ah function DOS int 21h

xor ax, ax
mov bx, offset string 
mov ax, [bx+1]
shr ax, 8 
ret

ENDP input_foo 

PROC zvukF1

;програмування таймера 
mov	al, 0B6h
out	43h, al	;РУС ПТ(порт 43h)<-al (2)
;завантаження буферного регiстра 2 таймера
mov	ax, [_100Hz]	;пересилання Nпоч.= 11930=2E9Ah в ax (3) 
out	42h, al	;порт 42h<-МБ11930=9Ah (3)
mov	al, ah	;al<-ah=СБ11930=2Eh (3)
out	42h, al	;порт 42h<-СБ11930=2Eh (3)
;ввiмкнення каналу 2 таймера та динамiка
in	al, 61h	;
or	al, 3	;al<-(al\/03h) (4)
out	61h, al	;порт 61h<-al (4)

delay [len_snd]	;встановлення затримки (див. macros.mac) 
and	al, 11111100b ;маска вимикання звуку (15)
out	61h, al	;порт 61h<-al (15) 
ret
ENDP zvukF1

PROC calc  

     ;процедура обчислення виразу, та його виводу на екран
mov ax, [a1]    ;запис а1 до ax
mov bx, [a2]	;запис а2 до bx
sub ax,bx		;ax - bx, результат в al
mov bx, [a3]	;запис а3 до bx
add ax,bx		;ax + bx, результат в ax
mov bl, [a4]	;запис а4 до bx
idiv bl			;ax / bl, результат в al
mov ah, [a5]	;запис а5 до ah
imul ah			;ah * al, результат в ax


mov bx, ax      ;заносимо значення ax до bx
neg bx          ;змінюємо знак в регістрі bx
cmp ax, bx      ;порівнюємо значення в ax та bx
jb outer        ;якщо значення нижче(FF-від'ємне, але вище ніж 01-додатнє) пропускаємо minus

minus:      ;
    mov ax, bx  ;беремо додатнє значення    
    mov ah, '-' ;запис знака "-"
    jmp outer   ;вихід
outer:      ;

add al, 30h ;щоб вивід був в ASCII
mov dl, ah  ;занесення значення для виводу
mov dh, al  ;занесення значення для наступного виводу
mov ah, 02h ;команда виводу байта
int 21h     ;переривання DOS
mov dl, dh  ;вивід наступного значення
int 21h     ;переривання DOS

mov ah,09h      ;команда виводу рядка  
lea dx, [null]  ;вивід пустого рядка
int 21h         ;переривання DOS

ret         ;повернення з процедури
ENDP calc   ;кінець процедури


END Start
 
