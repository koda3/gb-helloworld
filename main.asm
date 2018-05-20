SECTION "ROM0", ROM0[$150]
main:
	ld	a, %11100100
	ld	[$FF47], a

	ld	a, $00
	ld	[$FF42], a ; スクロールX座標
	ld	[$FF43], a ; スクロールY座標

	call	load_tiles
	call	clear_lcd

	call	lcd_off
	ld	a, 30
	ld	[$FE00], a
	ld	a, 30
	ld	[$FE01], a
	ld	a, 01
	ld	[$FE02], a
	ld	a, 0
	ld	[$FE03], a

	ld	a, 38
	ld	[$FE04], a
	ld	a, 30
	ld	[$FE05], a
	ld	a, 02
	ld	[$FE06], a
	ld	a, 0
	ld	[$FE07], a

	ld	a, 46
	ld	[$FE08], a
	ld	a, 30
	ld	[$FE09], a
	ld	a, 03
	ld	[$FE0A], a
	ld	a, 0
	ld	[$FE0B], a

	ld	a, 30
	ld	[$FE0C], a
	ld	a, 20
	ld	[$FE0D], a
	ld	a, 13
	ld	[$FE0E], a
	ld	a, 0
	ld	[$FE0F], a

	call	lcd_on

; 無限ループ
loop:
	nop
	; P14をHIGHにして、P15をLOWにする
	ld	a, %00100000
	ld	[$FF00], a

	ld	a, [$FF00]
	ld	a, [$FF00]
	ld	a, [$FF00]
	ld	a, [$FF00]
	ld	b, a

	ld	a, b
	and	a, %00001000
	jr	z, .shita_botan
	ld	a, b
	and	%00000100
	jr	z, .ue_botan
	jr	loop
.shita_botan:
	ld	a, [$FE0C]
	cp	134
	jp	z, .end_loop
	ld	a, [$FE0C]
	add	a, 8
	ld	[$FE0C], a
	jr	.end_loop
.ue_botan:
	ld	a, [$FE0C]
	cp	30
	jp	z, .end_loop
	ld	a, [$FE0C]
	sub	a, 8
	ld	[$FE0C], a
	jr	.end_loop
.end_loop:
	call	timer
	jr	loop
