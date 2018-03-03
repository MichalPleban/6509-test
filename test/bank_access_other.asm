
.include    "src/defs.inc"

.export     bank_access_other

; --------------------------------------------------------------------------
;
; Test memory access in another bank with another instruction.
;
; Only LDA (zp),Y and STA (zp),Y instructions access other banks.
;
; This test uses ADC (zp),y instruction which should fetch data from the
;   execution bank.
;
; --------------------------------------------------------------------------

bank_access_other:
            jmp @do_test
@expected:
            .byte $55
@banner:
            .byte "bank access other", 0

@do_test:   
            lda #$01
            sta BANK_ACCESS
            lda #$00
            sta TEST_VECTOR
            lda #$01
            sta TEST_VECTOR+1
            ldy #$00
            lda #$AA
            sta (TEST_VECTOR),y
            lda #$55
            sta $0100
            lda #$00
            clc
            adc (TEST_VECTOR),y
            cmp @expected
            rts
