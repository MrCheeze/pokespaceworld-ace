.MEMORYMAP
SLOTSIZE $10000
DEFAULTSLOT 0
SLOT 0 $0
.ENDME

.ROMBANKSIZE $10000
.ROMBANKS 2

.BANK 0 SLOT 0

.define DelayFrame $0317
;.define DelayFrameNoAInit $0319
;.define DelayFrames $0324
.define DelayFramesButtonSound $08E7
.define UpdateAndTransferToolgear $2C4F
;.define DelayFrameUpdateAndTransferToolgear $2C5A
.define ByteFill $32FD
.define ClearTileMap $0e2a
.define Random $3234
.define ClearSprites $32A0

.org $CB00 ; temp address
	ld de,$D9D9
joypadLoop:
	adc h ; useless instructions jr operand will be a valid character
	adc h
	adc h
	inc c
	call DelayFramesButtonSound
	ld a,($FF9F) ; joypad
	ld b,a
	inc c
	cp $4E ; dummy, for mail newline
	call DelayFramesButtonSound
	ld a,($FF9F) ; joypad
	add b
	ld (de),a
	inc de
	jr nc,joypadLoop
	jp $D9D9
	
getJoypad:

.org $D9D9
	ld hl,$C006
	ld (hl),musicChannel1 # $100
	inc hl
	ld (hl),musicChannel1 / $100
	ld b,b
	nop
	ld l,$38
	ld (hl),musicChannel2 # $100
	inc hl
	ld (hl),musicChannel2 / $100
	xor a
	ld ($C015),a
	ld ($C047),a
	ld ($C067),a
	ld ($C099),a
	
	call ClearSprites
	
	infinite:
	ld hl,$C29B
	ld bc,85
	ld a,c
	call ByteFill
	ld c,200
	ld a,$7F
	call ByteFill
	ld c,85
	ld a,c
	call ByteFill
	
	ld hl,$C322
	call Random
	and $03
	inc a
	ld e,a
	drawName:
	nop
	push hl
	push hl
	call drawRandomLine
	call Random
	and $03
	sub $02
	ld c,a
	pop hl
	ld a,l
	add c
	ld l,a
	ld (hl),$7F
	pop hl
	ld c,40
	add hl,bc
	dec e
	jr nz,drawName
	
	ld b,b
	ld b,b
	nop
	ld c,255
	call DelayFramesButtonSound
	
	jr infinite
	
	;pop hl
	;ret
	
drawRandomLine:
	call Random
	or $FC
	sub $02
	ld c,a
	push bc
	ld b,$FF
	add hl,bc
	call drawRandom
	pop bc
	;fall through
	
drawRandom:
	call Random
	nop
	.db $E3
	ld b,b
	and $DF
	or $80
	ld (hli),a
	inc c
	jr nz,drawRandom
	ret

musicChannel1:
	.db $DA,$01,$0F,$E5,$77,$DB,$02,$D8,$0C,$93,$07
musicChannel1Loop:
	.db $D5,$11,$51,$81,$D4,$11,$DB,$00,$DB,$02,$51,$51,$51,$51,$D6,$C1,$D5,$31,$81,$C1,$D4,$31,$31,$31,$31,$D6,$B1,$D5,$31,$81,$B1,$D4,$31,$31,$DB,$00,$DB,$02,$31,$31,$D6,$A1,$D5,$11,$61,$A1,$D4,$11,$11,$11,$11,$D6,$91,$D5,$11,$61,$91,$D4,$11,$11,$11,$11,$D6,$DB,$00,$DB,$02,$81,$D5,$11,$51,$81,$D4,$11,$11,$11,$11,$D6,$71,$A1,$D5,$31,$71,$A1,$A1,$A1,$A1,$D6,$81,$D5,$11,$31,$DB,$00,$DB,$02,$81,$81,$81,$31,$D6,$81,$FD,$E3
	.dw musicChannel1Loop
musicChannel2:
	.db $DB,$02,$D8,$0C,$A3,$D3,$51,$51,$61,$61
musicChannel2Loop:
	.db $81,$81,$81,$81,$61,$DB,$00,$DB,$02,$51,$31,$31,$11,$11,$31,$51,$A1,$81,$81,$81,$81,$81,$81,$81,$61,$51,$31,$31,$11,$11,$11,$11,$11,$DB,$00,$DB,$02,$11,$11,$11,$61,$61,$61,$61,$41,$31,$11,$11,$D4,$B1,$B1,$D3,$11,$31,$51,$61,$61,$61,$31,$31,$31,$DB,$00,$DB,$02,$31,$31,$51,$71,$71,$81,$D4,$81,$D3,$31,$81,$81,$81,$51,$61,$FD,$E3
	.dw musicChannel2Loop
musicEnd:
