
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
            .byte "bank access overflow", 0

@do_test:   
            lda #$01
            sta BANK_ACCESS
            lda #$00
            sta ZP_DATA
            lda #$01
            sta ZP_DATA+1
            ldy #$00
            lda #$55
            sta (ZP_DATA),y
            lda #$AA
            sta $0100
            iny
            dec ZP_DATA
            dec ZP_DATA+1
            lda (ZP_DATA),y
            cmp #$55
            rts
