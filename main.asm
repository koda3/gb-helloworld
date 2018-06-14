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

	jp	loop

sentaku_gamen:
	call	lcd_reset
	; タイルとスプライトを表示
	ld	a, 01
	ld	[$9803+32*1], a ; あ
	ld	a, 02
	ld	[$9803+32*2], a ; い
	ld	a, 03
	ld	[$9803+32*3], a ; う
	ld	a, 04
	ld	[$9803+32*4], a ; え
	ld	a, 05
	ld	[$9803+32*5], a ; お

	; 矢印スプライト
	ld	a, 16+8
	ld	[$FE00], a
	ld	a, 8+16
	ld	[$FE01], a
	ld	a, 13
	ld	[$FE02], a ; 矢印
	ld	a, 0
	ld	[$FE03], a

	call	lcd_on
	ld	bc, 1
	push	bc ; 選択したタイル
.loop:
	; P14をHIGHにして、P15をLOWにする
	ld	a, %00100000
	ld	[$FF00], a

	; コントローラ読み込み
	ld	a, [$FF00]
	ld	a, [$FF00]
	ld	a, [$FF00]
	ld	a, [$FF00]
	ld	b, a
	call	wait_vblank

	; 方向キー
	ld	a, b
	and	%00000100
	jr	z, .ue_botan
	ld	a, b
	and	a, %00001000
	jr	z, .shita_botan

	; A・B・スタート・セレクトボタン
	ld	a, %00010000
	ld	[$FF00], a

	ld	a, [$FF00]
	ld	a, [$FF00]
	ld	a, [$FF00]
	ld	a, [$FF00]
	ld	b, a
	call	wait_vblank

	ld	a, b
	and	%00000001
	jr	z, .a_botan

	jr	.loop
.ue_botan:
	ld	a, [$FE00]
	cp	16+8*1
	jp	z, .end_loop
	ld	a, [$FE00]
	sub	a, 8
	ld	[$FE00], a
	pop	bc
	dec	bc
	push	bc
	jr	.end_loop
.shita_botan:
	ld	a, [$FE00]
	cp	16+8*5
	jp	z, .end_loop
	ld	a, [$FE00]
	add	a, 8
	ld	[$FE00], a
	pop	bc
	inc	bc
	push	bc
	jr	.end_loop
.a_botan:
	pop	bc
	jp	hyouji_gamen
.end_loop:
	call	timer
	jr	.loop
	ret

hyouji_gamen:
	; 呼ぶ前に表示するタイルはcに保存された
	push	bc
	call	lcd_reset
	pop	bc
	ld	a, c
	ld	[$9803+32*1], a ; 背景マップ
	call	lcd_on
.loop:
	; A・B・スタート・セレクトボタン
	ld	a, %00010000
	ld	[$FF00], a

	ld	a, [$FF00]
	ld	a, [$FF00]
	ld	a, [$FF00]
	ld	a, [$FF00]
	ld	b, a
	call	wait_vblank

	ld	a, b
	and	%00000010
	jr	z, .b_botan

	jr	.loop
.b_botan:
	jp	sentaku_gamen
.end_loop:
	call	timer
	jr	.loop
	ret

loop:
	jp	sentaku_gamen
	call	timer
	call	timer
	ld	bc, 01
	call	hyouji_gamen
	halt
