
.include    "src/defs.inc"

.export     bank_execute

; --------------------------------------------------------------------------
;
; Test executing code in another bank.
;
; A simple payload is written to the $0100 location in banks $F and $1,
;   differing in one LDA instruction.
;
; The code starts execution in bank $F, switches midway to $1 and then back.
;
; If the code was truly executed in bank $1, the LDA instruction will give
;   the correct result.
;
; --------------------------------------------------------------------------

bank_execute:
            jmp @do_test
@expected:
            .byte $55
@banner:
            .byte "bank execute", 0

@do_test:   
            lda #$01
            sta BANK_ACCESS
            lda #$00
            sta TEST_VECTOR
            lda #$01
            sta TEST_VECTOR+1
            ldy #@payload_end-@payload
@loop:
            lda @payload,y
            sta (TEST_VECTOR),y
            sta $0100,y
            dey
            bpl @loop
            lda #$AA
            sta @payload_diff+1
            jsr $0100
            cmp @expected
            rts

@payload:
            .org $0100
            ldy #$01
            sty BANK_EXECUTE
@payload_diff:
            lda #$55
            ldy #$FF
            sty BANK_EXECUTE
            rts
            .reloc
@payload_end:
            