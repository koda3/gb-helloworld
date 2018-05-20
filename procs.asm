timer:
	ld	de, $7FFF
.loop
	dec	de
	ld	a, d
	or	e
	jr	nz, .loop
	ret

load_tiles:
	call	lcd_off
	ld	bc, 16*32
	ld	de, $4000
	ld	hl, $8000
	call	memcpy
	ret

clear_lcd:
	ld 	hl, $9800
	ld	de, 32*32
.loop:
	ld	a, 0
	ld	[hl], a
	dec	de
	ld	a, d
	or	e
	ret	z
	inc	hl
	jp	.loop

lcd_off:
	; LCDがオフなら抜ける
	ld	a, [$FF44]	; LCDC Y座標
	rlca
	ret	nc
.wait_vblank
	; LCDが書き込み終わるまでループします
	ld	a, [$FF44]	; LCDC Y座標
	cp	$91
	jr	nz, .wait_vblank

	; LCDをオフにします
	ld	a, [$FF40]	; LCD制御
	res	$07, a		; ７ビット目をリセット(０にされる)
	ld	[$FF40], a
	ret

lcd_on:
	ld	a, %10010011
	ld	[$FF40], a
	ret

memcpy: 
	; bc コピーサイズ
	; de コピー元のメモリポインター
	; hl コピー先のメモリポインター
.loop:
	ld	a, [de]
	ld	[hl], a
	inc	de
	inc 	hl
	dec	bc
	ld	a, b
	or	c
	jp	nz, .loop
	ret