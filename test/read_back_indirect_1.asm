
.include    "src/defs.inc"

.export     read_back_indirect_1

; --------------------------------------------------------------------------
;
; Test reading back the value written to the $01 register, 
;   using indirect read.
;
; --------------------------------------------------------------------------

read_back_indirect_1:
            jmp @do_test
@expected:
            .byte $00
@banner:
            .byte "read back indirect 1", 0

@do_test:   
            lda #$00
            sta TEST_VECTOR
            lda #$00
            sta TEST_VECTOR+1
            lda #$00
            sta BANK_ACCESS
            ldy #$01
            lda (TEST_VECTOR),y
            cmp @expected
@end:
            rts
