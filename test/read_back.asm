
.include    "src/defs.inc"

.export     read_back

; --------------------------------------------------------------------------
;
; Test reading back the value written to the $0001 register, using both
;   normal access and LDA (zp),Y instruction.
;
; TODO: Test reading the $0000 location as well (will require payload in
;   another bank!)
;
; --------------------------------------------------------------------------

read_back:
            jmp @do_test
            .byte "read back", 0

@do_test:   
            lda #$00
            sta ZP_DATA
            lda #$00
            sta ZP_DATA+1
            ldy #$01
            tya
            sta BANK_ACCESS
            cmp BANK_ACCESS
            bne @end
            lda (ZP_DATA),y
            cmp BANK_ACCESS
            bne @end
            lda #$0F
            sta BANK_ACCESS
            cmp BANK_ACCESS
            bne @end
            lda (ZP_DATA),y
            cmp BANK_ACCESS
@end:
            rts
