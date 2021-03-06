		AREA text, CODE
		
		EXPORT	print_decimal
		EXPORT	print_line
			
		; ENTRY: Takes char in r0
		; Conforms to APCS
		; Call SYS_wrITEC, with r1 containing a POINTER To a character
		
		; SYS_WRITEC = 3, SYS_WRITE0 = 4, SYS_READC = 7
		

print_char
		stmfd	sp!, {r0, lr}
		adr		r1, char
		strb	r0, [r1]
		mov		r0, #3
		swi		0x123456
		ldmfd	sp!, {r0, pc}

print_line
		stmfd	sp!, {r0-r4, lr}
		mov		r4,r3
		ldr		r1, =0x55555556	;r1 = 2^32 / 3
		umull	r2, r3, r4, r1	;r3 = r0 / 3
		sub		r2, r4, r3, lsl #1
		sub		r2, r2, r3		;r2 = r0 % 3
		cmp		r2, #1			;if r2 is 3n+1
		mov		r0, #'\n'		;print new line
		bleq	print_char
		swi		0x123456
		ldmfd	sp!, {r0-r4, pc}
				
print_decimal				
        stmfd   sp!, {r1-r5,lr}

        cmp     r0, #0				; if r0 == 0
        moveq   r0, #'0'
        bleq    print_char
        beq     done

        mov     r4, sp
        mov     r5, sp
        sub     sp, sp, #12
        ldr     r1, =0x1999999a     ; r1 = 2^32 / 10

loop
	   	umull   r2, r3, r0, r1      ; r3 = r0 / 10
        sub     r2, r0, r3, lsl #3
        sub     r2, r2, r3, lsl #1  ; r2 = r0 - 10*r3 = r0 % 10

        add     r2, r2, #'0'
        strb    r2, [r4, #-1]!		;store byte into memory[] from r2

        movs    r0, r3				
        bne     loop				;if r0 != 0, loop

write
		ldrb    r0, [r4], #1		;loads r0 with contents of address of r4, r4++
        bl      print_char
        
        cmp     r4, r5
        blt     write
        
        add     sp, sp, #12
done
        mov     r0, #' '
        bl      print_char		
        swi		0x123456
        ldmfd   sp!, {r1-r5,pc}
		
char	DCB		0

		END