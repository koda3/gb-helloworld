SECTION "ROM0", ROM0[$150]
	nop
	di
	ld	sp, $FFFF
main:
	ld	a, %11100100
	ld	[$FF47], a
	ld	[$FF48], a

	ld	a, $00
	ld	[$FF42], a ; スクロールX座標
	ld	[$FF43], a ; スクロールY座標

	call	lcd_off
	call	clear_vram
	call	clear_oam

	; タイルを読み込む
	ld	bc, 16*16
	ld	de, Tiles
	ld	hl, $8000
	call	memcpy

	ld	a, 01
	ld	[$9803+32*1], a
	ld	a, 02
	ld	[$9803+32*2], a
	ld	a, 03
	ld	[$9803+32*3], a
	ld	a, 04
	ld	[$9803+32*4], a
	ld	a, 05
	ld	[$9803+32*5], a
	ld	a, 16+8
	ld	[$FE00], a
	ld	a, 8+16
	ld	[$FE01], a
	ld	a, 13
	ld	[$FE02], a
	ld	a, 0
	ld	[$FE03], a

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

.wait_vblank
	; LCDが書き込み終わるまでループします
	ld	a, [$FF44]	; LCDC Y座標
	cp	$91
	jr	nz, .wait_vblank

	ld	a, b
	and	%00000100
	jr	z, .ue_botan
	ld	a, b
	and	a, %00001000
	jr	z, .shita_botan
	jr	loop
.ue_botan:
	ld	a, [$FE00]
	cp	16+8*1
	jp	z, .end_loop
	ld	a, [$FE00]
	sub	a, 8
	ld	[$FE00], a
	jr	.end_loop
.shita_botan:
	ld	a, [$FE00]
	cp	16+8*5
	jp	z, .end_loop
	ld	a, [$FE00]
	add	a, 8
	ld	[$FE00], a
	jr	.end_loop
.end_loop:
	call	timer
	jr	loop
