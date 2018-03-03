
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
@expected:
            .byte $55
@banner:
            .byte "bank access simple", 0

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
            lda (TEST_VECTOR),y
            cmp  @expected
            rts
