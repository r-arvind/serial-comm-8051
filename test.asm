displll:
LCALL 02a2h
cjne a, #1fh, displll
mov dptr, #0ddddh
lcall 18adh
mov a, #02h
movx @dptr, a
inc dptr
mov a, 30h
lcall 18adh
movx @dptr, a
inc dptr
mov a, 31h
lcall 18adh
movx @dptr, a

