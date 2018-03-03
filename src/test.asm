
; --------------------------------------------------------------------------
; Import I/O routines for writing to the screen.
; --------------------------------------------------------------------------

.import     clear_screen
.import     output_char
.import     new_line

; --------------------------------------------------------------------------
; Import test routines.
; --------------------------------------------------------------------------

.import     bank_access_simple
.import     bank_access_overflow
.import     bank_access_other
.import     bank_execute
.import     read_back_direct_1
.import     read_back_direct_2
.import     read_back_indirect_1
.import     read_back_indirect_2

; --------------------------------------------------------------------------
;
; The main test code.
;
; Loop through the tests and output the result of each one.
;
; --------------------------------------------------------------------------

.segment	"CODE"

.include    "src/defs.inc"

start_tests:
            jsr output_banner
            jmp do_tests

; --------------------------------------------------------------------------
; Loop through the tests and execute them one by one.
; --------------------------------------------------------------------------

do_tests:
            ldx #$00
@loop:
            jsr do_one_test
            bne @loop
            jmp new_line

; --------------------------------------------------------------------------
; Execute one test, displaying its name and then result.
; --------------------------------------------------------------------------

do_one_test:
            lda the_tests+1,x
            beq @exit
            sta TEST_ADDR+1
            lda the_tests,x
            sta TEST_ADDR
            clc
            adc #4
            tay
            lda #$00
            adc the_tests+1,x
            jsr output_text
            lda #':'
            jsr output_char
            lda #$20
@loop:
            cpy #30
            beq @test
            jsr output_char
            iny
            bne @loop
@test:
            clc
            jsr jump_to_test
            bne @notok
            ldy #<msg_ok
            lda #>msg_ok
            jsr output_text
            beq @next
@notok:
            cpy #$5A
            beq @skip
            pha
            ldy #<msg_notok
            lda #>msg_notok
            jsr output_text
            pla
            jsr output_hex
            ldy #<msg_expected
            lda #>msg_expected
            jsr output_text
            ldy #$03
            lda (TEST_ADDR),y
            jsr output_hex
            jmp @next
@skip:
            ldy #<msg_skip
            lda #>msg_skip
            jsr output_text
@next:
            jsr new_line
            inx
            inx
@exit:
            rts

jump_to_test:
            jmp (TEST_ADDR)

msg_ok:     
            .byte "OK", 0
msg_notok:  
            .byte "FAILED: got ", 0
msg_skip:   
            .byte "skipped", 0
msg_expected:
            .byte ", expected ", 0

; --------------------------------------------------------------------------
; List of tests to be executed.
; --------------------------------------------------------------------------

the_tests:
            .word bank_access_simple
            .word bank_access_overflow
            .word bank_access_other
            .word bank_execute
            .word read_back_direct_1
            .word read_back_direct_2
            .word read_back_indirect_1
            .word read_back_indirect_2
            .word 0

; --------------------------------------------------------------------------
; Display greeting banner.
; --------------------------------------------------------------------------

output_banner:
            jsr clear_screen
            ldy #<the_banner
            lda #>the_banner
            jsr output_text
            jsr new_line
            jmp new_line

; --------------------------------------------------------------------------
; Display a zero-terminated string.
; --------------------------------------------------------------------------
            
output_text:
            sty TEST_VECTOR
            sta TEST_VECTOR+1
            lda #$0F
            sta BANK_ACCESS
            ldy #0
@loop:
            lda (TEST_VECTOR),y
            beq @exit
            jsr output_char
            iny
            bne @loop
@exit:
            rts
            
; --------------------------------------------------------------------------
; Display a hex string
; --------------------------------------------------------------------------

output_hex:
            pha
            lsr
            lsr
            lsr
            lsr
            tay
            lda hex_chars, y
            jsr output_char
            pla
            and #$0F
            tay
            lda hex_chars, y
            jsr output_char
            rts

hex_chars:
            .byte "0123456789ABCDEF";
            
; --------------------------------------------------------------------------
; Greeting banner.
; --------------------------------------------------------------------------

the_banner:
            .byte "6509 processor tests by Michal Pleban.", 0

