SECTION "start",ROM0[$0100]
	nop
	jp 		$0150 ; 開始位置

	; $0150までカートリッジヘッダ
	; 任天堂ロゴ
	db 		$CE, $ED, $66, $66, $CC, $0D, $00, $0B, $03, $73, $00, $83, $00, $0C, $00, $0D
	db 		$00, $08, $11, $1F, $88, $89, $00, $0E, $DC, $CC, $6E, $E6, $DD, $DD, $D9, $99
	db 		$BB, $BB, $67, $63, $6E, $0E, $EC, $CC, $DD, $DC, $99, $9F, $BB, $B9, $33, $3E
	db 		"HELLOWORLD", $00, $00, $00, $00, $00
	db 		$00, $00, $00, $00, $00, $00, $00, $01, $33
	db 		$00, $00, $00

SECTION "ROM0", ROM0[$150]
main:
	ld 		a, %11100100
	ld 		[$FF47], a

	ld 		a, $00
	ld 		[$FF42], a ; スクロールX座標
	ld 		[$FF43], a ; スクロールY座標

	call 	load_tiles
	call 	clear_lcd
	ld 		bc, 0
.loop_1:
	inc 	bc
	ld 		hl, $9800
	add 	hl, bc
	ld 		[hl], c

	ld 		a, c
	sub 	5
	jp 		nz, .loop_1

	ld 		a, %10010001
	ld 		[$FF40], a

; 無限ループ
loop:
	halt
	nop
	jr 		loop

load_tiles:
	call 	lcd_off
	ld 		hl, $4000
	ld 		de, $8000
	ld 		b, 16*6
.loop:
	ld 		a, [hl]
	ld 		[de], a
	dec 	b
	ret 	z
	inc 	hl
	inc 	de
	jr 		.loop

clear_lcd:
	ld 		de, 32*32
.loop:
	ld 		a, 0
	ld 		[hl], a
	dec 	de
	ld 		a, d
	or 		e
	ret		z
	inc 	hl
	jp 		.loop

lcd_off:
	; LCDがオフなら抜ける
	ld 		a, [$FF44] ; LCDC Y座標
	rlca
	ret 	nc
.wait_vblank
	; LCDが書き込み終わるまでループします
	ld 		a, [$FF44] ; LCDC Y座標
	cp 		$91
	jr 		nz, .wait_vblank

	; LCDをオフにします
	ld 		a, [$FF40] ; LCD制御
	res 	$07, a     ; ７ビット目をリセット(０にされる)
	ld 		[$FF40], a
	ret

SECTION "Tiles", ROMX ; $8000
db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 空
db $00, $00, $20, $20, $7C, $7C, $20, $20, $3C, $3C, $6A, $6A, $B2, $B2, $64, $64 ; あ
db $00, $00, $00, $00, $88, $88, $84, $84, $82, $82, $82, $82, $50, $50, $20, $20 ; い
db $00, $00, $3C, $3C, $00, $00, $3C, $3C, $42, $42, $02, $02, $04, $04, $38, $38 ; う
db $00, $00, $3C, $3C, $00, $00, $7C, $7C, $08, $08, $18, $18, $28, $28, $46, $46 ; え
db $00, $00, $20, $20, $F4, $F4, $22, $22, $3C, $3C, $62, $62, $A2, $A2, $6C, $6C ; お