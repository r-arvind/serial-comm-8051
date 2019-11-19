;R7 - lower order start addr
;R6 - higher order start addr
;32h - lower order end addr
;33h - higher order end addr
;34h - baud rate (must do FF-@34h)
;35h - lower order result
;36h - higher order result
;37h - R3 + 5
;R1 - checksum
;R2 - ihex line counter (byte number for that ihex line)
;R3 - line length
;R4 - no of ihex lines with data length = 255
;R5 - length of last possibly non-255 length line
org 0000h
ljmp main
org 0023h
ljmp serial

main:		mov tmod, #20h ;timer1 mode 2
		mov r0, #30h
		mov 34h, #0fdh
		mov th1, 34h
		mov scon, #50h
		mov ie, #90h
		mov R1, #00h ;checksum
		mov R2, #00h ;ihex line counter
		setb tr1
		;setb ri
		back:
		sjmp back

serial:		jb ti, trans
		;mov A, sbuf
		;cjne A, #3ah, endcondn
		;endcondn: end
		;mov R2, #00h
		cond1:	cjne R2, #00h, cond2
			;mov A, sbuf
			;cjne A, #0ffh, continue
			;execute code
			;end
			sjmp exit
		cond2:	cjne R2, #01h, cond3
			mov R3, sbuf ;no of bytes
			mov A, R1
			add A, R3
			mov R1, A
			sjmp exit
		cond3:	cjne R2, #02h, cond4
			mov R6, sbuf
			mov dph, R6
			mov A, R1
			add A, dph
			mov R1, A
			mov a, r6
			mov @r0, a
			inc r0
			sjmp exit
		cond4:	cjne R2, #03h, cond5
			mov R7, sbuf
			mov dpl, R7
			mov A, R1
			add A, dpl
			mov R1, A
			mov a, R7
			mov @R0, A
			inc R0
			sjmp exit
		cond5:	cjne R2, #04h, cond6
			mov A, sbuf
			sub_cond1:	cjne A, #01h, sub_cond2
					mov 60h,31h
					mov 61h,30h
					lcall 020bh
					mov 60h, #60h
					lcall 019bh
					sjmp displll
			sub_cond2:	mov A, R1
					add A, sbuf
					mov R1, A
					sjmp exit
		cond6:	;mov A, R2
			;clr c
			;subb A, R3
			;cjne A, #05h, cond7 ;if(R2-R3==5)
			cjne R3, #00h, cond7
				;checksum check
				mov A, R1
				cpl A
				add A, #01h
				mov R1, A
				mov R2, #0ffh
				mov R1, #00h
				clr c
				subb A, sbuf
				cjne A, #00h, invalid
				;valid
					sjmp exit
				invalid:	mov dph, R6
						mov dpl, R7
						sjmp exit
		cond7:	mov A, sbuf
			;movx @dptr, A
			lcall 18adh
			mov A, R1
			add A, sbuf
			mov R1, A
			inc dptr
			dec R3
		exit:	inc R2
			clr c
			clr ri
			reti
		trans:	clr ti
			reti
		displll:
			LCALL 02a2h
			cjne a, #1fh, displll
			mov dptr, #0ddddh
			mov a, #02h
			lcall 18adh
			movx @dptr, a
			inc dptr
			mov a, 30h
			lcall 18adh
			movx @dptr, a
			inc dptr
			mov a, 31h
			lcall 18adh
			movx @dptr, a
			ljmp 0ddddh