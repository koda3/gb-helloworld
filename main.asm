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
	ld	a, 11
	ld	[$FE02], a ; 矢印
	ld	a, 0
	ld	[$FE03], a

	call	lcd_on
	ld	a, 01
	ld	[sentaku], a ; 選択したタイル
.loop:
	call	wait_vblank

	; 方向キー
	call	get_dpad
	ld	a, b
	and	%00000100
	jr	z, .ue_botan
	ld	a, b
	and	a, %00001000
	jr	z, .shita_botan

	; ボタン
	call	get_btn
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
	ld	a, [sentaku]
	dec	a
	ld	[sentaku], a
	jr	.end_loop
.shita_botan:
	ld	a, [$FE00]
	cp	16+8*5
	jp	z, .end_loop
	ld	a, [$FE00]
	add	a, 8
	ld	[$FE00], a
	ld	a, [sentaku]
	inc	a
	ld	[sentaku], a
	jr	.end_loop
.a_botan:
	jp	hyouji_gamen
.end_loop:
	call	timer
	jr	.loop
	ret

hyouji_gamen:
	; 呼ぶ前に表示するタイルはcに保存された
	call	lcd_reset
	ld	a, [sentaku]
	ld	[$9803+32*1], a ; 背景マップ
	call	lcd_on
.loop:
	call	wait_vblank

	call	get_btn
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
	halt
