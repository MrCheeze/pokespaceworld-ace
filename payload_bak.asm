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
