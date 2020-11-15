asect 0

main:
	ldi r2,3	
	ld r2,r1
	while # waiting for the button to be pressed
		tst r1
	stays mi
		ld r2,r1
	wend
	ld r1,r0
	if # check if the cell is busy
		tst r0
	is nz
		br main
	fi
	ldi r0,2
	st r1,r0 # save the cross at the address of the pressed cell
	cmp r1,r1
	shla r1 # we form a request that the cross is pressed
	shla r1 # at the sent address
	add r0,r1
	st r2,r1 # send a request
	jsr check_game_state
	tst r0
	bnz end_game # if the result is nonzero, then the game is over
	jsr computer_turn
	ldi r1,1
	st r0,r1 # save zero to address in memory
	cmp r0,r0
	shla r0
	shla r0
	add r0,r1
	st r2,r1 # send a request
	jsr check_game_state
	tst r0
	bnz end_game # if the result is nonzero, then the game is over
	br main
end_game:
	ldi r1,3
	shr r0
	shr r0
	shr r0
	ldi r2, # 60 ones in 2-5 bits - special value for LLL
	or r2,r0
	st r1,r0 # send a request
	halt
computer_turn:
	push r1
	push r2
	push r3
	ldi r1,7
	ld r1,r0 # read data from address 7
	br end_func
check_game_state:
	push r1
	push r2
	push r3
	ldi r1,3
	ld r1,r0
	shra r0 # leave only information about the state of the board
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
