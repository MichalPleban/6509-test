
.include    "src/defs.inc"

.export     read_back_direct_2

; --------------------------------------------------------------------------
;
; Test reading back the value written to the $01 register, 
;   using direct read.
;
; --------------------------------------------------------------------------

read_back_direct_2:
            jmp @do_test
@expected:
            .byte $0F
@banner:
            .byte "read back direct 2", 0

@do_test:   
            lda #$FF
            sta BANK_ACCESS
            nop
            lda BANK_ACCESS
            cmp @expected
@end:
            rts
