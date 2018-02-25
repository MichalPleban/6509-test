
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
.import     read_back

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
            sta ZP_DATA+3
            lda the_tests,x
            sta ZP_DATA+2
            clc
            adc #3
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
            ldy #<msg_notok
            lda #>msg_notok
            jsr output_text
            beq @next
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
            jmp (ZP_DATA+2)

msg_ok:     .byte "OK", 0
msg_notok:  .byte "FAILED", 0
msg_skip:   .byte "skipped", 0

; --------------------------------------------------------------------------
; List of tests to be executed.
; --------------------------------------------------------------------------

the_tests:
            .word bank_access_simple
            .word bank_access_overflow
            .word bank_access_other
            .word bank_execute
            .word read_back
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
            sty ZP_DATA
            sta ZP_DATA+1
            lda #$0F
            sta BANK_ACCESS
            ldy #0
@loop:
            lda (ZP_DATA),y
            beq @exit
            jsr output_char
            iny
            bne @loop
@exit:
            rts
            
; --------------------------------------------------------------------------
; Greeting banner.
; --------------------------------------------------------------------------

the_banner:
            .byte "6509 processor tests by Michal Pleban.", 0

