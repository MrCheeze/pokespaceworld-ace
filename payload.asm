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
.define LoadGraphics $23AC
.define PlayCry $397E
.define UpdateSprites $17A8
.define PrepareTextbox $3112
.define PrepMonFrontpic $3945
.define GetMonHeader $3A0F
.define GetSGBLayout $3602

.org $CA80 ; temp address
	ld de,$D9D9
joypadLoop:
	adc h ; useless instruction to make jr operand a valid mail character
	inc c
	inc c
	call DelayFramesButtonSound
	ld a,($FF9F) ; joypad
	ld b,a
	inc c
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
	
	ld a,$76
	ld ($D6E5),a
	ld a,2
	ld hl,$D704
	ld c,$0E
	loopPatchStats:
	ld (hli),a
	dec c
	jr nz,loopPatchStats
	
	ld ($D264),a ; skateboarding
	ld a,6
	ld ($D646),a ; load Red graphics
	ld a,$64
	ld ($D6A5),a ; murder the collision
	ld a,$AF
	ld ($D158),a ; nicer palette
	
	ld hl,$FF89
	ld (hl),$C3 ; jp
	inc hl
	ld (hl),everyFrame # $100
	inc hl
	ld (hl),everyFrame / $100
	
	pop hl ; clear up stack
	ret
	
everyFrame:
	ld hl,$D66A
	ld (hl),mapScript # $100
	inc hl
	ld (hl),mapScript / $100
	ret
	
mapScript:
	xor a
	ld ($D264),a ; remove skateboard
	
	ld a,($FF9F) ; check if big tree in top-left
	cp $04 ; selet
	jr z,credits
	cp $42 ; up+B
	jr z,startRedBattle
	cp $41 ; up+a
	ret nz
	
	ld a,$0B
	ld hl,$CEF7
	ld (hli),a
	inc hl
	ld (hl),$0C
	ld l,$FF
	ld (hli),a
	ld l,$07
	ld (hli),a
	ld (hl),a
	ld l,$0F
	ld (hl),$40
	
	ret

startRedBattle:
	
	xor a
	ld ($CEF7),a
	call UpdateSprites
	ld a,93
	call PlayCry
	
	ld a,$03
	ld ($D637),a
	ld a,229
	ld ($C5ED),a
	ld ($CDD7),a
	ld a,100
	ld ($CDBB),a
	ret
	
credits:
	xor a
	ldh ($E8),a ; disable tileset animation
	call PrepareTextbox
	ld hl,$C006
	ld (hl),musicChannel1 # $100
	inc hl
	ld (hl),musicChannel1 / $100
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
	ld hl,$9880
	ld bc,$140
	ld a,$7F
	call ByteFill
	
	ld a,$80
	ldh ($D9),a
	
	infinite:
	ld hl,$C2A0
	ld bc,80
	ld a,85
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
	
	call Random
	ld ($CB5B),a
	ld ($cd78),a
	call GetMonHeader
	ld c,$FF
	call scrollFullway
	ld hl,$C2F0
	ld c,200
	ld a,$7F
	call ByteFill
	ld hl,$C30E
	call drawRandomLine
	ld hl,$C31F
	call PrepMonFrontpic
	ld c,$7F
	call scrollFullway
	
	jr infinite
	
scrollFullway:
	call scrollHalfway
	push bc
	ld b,$12
	call GetSGBLayout
	pop bc
	call DelayFramesButtonSound
scrollHalfway:
	call DelayFrame
	ldh a,($D9)
	add $04
	ldh ($D9),a
	and $7F
	jr nz,scrollHalfway
	ret
	
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
	and $DF
	or $80
	ld (hli),a
	inc c
	jr nz,drawRandom
	ret

musicChannel1:
	.db $DA,$01,$0F,$E5,$77,$DB,$02,$D8,$0C,$93,$07
musicChannel1Loop:
	.db $D5,$11,$51,$81,$D4,$11,$51,$51,$51,$51,$D6,$C1,$D5,$31,$81,$C1,$D4,$31,$31,$31,$31,$D6,$B1,$D5,$31,$81,$B1,$D4,$31,$31,$31,$31,$D6,$A1,$D5,$11,$61,$A1,$D4,$11,$11,$11,$11,$D6,$91,$D5,$11,$61,$91,$D4,$11,$11,$11,$11,$D6,$81,$D5,$11,$51,$81,$D4,$11,$11,$11,$11,$D6,$71,$A1,$D5,$31,$71,$A1,$A1,$A1,$A1,$D6,$81,$D5,$11,$31,$81,$81,$81,$31,$D6,$81,$FD,$00
	.dw musicChannel1Loop
musicChannel2:
	.db $DB,$02,$D8,$0C,$A3,$D3,$51,$51,$61,$61
musicChannel2Loop:
	.db $81,$81,$81,$81,$61,$51,$31,$31,$11,$11,$31,$51,$A1,$81,$81,$81,$81,$81,$81,$81,$61,$51,$31,$31,$11,$11,$11,$11,$11,$11,$11,$11,$61,$61,$61,$61,$41,$31,$11,$11,$D4,$B1,$B1,$D3,$11,$31,$51,$61,$61,$61,$31,$31,$31,$31,$31,$51,$71,$71,$81,$D4,$81,$D3,$31,$81,$81,$81,$51,$61,$FD,$00
	.dw musicChannel2Loop
musicEnd:
