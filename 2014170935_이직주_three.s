		AREA	text, CODE
		; This section is called "text", and contains code
		ENTRY
		
		IMPORT 	print_decimal
		IMPORT	print_star
		
start
		mov		r4, #1			;r4<=1
		
loop	
		ldr		r1, =0x55555556	;r1 = 2^32 / 3
		umull	r2, r3, r4, r1	;r3 = r4 / 3
		sub		r2, r4, r3, lsl #1
		sub		r2, r2, r3		;r2 = r4 % 3
		
		cmp		r2, #0			;if r4 is 3n
		mov		r0, r4		
		bleq	print_star		;print *		
		blne	print_decimal	;else print r0
		
		add		r4, r4, #1
		cmp		r4, #100
		bls		loop			;until r4 <= 100
		
finish
		mov		r0, #0x18
		mov		r1, #0x20000	; build the "difficult" number...
		add		r1, r1, #0x26	; ...in two steps
		SWI		0x123456		;; "software interrupt"
		
		END