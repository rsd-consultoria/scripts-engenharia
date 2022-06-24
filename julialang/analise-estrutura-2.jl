using LinearAlgebra

# Constantes
COMANDO_START = "start"

# Funcoes do terminal
function clearterminal()
    run(`clear`)
end

function print_setup_label()
    clearterminal()
    println("#################################### SETUP ####################################")
end

function print_label()
    clearterminal()
    println("############################ Análise de Estruturas ############################")
end

function print_resumo_projeto()
    println("Projeto: $(projeto)")
    println("Tipo de Estrutura: $(tipoestrutura)")
    println()
end


# variavel etapa controla em qual etapa do setup o usuário está
etapa = 1
# variavel comando controla qual comando atual o usuário digitou
comando = COMANDO_START

while comando != "fim"
    print_setup_label()

    if comando == COMANDO_START
        print("Nome do projeto: ")
        global projeto = readline()
        global comando = "tipo_estrutura"
    elseif comando == "tipo_estrutura"
        print("Tipo de Estrutura [Portico, Grelha, Viga, pLaca]: ")
        global tipoestrutura = readline()
        if startswith(lowercase(tipoestrutura), "p")
            global tipoestrutura = "PORTICO"
        elseif startswith(lowercase(tipoestrutura), "g")
            global tipoestrutura = "GRELHA"
        elseif startswith(lowercase(tipoestrutura), "v")
            global tipoestrutura = "VIGA"
        elseif startswith(lowercase(tipoestrutura), "l")
            global tipoestrutura = "PLACA"
        else
            global tipoestrutura = "INVALIDO"
        end
        global comando = "fim"
    else
        global comando = "fim"
    end
end

print_label()
print_resumo_projeto()