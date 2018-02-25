
.export     clear_screen
.export     output_char
.export     new_line

; --------------------------------------------------------------------------
;
; Screen I/O routines used when running under normal KERNAL.
;
; --------------------------------------------------------------------------


BSOUT       = $FFD2

.segment    "IO"

clear_screen:
            lda #$93
            jmp BSOUT

output_char:
            jmp BSOUT
            
new_line:
            lda #$0D
            jmp BSOUT
