
.include    "src/defs.inc"

.export     bank_access_simple

; --------------------------------------------------------------------------
;
; Test simple memory access in another bank.
;
;  1. Save $55 to $10100 using indirect (bank) access.
;  2. Save $AA to $0100 in execution bank using normal access.
;  3. Read back from $10100 using indirect (bank) access.
;
; If the bank access succeeds, we will read $55 from $10100.
; If the bank access fails, we will read $AA from execution bank.
;
; --------------------------------------------------------------------------

bank_access_simple:
            jmp @do_test
            .byte "bank access simple", 0

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
            lda (ZP_DATA),y
            cmp #$55
            rts
