;===========================================================================
; main.asm
;===========================================================================

    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION

NEX:    equ 1   ;  1=Create nex file, 0=create sna file

    IF NEX == 0
        DEVICE ZXSPECTRUM128
        ;DEVICE ZXSPECTRUM48
    ELSE
        DEVICE ZXSPECTRUMNEXT
    ENDIF

    ORG 0x4000
    defs 0x6000 - $    ; move after screen area
screen_top: defb    0   ; WPMEMx


;===========================================================================
; Persistent watchpoint.
; Change WPMEMx (remove the 'x' from WPMEMx) below to activate.
; If you do so the program will hit a breakpoint when it tries to
; write to the first byte of the 3rd line.
; When program breaks in the fill_memory sub routine please hover over hl
; to see that it contains 0x5804 or COLOR_SCREEN+64.
;===========================================================================

; WPMEMx 0x5840, 1, w


;===========================================================================
; Include modules
;===========================================================================
    include "utilities.asm"

    include "dezog.asm"


;===========================================================================
; main routine - the code execution starts here.
; Sets up the new interrupt routine, the memory
; banks and jumps to the start loop.
;===========================================================================


 defs 0x8000 - $
 ORG $8000

main:
    ; Disable interrupts
    di
    ld sp,stack_top

    jr $
;===========================================================================
; Stack.
;===========================================================================


; Stack: this area is reserved for the stack
STACK_SIZE: equ 100    ; in words


; Reserve stack space
    defw 0  ; WPMEM, 2
stack_bottom:
    defs    STACK_SIZE*2, 0
stack_top:
    ;defw 0
    defw 0  ; WPMEM, 2



    IF NEX == 0
        SAVESNA "z80-sample-program.sna", main
    ELSE
        SAVENEX OPEN "z80-sample-program.nex", main, stack_top
        SAVENEX CORE 2, 0, 0        ; Next core 2.0.0 required as minimum
        SAVENEX CFG 7   ; Border color
        SAVENEX AUTO
        SAVENEX CLOSE
    ENDIF
