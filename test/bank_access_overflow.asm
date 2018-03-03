
.include    "src/defs.inc"

.export     bank_access_overflow

; --------------------------------------------------------------------------
;
; Test memory access in another bank crossing a page boundary.
;
; This is the same as "bank_access_simple" but with added twist:
;   the LDA instruction crosses a page boundary, making it one cycle longer.
;
; --------------------------------------------------------------------------

bank_access_overflow:
            jmp @do_test
@expected:
            .byte $55
@banner:
            .byte "bank access overflow", 0

@do_test:   
            lda #$01
            sta BANK_ACCESS
            lda #$00
            sta TEST_VECTOR
            lda #$01
            sta TEST_VECTOR+1
            ldy #$00
            lda #$55
            sta (TEST_VECTOR),y
            lda #$AA
            sta $0100
            iny
            dec TEST_VECTOR
            dec TEST_VECTOR+1
            lda (TEST_VECTOR),y
            cmp @expected
            rts
