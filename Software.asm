asect 0

main:
	ldi r2,3	
	ld r2,r1
	while # ждём нажатия кнопки
		tst r1
	stays mi
		ld r2,r1
	wend
	ld r1,r0
	if # проверяем, не занята ли клетка
		tst r0
	is nz
		br main
	fi
	ldi r0,2
	st r1,r0 # сохраняем крестик по адресу нажатой клетки
	cmp r1,r1
	shla r1 # формируем запрос о том, что крестик нажат
	shla r1 # по присланному адресу
	add r0,r1
	st r2,r1 # отправляем запрос
	jsr check_game_state
	tst r0
	bnz end_game # если результат ненулевой, значит игра закончилась 
	jsr computer_turn
	ldi r1,1
	st r0,r1 # сохраняем нолик по адресу в память
	cmp r0,r0
	shla r0
	shla r0
	add r0,r1
	st r2,r1 # отправляем запрос 
	jsr check_game_state
	tst r0
	bnz end_game # если результат ненулевой, значит игра закончилась 
	br main
end_game:
	ldi r1,3
	shr r0
	shr r0
	shr r0
	ldi r2, # 60 единицы в 2-5 битах - специальное значение для LLL
	or r2,r0
	st r1,r0 # отправляем запрос
	halt
computer_turn:
	push r1
	push r2
	push r3
	ldi r1,7
	ld r1,r0 # считываем данные с адреса 7
	br end_func
check_game_state:
	push r1
	push r2
	push r3
	ldi r1,3
	ld r1,r0
	shra r0 # оставляем только информацию о состоянии доски
	shra r0
	shra r0
	shra r0
	and r1,r0 
	br end_func
end_func:
	pop r3
	pop r2
	pop r1
	rts
end 