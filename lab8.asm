TITLE	STRMENU (EXE)


.MODEL SMALL
.STACK 2048

M_write_results MACRO
	mov ah, 13h					; Код функції (AH = 13h - Вивід символу у позиції курсору)
	mov al, 00h					; Код підфункції (0 = вивід кольору BL без зміщення курсору)
	mov dh, 7		; Строка виводу
	mov dl, 0	; Колонка виводу
	mov bl, 60h		; Колір, що виводиться
	mov cx, 55	; Кількість символів для відображення
	int 10h						; Переривання BIOS.
ENDM 

delay MACRO 	time 
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

.DATA
; 	

creators_message db ' Team 9 consists of Filonenko, Kruvoruk and Davidenko  '

;------Константи для функції звуку 
_100Hz DW	11931	;вихiдне значення лiчильника ПТ 1193181/100 = 11931
len_snd DW	45	;тривалiсть звучання
null db 13,10, '$'
;---------------------------------------------------
a1 dw -2
a2 dw 3
a3 dw 1
a4 db 2
a5 db 3

current_option db 1

TOPROW	EQU	08	;Верхній рядок меню
BOTROW	EQU	12	;Нижній рядок меню
LEFCOL	EQU	26	;Лівий стовпчик меню
ATTRIB	DB	?		; Атрибути екрану
ROW	DB	00		;Рядок екрану		
SHADOW DB 19 DUP(0DBH);
MENU	DB	0C9H, 17 DUP(0CDH), 0BBH

DB	0BAH, ' Print report    ',0BAH 
DB	0BAH, ' Count           ',0BAH 
DB	0BAH, ' Beep            ',0BAH 
DB	0C8H, 17 DUP(0CDH), 0BCH
PROMPT	DB	'To select an item, use <Up/Down Arrow>' 
DB	' and press <Enter>.'
DB	13, 10, 'Press <Esc> to exit.'
.386 ; 	
.CODE

A10MAIN	PROC FAR
MOV AX,@data 
MOV DS,AX 
MOV ES,AX
CALL Q10CLEAR	; Очистка екрану 
MOV ROW,BOTROW+4

A20:
CALL B10MENU	;Вивід меню
MOV   ROW,TOPROW+1	;Вибір верхнього пункту меню
					; у якості початкового значення 
MOV   ATTRIB,16H	;Переключення зображення в інв..
CALL D10DISPLY	;Відображення
 
CALL C10INPUT		;Вибір з меню 
JMP	A20	;
A10MAIN	ENDP

; 	
; Вивід рамки, меню і запрошення…
;	 
B10MENU PROC NEAR
PUSHA	;
MOV   AX,1301H	;
MOV   BX,0060H	;
LEA	BP,SHADOW		; 
MOV   CX,19	;
MOV   DH,TOPROW+1		; 
MOV   DL,LEFCOL+1	;
B20:	
INT	10H
;;;;;
INC	DH	;Наступний рядок 
CMP   DH,BOTROW+2	;
JNE   B20	; 
MOV   ATTRIB,71H	;
MOV   AX,1300H	;
MOVZX BX,ATTRIB	;
LEA	BP,MENU	; 
MOV CX,19
MOV   DH,TOPROW	;Рядок
MOV   DL,LEFCOL	;Стовпчик
 
B30:
 


INT	10H
ADD   BP,19	;
INC	DH	;
CMP   DH,BOTROW+1	; 
JNE   B30	;
MOV   AX,1301H	;
MOVZX BX,ATTRIB	;
LEA	BP,PROMPT		; 
MOV   CX,79	;
MOV   DH,BOTROW+4	; 
MOV   DL,00	;
INT	10H
POPA	;‚
RET
 

B10MENU ENDP
; 	
; Натискування клавиш, управління через клавиші і ENTER
; для вибору пункту меню і клавіші ESC для виходу
;		 
C10INPUT PROC	NEAR
PUSHA	;
C20:	

MOV	AH,10H	;Запитати один символ з кл.
INT	16H	;
CMP		AH,50H	;Стрілка до низу 
JE	C40
CMP		AH,48H	;Стрілка до гори ? 
JE	C30
CMP		AL,0DH	;Натистнено ENTER? 
JE	C90
CMP		AL,1BH		;Натиснено ESCAPE? 
JE	C80	; Вихід
JMP	C20	;Жодна не натиснена, повторення
 
C40:

; Перевіка, чи не на крайній опції ми знаходимось
mov al, [current_option]

; Оновлення активного рядка
inc al
mov [current_option], al

mov ATTRIB,71h
call D10DISPLY
inc ROW
CMP ROW,BOTROW-1
jbe C50
mov ROW,TOPROW+1
jmp C50

C30:

; Перевіка, чи не на крайній опції ми знаходимось
mov al, [current_option]

; Оновлення активного рядка
dec al
mov [current_option], al
mov ATTRIB,71h
call D10DISPLY
dec ROW
CMP ROW,TOPROW+1
jae C50
mov ROW,BOTROW-1



C50:

MOV ATTRIB,17H
CALL D10DISPLY
JMP C20

C90:
CALL taskchooser	; Виклик процедури для виклику процедур
JMP C20

C80:

mov ah, 4ch
mov al, 0
int 21h

POPA
RET

C10INPUT ENDP
; 	
; Забарвлення виділеного рядка
;		 
D10DISPLY PROC	NEAR
PUSHA
MOVZX AX,ROW 
SUB	AX,TOPROW 
IMUL		AX,19
LEA	SI,MENU+1 
ADD		SI,AX
MOV	AX,1300H 
MOVZX BX,ATTRIB 
MOV	BP,SI
MOV	CX,17 
MOV	DH,ROW
MOV		DL,LEFCOL+1 
INT	10H
POPA 
RET
D10DISPLY ENDP
; 	
; Очищення екрану
;		 
Q10CLEAR PROC	NEAR
PUSHA
MOV		AX,0600H 
MOV		BH,61H 
MOV		CX,00 
MOV		DX,184FH 
INT	10H
POPA 
RET
Q10CLEAR ENDP

taskchooser PROC 
		PUSHA
		; Перевірка активної опції
		mov al, [current_option]
		cmp al, 1
		je task_1
		cmp al, 2
		je task_2
		cmp al, 3
		je task_3

		; Перша опція
		task_1:
		lea bp, [creators_message]
		M_write_results 
		jmp task_chooser_end

		; Друга опція
		task_2:
		call ZVUK
		jmp task_chooser_end

		; Третя опція
		task_3:
		call calc
		jmp task_chooser_end

		task_chooser_end:
		POPA
		RET
		taskchooser ENDP
		
calc PROC 

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
calc ENDP    ;кінець процедури

ZVUK PROC

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
ZVUK ENDP

END	A10MAIN