		AREA	text, CODE
		; This section is called "text", and contains code
		ENTRY
		
		IMPORT	scan2
		IMPORT 	print_decimal
		
start
		bl		scan2			;get ten seat input ex) 12
		mov		r3, r1		
		bl		scan2			; 34
		mov		r4, r1
		mul		r0, r4, r3
								; 12 * 34 = 0x198
		bl		print_decimal
		
finish
		mov		r0, #0x18
		mov		r1, #0x20000	; build the "difficult" number...
		add		r1, r1, #0x26	; ...in two steps
		SWI		0x123456		;; "software interrupt"
		
		END