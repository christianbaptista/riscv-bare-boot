// hello.c

// Define o endereço base do UART
#define UART_ADDR 0x10000000

// Função para escrever um caractere no UART
void putc(char c) {
    // Casting do endereço para um ponteiro volátil para char
    // 'volatile' é crucial para garantir que o compilador não otimize
    // as escritas para o hardware.
    *(volatile char *)UART_ADDR = c;
}

// Função para ler um caractere do UART
// Esta é uma implementação simples de polling, sem verificar o "data ready"
char getc() {
    return *(volatile char *)UART_ADDR;
}

// Função para imprimir uma string
void puts(const char *s) {
    while (*s) {
        putc(*s++);
    }
}

// Função principal do seu programa
int main() {
    puts("hello\r\n"); // Use \r\n para nova linha em terminais

    puts("Pressione ENTER para sair...\r\n");

    // Loop para esperar pelo caractere ENTER (Newline, ASCII 0x0A)
    while (1) {
        char c = getc();
        if (c == '\r' || c == '\n') { // Checa por Carriage Return ou Newline
            break; // Sai do loop se ENTER for pressionado
        }
    }

    // Se você chegar aqui, significa que ENTER foi pressionado.
    // Para "sair", em um ambiente bare-metal, você normalmente terminaria
    // o programa de alguma forma que o QEMU pudesse detectar.
    // Uma forma comum é um loop infinito, ou, para máquinas RISC-V,
    // chamar a instrução `_exit` via SBI (System Binary Interface),
    // se o OpenSBI estivesse ativo, o que não é o seu caso.
    // Como você desabilitou o OpenSBI, a melhor forma de "sair" do ponto de vista
    // do QEMU é um loop infinito aqui, ou um `return` da main (que voltaria para _start)
    // e então para o loop infinito de `_start`.

    puts("Saindo...\r\n");

    // Loop infinito final para que o QEMU não feche imediatamente após a mensagem
    // de "Saindo...", mas permaneça ativo no monitor.
    while (1) {
        // Nada a fazer, apenas manter o QEMU rodando no monitor
    }

    return 0; // Este return nunca será alcançado devido ao loop infinito
}
