 TITLE ЛАБ3
;------------------------------------------------------------------------------
;ЛР  №3
;------------------------------------------------------------------------------
; Програмування 3. Системне програмування
; Завдання:    	Основи розробки і налагодження
; ВУЗ:  		КНУУ "КПІ"
; Факультет:  	ФІОТ
; Курс: 		1
; Група:     	IT-03
; Команда: 		9
;------------------------------------------------------------------------------
; Дата:         _23_/_03_/_2021_
;----------------I.ЗАГОЛОВОК ПРОГРАМИ------------------------
IDEAL
MODEL SMALL
STACK 512
;-----------------------II.МАКРОСИ--------------------------------------
; Складний макрос для ініціалізації
MACRO M_Init		; Початок макросу 
mov	ax, @data	; ax <- @data
mov	ds, ax		; ds <- ax
mov	es, ax		; es <- ax
ENDM M_Init		

;--------------------III.ПОЧАТОК СЕГМЕНТУ ДАНИХ--------------
DATASEG
;Оголошення двовимірного експериментального масиву 16х16
array2Db 	    db  3, 3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3
        		db  3, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,3
         		db  3, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,3
        		db  3, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,3
         		db  3, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,3
         		db  3, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,3
         		db  3, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,3
         		db  3, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,3
         		db  3, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,3
         		db  3, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,3
         		db  3, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,3
         		db  3, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,3
         		db  3, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,3
         		db  3, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,3
         		db  3, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,3
         		db  3, 3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3
        
; Для вирівнювання у дампі
arr_def1 dw  3, 0 , 0 , 0 , 0 , 0 , 0 , 0


exCode 	DB 0
CODESEG
;----------------------VI. ПОЧАТОК СЕГМЕНТУ КОДУ-------------------
Start:	
M_Init
;Способи адресації по Рудакову-Фiногенову----------------------

;Базово-індексна адресація

mov bx, 0h					; Готуємо базовий регістр, пересування по вертикалі
mov si, 0fh					;Готуємо індексний регістр, пересування по горізонт.

mov al, 72					; Записуємо до молодшої частини АХ H
mov [array2Db+si+bx], al	;M(DS*16+ array2Db+SI+BX)
add si, -1					; По Х зсув ліворуч на 1
add bx, 10h					; По У зсув вниз на 1
;--------------------------------------------------------------
mov al, 69					; Записуємо до молодшої частини АХ E
mov [array2Db+si+bx], al	;M(DS*16+ array2Db+SI+BX)
add si, -1
add bx, 10h
;--------------------------------------------------------------
mov al, 76					; Записуємо до молодшої частини АХ L
mov [array2Db+si+bx], al;M(DS*16+ array2Db+SI+BX)
add si, -1
add bx, 10h
;--------------------------------------------------------------
mov al, 76					; Записуємо до молодшої частини АХ L
mov [array2Db+si+bx], al;M(DS*16+ array2Db+SI+BX)
add si, -1
add bx, 10h
;--------------------------------------------------------------
mov al, 79					; Записуємо до молодшої частини АХ O
mov [array2Db+si+bx], al;M(DS*16+ array2Db+SI+BX)
add si, -1
add bx, 10h
;--------------------------------------------------------------
mov al, 33					; Записуємо до молодшої частини АХ !
mov [array2Db+si+bx], al;M(DS*16+ array2Db+SI+BX)
add si, -1
add bx, 10h
;--------------------------------------------------------------
mov al, 70					; Записуємо до молодшої частини АХ F
mov [array2Db+si+bx], al;M(DS*16+ array2Db+SI+BX)
add si, -1
add bx, 10h
;--------------------------------------------------------------
mov al, 86					; Записуємо до молодшої частини АХ V
mov [array2Db+si+bx], al;M(DS*16+ array2Db+SI+BX)
add si, -1
add bx, 10h
;--------------------------------------------------------------
mov al, 80					; Записуємо до молодшої частини АХ P
mov [array2Db+si+bx], al;M(DS*16+ array2Db+SI+BX)
add si, -1
add bx, 10h
;--------------------------------------------------------------
mov al, 68					; Записуємо до молодшої частини АХ D
mov [array2Db+si+bx], al;M(DS*16+ array2Db+SI+BX)
add si, -1
add bx, 10h
;--------------------------------------------------------------
mov al, 68					; Записуємо до молодшої частини АХ D
mov [array2Db+si+bx], al;M(DS*16+ array2Db+SI+BX)
add si, -1
add bx, 10h
;--------------------------------------------------------------
mov al, 69					; Записуємо до молодшої частини АХ E
mov [array2Db+si+bx], al;M(DS*16+ array2Db+SI+BX)
add si, -1
add bx, 10h
;--------------------------------------------------------------
mov al, 75					; Записуємо до молодшої частини АХ K
mov [array2Db+si+bx], al;M(DS*16+ array2Db+SI+BX)
add si, -1
add bx, 10h
;--------------------------------------------------------------
mov al, 77					; Записуємо до молодшої частини АХ M
mov [array2Db+si+bx], al;M(DS*16+ array2Db+SI+BX)
add si, -1
add bx, 10h
;--------------------------------------------------------------
mov al, 77					; Записуємо до молодшої частини АХ M
mov [array2Db+si+bx], al;M(DS*16+ array2Db+SI+BX)
add si, -1
add bx, 10h
;--------------------------------------------------------------
mov al, 2					; Записуємо до молодшої частини АХ (smiley)
mov [array2Db+si+bx], al;M(DS*16+ array2Db+SI+BX)
add si, -1
add bx, 10h

Exit:
	mov ah,4ch
	mov al,[exCode]	; отримання коду виходу 
	int 21h		; виклик функції DOS 4ch
	end Start