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
; Дата:         _10_/_05_/_2021_
;----------------I.ЗАГОЛОВОК ПРОГРАМИ------------------------
IDEAL
MODEL SMALL
STACK 1024
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
        		db  3, 3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3
				db  3, 3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3
				db  3, 3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3
				db  3, 3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3
				db  3, 3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3
				db  3, 3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3
				db  3, 3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3
				db  3, 3 ,3 ,3 ,3 ,3 ,3 ,3 ,0 ,5 ,0 ,9 ,2 ,0 ,0 ,2
				db  3, 3 ,3 ,3 ,3 ,3 ,3 ,3 ,1 ,8 ,0 ,3 ,2 ,0 ,0 ,3
				db  3, 3 ,3 ,3 ,3 ,3 ,3 ,3 ,0 ,4 ,0 ,3 ,2 ,0 ,0 ,3
				db  3, 3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3
				db  3, 3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3
				db  3, 3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3
				db  3, 3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3
				db  3, 3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3 ,3
				
exCode db 0
CODESEG

Start:
	M_Init
	
	mov cx,256  ;запис 256 до cx
	mov si,0	;запис 0 до si
		

sort:
push cx 	;занесення значення сх до стеку

nosort:
	mov ah,[ds:si]		;занесення значення до ah
	mov al,[ds:si+1]	;занесення значення до al
	
	cmp ah,al	;порівняння ah до al
	jg ns		;якщо al > ah, то перейти
	
	ns:
	inc si 		;si+1
	loop nosort
	
	mov [ds:si], al 	;зміна
	mov [ds:si+1], ah	;зміна
	
	mov si,0	;запис 0 до si
	pop cx		;дістаємо cx зі стеку
	loop sort
	
	
Exit:
     mov ah,4ch
     mov al,[exCode]; отримання коду виходу 
     int 21h		; виклик функції DOS 4ch
    end Start