timer:
	ld	de, $7FFF
.loop
	dec	de
	ld	a, d
	or	e
	jr	nz, .loop
	ret

clear_vram:
	ld	bc, 8192
	ld 	de, $9800
	call	zero
	ret

clear_oam:
	ld	bc, 4*40
	ld 	de, $FE00
	call	zero
	ret

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

wait_vblank
	; LCDが書き込み終わるまでループします
	ld	a, [$FF44]	; LCDC Y座標
	cp	$91
	jr	nz, wait_vblank
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

zero:
	; bc サイズ
	; de コピー先のメモリポインター
.loop:
	ld	a, 0
	ld	[de], a
	inc	de
	dec	bc
	ld	a, b
	or	c
	jp	nz, .loop
	ret
