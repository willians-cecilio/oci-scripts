# Scripts para utilização no OCI CLI

### faultdomain.sh
1) Coleta os dados da instância com o 'get', filtra o estado + fault domain atual e salva em variáveis.
2) Verifica se a instância está desligada e, caso sim, altera o fault domain com base em uma rotação.
3) Aguarda 5 minutos para que o processo seja concluído e tenta iniciar a instância novamente.
