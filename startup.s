.global _start
    .section .text.entry

_start:
    call main
halt:
    j halt
