
.include    "src/defs.inc"

.export     read_back_direct_1

; --------------------------------------------------------------------------
;
; Test reading back the value written to the $01 register, 
;   using direct read.
;
; --------------------------------------------------------------------------

read_back_direct_1:
            jmp @do_test
@expected:
            .byte $00
@banner:
            .byte "read back direct 1", 0

@do_test:   
            lda #$00
            sta BANK_ACCESS
            nop
            lda BANK_ACCESS
            cmp @expected
@end:
            rts
