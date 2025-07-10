# Define a toolchain LLVM/Clang.
# Supondo que 'clang' e 'lld' estejam no seu PATH ou use o caminho completo se necessário.
# Por exemplo: LLVM_PATH = /opt/llvm20/bin/
# CC = $(LLVM_PATH)clang
# LD = $(LLVM_PATH)lld
# Ou apenas:
CC = clang
LD = clang # Clang pode atuar como driver para o linker LLD

# Flags de arquitetura RISC-V.
ARCH_FLAGS = -march=rv64i -mabi=lp64

# Flags de compilação para C (Clang).
# --target=riscv64-unknown-elf é crucial para o Clang saber qual arquitetura gerar.
# -nostdlib, -nostartfiles, -ffreestanding para ambiente bare-metal.
CFLAGS = $(ARCH_FLAGS) -nostdlib -nostartfiles -ffreestanding -O2 -Wall --target=riscv64-unknown-elf

# Flags de montagem para Assembly (Clang/integrated assembler).
# O Clang pode montar arquivos .s diretamente.
ASFLAGS = $(ARCH_FLAGS) --target=riscv64-unknown-elf

# Flags do Linker (LLD via Clang driver).
# -T hello.ld: Usa seu linker script.
# -static: Garante linkagem estática.
# -s: Remove símbolos de depuração (opcional, mas bom para binários menores).
LDFLAGS = -T hello.ld -static -s $(ARCH_FLAGS) -nostdlib -nostartfiles -ffreestanding --target=riscv64-unknown-elf

# Alvo principal: 'hello'
.PHONY: hello all clean

all: hello

hello: startup.o hello.o hello.ld
	$(LD) $(LDFLAGS) -o hello startup.o hello.o

# Regra para compilar o arquivo assembly
startup.o: startup.s
	$(CC) $(ASFLAGS) -c startup.s -o startup.o

# Regra para compilar o arquivo C
hello.o: hello.c
	$(CC) $(CFLAGS) -c hello.c -o hello.o

# Limpa os arquivos gerados
clean:
	rm -f hello hello.o startup.o
