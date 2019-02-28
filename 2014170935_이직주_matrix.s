		AREA	text, CODE
		; This section is called "text", and contains code
		ENTRY
		
		IMPORT	print_line
		IMPORT 	print_decimal
		
start
		LDR		r1, =array1		; r1=pointer to array1
		LDR		r2, =array2		; r2=pointer to array2	
		mov		r3, #9			; r3 = array length		
		
ADD								;; array1 + array2
		LDR		r4, [r1], #4 	; load numbers from the array1
		LDR		r5, [r2], #4	; load numbers from the array2
		add		r0, r4, r5		; r0 = array1[i] + array2[i]
		bl		print_decimal	; print r0
		bl		print_line		; if r3 is 3n+1, print new line		
		subs	r3,r3,#1		; length--
		bne		ADD				; print more

start2
		mov		r3, #9			; length is 9
		
MUL								;; array1 X array2
		rsb		r8, r3, #9		; r8 = 9 - r3
		LDR		r1, =array1		; r1=pointer to array1
		LDR		r2, =array2		; r2=pointer to array2	
		mov		r0 , #0			; x <= 0
		ldr		r4, =0x55555556	; r4 = 2^32 / 3
		
		umull	r5, r6, r8, r4	; r6 = r8 / 3
		sub		r5, r8, r6, lsl #1
		sub		r5, r5, r6		; r5 <= j = r8 % 3
		
		
		mov		r4, r6, lsl #2	; r6 <= r6*4 + r6*8
		add		r6, r4, r6, lsl #3	; = r6 * 12
		add		r1, r1, r6		; r1 <= [i]
		
		mov		r5, r5, lsl #2	; r5 <= r5 * 4
		add		r2, r2, r5		; r2 <= [j]
		mov		r7, #3			; r7 <= k = 3		
loop
		LDR		r4,[r1], #4		; aik
		LDR		r5,[r2], #12	; bkj		
		mul		r6,r4,r5		; r6 <= aik*bkj
		add		r0, r0, r6		; x <= x + r6
		subs	r7,r7,#1		; k--
		bne		loop
		
		bl		print_decimal	; print r0
		bl		print_line		; if r3 is 3n+1, print new line		
		subs	r3,r3,#1		; length--
		bne		MUL				; print more
		
finish
		mov		r0, #0x18
		mov		r1, #0x20000	; build the "difficult" number...
		add		r1, r1, #0x26	; ...in two steps
		SWI		0x123456		;; "software interrupt"
		
 		AREA BlockData, DATA, READWRITE
array1 	DCD 	1,2,3,4,5,6,7,8,9
array2 	DCD		1,0,0,0,1,0,0,0,1
		END