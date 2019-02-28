		AREA text, CODE
		
		EXPORT 	scan2
		EXPORT	print_decimal
			
		; ENTRY: Takes char in r0
		; Conforms to APCS
		; Call SYS_wrITEC, with r1 containing a POINTER To a character
		
		; SYS_WRITEC = 3, SYS_WRITE0 = 4, SYS_READC = 7
		
scan2
		stmfd	sp!, {lr}			;save registers(link register)
		bl		scan
		sub		r0, r0, #'0'
		mov 	r1, r0, lsl #3	;
		add		r1, r1, r0, lsl #1	; r1 <= r0*8 + r0*2 = r0 * 10
		bl		scan
		sub 	r0, r0, #'0'
		add		r1, r1, r0		; r1 <= r3 + r0	
		swi		0x123456
		ldmfd	sp!, {pc}

scan
		stmfd	sp!, {lr}
		mov		r0, #7
		swi		0x123456
		ldmfd	sp!, {pc}
		


print_char
		stmfd	sp!, {r0, lr}
		adr		r1, char
		strb	r0, [r1]
		mov		r0, #3
		swi		0x123456
		ldmfd	sp!, {r0, pc}
		
print_decimal				
        stmfd   sp!, {r4,r5,lr}

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
        ldmfd   sp!, {r4,r5,lr}
        mov     r0, #'\n'
        b      print_char		

		
char	DCB		0

		END
		
		