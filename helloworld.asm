mov: MACRO
	ld	a, \2
	ld	\1, a
ENDM

SECTION "start",ROM0[$0100]
	nop
	jp	$0150 ; 開始位置

	; $0150までカートリッジヘッダ
	; 任天堂ロゴ
	db	$CE, $ED, $66, $66, $CC, $0D, $00, $0B, $03, $73, $00, $83, $00, $0C, $00, $0D
	db	$00, $08, $11, $1F, $88, $89, $00, $0E, $DC, $CC, $6E, $E6, $DD, $DD, $D9, $99
	db	$BB, $BB, $67, $63, $6E, $0E, $EC, $CC, $DD, $DC, $99, $9F, $BB, $B9, $33, $3E
	db	"HELLOWORLD", $00, $00, $00, $00, $00
	db	$00, $00, $00, $00, $00, $00, $00, $01, $33
	db	$00, $00, $00

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
	ld	a, 1
	ld	[$FE02], a
	ld	a, 0
	ld	[$FE03], a
	call	lcd_on

; 無限ループ
loop:
	halt
	nop
	jp	loop

load_tiles:
	call	lcd_off
	ld	bc, 16*11
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

SECTION "Tiles", ROMX ; $4000
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 空
	db $00, $00, $20, $20, $7C, $7C, $20, $20, $3C, $3C, $6A, $6A, $B2, $B2, $64, $64 ; あ
	db $00, $00, $00, $00, $88, $88, $84, $84, $82, $82, $82, $82, $50, $50, $20, $20 ; い
	db $00, $00, $3C, $3C, $00, $00, $3C, $3C, $42, $42, $02, $02, $04, $04, $38, $38 ; う
	db $00, $00, $3C, $3C, $00, $00, $7C, $7C, $08, $08, $18, $18, $28, $28, $46, $46 ; え
	db $00, $00, $20, $20, $F4, $F4, $22, $22, $3C, $3C, $62, $62, $A2, $A2, $6C, $6C ; お
	db $00, $00, $00, $00, $3C, $3C, $00, $00, $00, $00, $20, $20, $40, $40, $3E, $3E ; こ
	db $00, $00, $2A, $2A, $F0, $F0, $2E, $2E, $40, $40, $48, $48, $50, $50, $8E, $8E ; だ
	db $00, $00, $0A, $0A, $20, $20, $50, $50, $88, $88, $06, $06, $00, $00, $00, $00 ; べ
	db $00, $00, $0E, $0E, $74, $74, $0A, $0A, $10, $10, $10, $10, $08, $08, $06, $06 ; で
	db $00, $00, $08, $08, $FE, $FE, $18, $18, $28, $28, $18, $18, $08, $08, $10, $10 ; す

aiueo_screen:
	db	$01, $02, $03, $04, $05, $00, $09, $0A ; あいうえお　です
