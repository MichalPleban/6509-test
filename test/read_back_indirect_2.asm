
.include    "src/defs.inc"

.export     read_back_indirect_2

; --------------------------------------------------------------------------
;
; Test reading back the value written to the $01 register, 
;   using indirect read.
;
; --------------------------------------------------------------------------

read_back_indirect_2:
            jmp @do_test
@expected:
            .byte $0F
@banner:
            .byte "read back indirect 2", 0

@do_test:   
            lda #$00
            sta TEST_VECTOR
            lda #$00
            sta TEST_VECTOR+1
            lda #$FF
            sta BANK_ACCESS
            ldy #$01
            lda (TEST_VECTOR),y
            cmp @expected
@end:
            rts
