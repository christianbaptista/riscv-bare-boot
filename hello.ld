OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY {
  dram_space (rwx) : ORIGIN = 0x80000000, LENGTH = 128M
}

SECTIONS {
  . = ORIGIN(dram_space); /* Define o ponto de início da primeira seção */

  .text : {
    KEEP(*(.text.entry)) /* Garante que _start (de startup.s) seja incluído */
    *(.text)             /* Código C principal */
    *(.text.*)           /* Outras sub-seções de texto */
  } > dram_space

  .rodata : { /* Dados somente leitura */
    . = ALIGN(8); /* Alinha para 8 bytes */
    *(.rodata)
    *(.rodata.*)
  } > dram_space

  .data : { /* Dados inicializados */
    . = ALIGN(8); /* Alinha para 8 bytes */
    *(.data)
    *(.data.*)
  } > dram_space

  .bss : { /* Dados não inicializados (BSS) */
    . = ALIGN(8); /* Alinha para 8 bytes */
    __bss_start = .;
    *(.bss)
    *(.bss.*)
    *(COMMON)
    __bss_end = .;
  } > dram_space

  /* Opcional: Seção para descartar outras seções que não queremos */
  /DISCARD/ : {
    *(.eh_frame)
    *(.note.GNU-stack)
    *(.riscv.attributes)
  }
}
