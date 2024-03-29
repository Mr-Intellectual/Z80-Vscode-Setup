;===========================================================================
; main.asm
;===========================================================================

NEX:    equ 0   ;  1=Create nex file, 0=create sna file

    IF NEX == 0
        DEVICE ZXSPECTRUM48
    ELSE
        DEVICE ZXSPECTRUMNEXT
    ENDIF

    ORG 0x4000
    defs 0x6000 - $    ; move after screen area
screen_top: defb    0   ; WPMEMx
Stack_Top:		EQU 0xFFF0    

;===========================================================================
; Include modules
;===========================================================================
    include "utilities.asm"
    include "fill.asm"
    include "clearscreen.asm"

    include "dezog.asm"

    ; Normally you would assemble the unit tests in a separate target
    ; in the makefile.
    ; As this is a very short program and for simplicity the
    ; unit tests and the main program are assembled in the same binary.
    include "unit_tests.asm"

;===========================================================================
; main routine - the code execution starts here.
; Sets up the new interrupt routine, the memory
; banks and jumps to the start loop.
;===========================================================================

 ORG $8000

main:
    ; Disable interrupts
    di
    ld sp,stack_top

    ; CLS
    call clear_screen
    call clear_backg

    ; Init
lbl1:    
    ld hl,fill_colors
    ld (fill_colors_ptr),hl
    ld de,COLOR_SCREEN
    
    ; Enable interrupts
    ;im 1

main_loop:
;This is where you put your assembly code
;--------------------------------------------------------------------------------

    ; Start typing here


;--------------------------------------------------------------------------------
    jr main_loop    








;===========================================================================
; Stack. 
;===========================================================================

 ld a,(rb_continue.bp1_address)


    STRUCT RECEIVE_BUFFER_CMD_CONTINUE
bp1_enable          BYTE    0
bp1_address         WORD    0
bp2_enable          BYTE    0
bp2_address         WORD    0
    ENDS

receive_buffer:
    defs 6
.payload
    defs 50

; definie alias labels for "receive_buffer" to access specific-command fields
rb_continue    RECEIVE_BUFFER_CMD_CONTINUE = receive_buffer.payload



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