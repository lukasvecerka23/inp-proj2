; Autor reseni: Lukas Vecerka xvecer30

; Projekt 2 - INP 2022
; Vernamova sifra na architekture MIPS64

; DATA SEGMENT
                .data

login:          .asciiz "xvecer30"  ; sem doplnte vas login
cipher:         .space  17  ; misto pro zapis sifrovaneho loginu

params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize "funkce" print_string)

; CODE SEGMENT
                .text
declaration:
    lui r5, 0
    lui r27, 0
    b loop1

addchar:
    ; add and check overflow of alphabeth
    addi r16, r16, 22
    slti r13, r16, 0x7A
    bne r13, r0, loop3
    addiu r13, r16, -123
    xor r16, r16, r16
    daddi r16, r16, 0x61
    dadd r16, r16, r13
    b loop3

subchar:
    ; sub and preserve for underflow of alphabet
    addiu r16, r16, -5
    slti r13, r16, 0x61
    beq r13, r0, loop3
    addiu r13, r16, -96
    xor r16, r16, r16
    daddi r16, r16, 0x7A
    dadd r16, r16, r13
    b loop3

loop1:
    ; load login char and check if its number
    lb r16, login(r5)
    slti r13, r16, 0x61
    bne r13, r0, main
    ; mod 2
    xor r13, r13, r13
    daddi r13, r13, 2
    div r5, r13
    mfhi r13
    ; odd or even char
    beq r13, r0, addchar
    b subchar

loop3:
    sb r16, cipher(r27)
    addi r27, r27, 1
    addi r5, r5, 1
    b loop1

main:
                daddi   r4, r0, cipher   ; vozrovy vypis: adresa login: do r4
                jal     print_string    ; vypis pomoci print_string - viz nize


                syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
