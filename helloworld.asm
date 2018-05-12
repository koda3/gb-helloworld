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

INCLUDE "main.asm"
INCLUDE "procs.asm"
INCLUDE "tiles.asm"