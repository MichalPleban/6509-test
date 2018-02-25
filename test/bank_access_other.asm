
.include    "src/defs.inc"

.export     bank_access_other

; --------------------------------------------------------------------------
;
; Test memory access in another bank with another instruction.
;
; Only LDA (zp),Y and STA (zp),Y instructions access other banks.
;
; This test uses CMP (zp),y instruction which should fetch data from the
;   execution bank.
;
; --------------------------------------------------------------------------

bank_access_other:
            jmp @do_test
            .byte "bank access other", 0

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
            cmp (ZP_DATA),y
            rts
