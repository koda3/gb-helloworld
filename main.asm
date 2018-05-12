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
	ld	a, 11
	ld	[$FE02], a
	ld	a, 0
	ld	[$FE03], a
	call	lcd_on

; 無限ループ
loop:
	nop
	call	lcd_on
	call	timer
	call	lcd_off
	ld	a, [$FE02]
	cp	11
	jp	z, .change
	ld	a, 11
	ld	[$FE02], a
	jp	loop
.change
	ld	a, 12
	ld	[$FE02], a
	jp	loop