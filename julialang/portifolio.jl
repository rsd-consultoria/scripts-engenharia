using Statistics

mutable struct Acao
    DATAPREGAO::Vector{String}
    CODNEG::String
    QUATOT::Vector{Int}
    PREABE::Vector{Float64}
    PREMAX::Vector{Float64}
    PREMIN::Vector{Float64}
    PREMED::Vector{Float64}
    PREULT::Vector{Float64}
    variancia::Float64
    media::Float64
    desvioPadrao::Float64
    mediaMovelSimplesCurtoPrazo::Vector{Float64}
    mediaMovelSimplesLongoPrazo::Vector{Float64}
    mediaMovelSimplesRetorno5::Vector{Float64}
end

function buildAcao(DATAPREGAO::String, CODNEG::String, QUATOT::Int, PREABE::Float64, PREMAX::Float64, PREMIN::Float64, PREMED::Float64, PREULT::Float64)
    return Acao([DATAPREGAO], CODNEG, [QUATOT], [PREABE], [PREMAX], [PREMIN], [PREMED], [PREULT], 0, 0, 0, Float64[], Float64[], Float64[])
end

function calcularRetorno(serie::Vector{Float64})::Vector{Float64}
    retorno::Vector{Float64} = Float64[]
    anterior = serie[1]

    for valor in serie[2:lastindex(serie)]
        append!(retorno, (valor - anterior) / anterior)
    end

    return retorno
end

function mediaMovelSimples(serieAnterior::Union{Vector{Float64},Nothing}, serie::Vector{Float64}, periodos::Int64)::Vector{Float64}
    _serie = serieAnterior !== nothing ? append!(serieAnterior, serie) : serie
    _mediaMovel::Vector{Float64} = Float64[]
    _ultimoIndice = lastindex(_serie)
    periodoInicial = 1
    periodoAtual = periodos

    while periodoAtual <= _ultimoIndice
        media = 0
        for valor in _serie[periodoInicial:periodoAtual]
            media += valor
        end
        append!(_mediaMovel, media / periodos)
        periodoAtual += 1
        periodoInicial += 1
    end

    return _mediaMovel
end

function mediaMovelExponencial(serieAnterior::Vector{Float64}, serie::Vector{Float64}, periodos::Int16)::Vector{Float64}
    _serie = length(serieAnterior) > 0 ? append!(serieAnterior, serie) : serie
    _mediaMovel::Vector{Float64} = Float64[]
    _ultimoIndice = lastindex(_serie)
    periodoInicial = 1
    periodoAtual = periodos

    while periodoAtual <= _ultimoIndice
        media = 0
        for valor in _serie[periodoInicial:periodoAtual]
            media += valor
        end
        append!(_mediaMovel, media / periodos)
        periodoAtual += 1
        periodoInicial += 1
    end

    return _mediaMovel
end
@time begin
    println("Portifolio de Ações")
    _dados = Float64[]

    arquivo_cotacoes = "/Users/rafaeldias/Downloads/COTAHIST_A2021 3.TXT"
    println("Carregar cotações do arquivo $arquivo_cotacoes")
    _arquivo = open(arquivo_cotacoes, "r")
    _dados = readlines(_arquivo)
    close(_arquivo)

    arquivo_cotacoes = "/Users/rafaeldias/Downloads/COTAHIST_A2022 5.TXT"
    println("Carregar cotações do arquivo $arquivo_cotacoes")
    _arquivo = open(arquivo_cotacoes, "r")
    append!(_dados, readlines(_arquivo))
    close(_arquivo)

    global acoes = Dict{String,Acao}()
    global carteiraAtual = Dict{String,Acao}()

    for _cotacao in _dados
        if length(_cotacao) > 0
            TIPREG = _cotacao[1:2]
            DATAPREGAO = _cotacao[3:10]
            CODNEG = replace(_cotacao[13:24], " " => "")
            TPMERC = _cotacao[25:27]
            QUATOT = _cotacao[153:170]
            PREABE = _cotacao[57:69]
            PREMAX = _cotacao[70:82]
            PREMIN = _cotacao[83:95]
            PREMED = _cotacao[96:108]
            PREULT = _cotacao[109:121]

            # Mercado Fracionario
            if TIPREG == "01" && TPMERC == "020"
                QUATOT = parse(Int, QUATOT)
                PREABE = parse(Int, PREABE) / 100.00 # DIVIDIR POR 100
                PREMAX = parse(Int, PREMAX) / 100.00 # DIVIDIR POR 100
                PREMIN = parse(Int, PREMIN) / 100.00 # DIVIDIR POR 100
                PREMED = parse(Int, PREMED) / 100.00 # DIVIDIR POR 100
                PREULT = parse(Int, PREULT) / 100.00 # DIVIDIR POR 100
                if haskey(acoes, CODNEG)
                    append!(acoes[CODNEG].QUATOT, QUATOT)
                    append!(acoes[CODNEG].PREABE, PREABE)
                    append!(acoes[CODNEG].PREMAX, PREMAX)
                    append!(acoes[CODNEG].PREMIN, PREMIN)
                    append!(acoes[CODNEG].PREMED, PREMED)
                    append!(acoes[CODNEG].PREULT, PREULT)
                else
                    acoes[CODNEG] = buildAcao(DATAPREGAO, CODNEG, QUATOT, PREABE, PREMAX, PREMIN, PREMED, PREULT)
                end
            end

            # Mercado a Vista
            if TIPREG == "01" && TPMERC == "010" && (startswith(CODNEG, "BOVA11"))
                QUATOT = parse(Int, QUATOT)
                PREABE = parse(Int, PREABE) / 100.00 # DIVIDIR POR 100
                PREMAX = parse(Int, PREMAX) / 100.00 # DIVIDIR POR 100
                PREMIN = parse(Int, PREMIN) / 100.00 # DIVIDIR POR 100
                PREMED = parse(Int, PREMED) / 100.00 # DIVIDIR POR 100
                PREULT = parse(Int, PREULT) / 100.00 # DIVIDIR POR 100

                if haskey(acoes, CODNEG)
                    append!(acoes[CODNEG].QUATOT, QUATOT)
                    append!(acoes[CODNEG].PREABE, PREABE)
                    append!(acoes[CODNEG].PREMAX, PREMAX)
                    append!(acoes[CODNEG].PREMIN, PREMIN)
                    append!(acoes[CODNEG].PREMED, PREMED)
                    append!(acoes[CODNEG].PREULT, PREULT)
                else
                    acoes[CODNEG] = buildAcao(DATAPREGAO, CODNEG, QUATOT, PREABE, PREMAX, PREMIN, PREMED, PREULT)
                end
            end
        end
    end
    _dados = nothing
    # Carteira atual
    # ITUB4 6 23.2
    # SBSP3 3 36.17
    # ABEV3 7 15.72
    # BOVA11 1 103.49
    # LUPA3F 1

    somaVariancia = 0.0
    alocacoes = Dict{String,Vector{Float64}}()
    alocacoesAux = Vector{Float64}()
    codigos = Vector{String}()
    for acao::Acao in sort!(collect(values(acoes)), by = x -> var(x.PREULT))
        if acao.CODNEG == "CBAV3F" || acao.CODNEG == "ITUB4F" || acao.CODNEG == "SBSP3F" || acao.CODNEG == "_ABEV3F" || acao.CODNEG == "_BOVA11" || acao.CODNEG == "_LUPA3F" || acao.CODNEG == "ENAT3F"
            global somaVariancia += var(acao.PREULT)
        end
    end
    f = open("cotacoes.json", "w")
    write(f, "[")
    for acao::Acao in sort!(collect(values(acoes)), by = x -> var(x.PREULT))
        acao.variancia = var(acao.PREULT)
        acao.desvioPadrao = std(acao.PREULT)
        acao.media = mean(acao.PREULT)
        acao.mediaMovelSimplesCurtoPrazo = mediaMovelSimples(nothing, acao.PREULT, 5)
        acao.mediaMovelSimplesLongoPrazo = mediaMovelSimples(nothing, acao.PREULT, 30)
        acao.mediaMovelSimplesRetorno5 = mediaMovelSimples(nothing, calcularRetorno(acao.PREULT), 5)

        mediaRetorno = mean(last(acao.mediaMovelSimplesRetorno5, 5))
        mediaVolume = mean(last(acao.QUATOT, 5))

        acimaMedia = 0
        abaixoMedia = 0

        for retorno in acao.mediaMovelSimplesRetorno5
            if retorno > mediaRetorno
                acimaMedia += 1
            else
                abaixoMedia += 1
            end
        end

        if acao.CODNEG == "CBAV3F" || acao.CODNEG == "ITUB4F" || acao.CODNEG == "SBSP3F" || acao.CODNEG == "_BOVA11" || acao.CODNEG == "ENAT3F" || acao.CODNEG == "_LUPA3F" || acao.CODNEG == "_ABEV3F"
            global alocacoes[acao.CODNEG] = [1. / (acao.variancia / somaVariancia)]
            push!(alocacoesAux, 1. / (acao.variancia / somaVariancia))
            push!(codigos, acao.CODNEG)
            write(f, replace("{\"fatorAlocacao\":$(1. / (acao.variancia / somaVariancia)),\"portifolio\":\"SIM\",\"codigo\":\"$(acao.CODNEG)\",\"variancia\":$(acao.variancia),\"desviopadrao\":$(acao.desvioPadrao),\"media\":$(acao.media),\"volume\":$(mean(acao.QUATOT)),\"mmscurto\":$(last(acao.mediaMovelSimplesCurtoPrazo, 5)),\"mmslongo\":$(last(acao.mediaMovelSimplesLongoPrazo, 5)),\"mmsretorno\":$(last(acao.mediaMovelSimplesRetorno5, 5)), \"mediaretorno\":$(mediaRetorno)},\n", "Float64[]" => "[]", "NaN" => "0"))
        end

        # if mediaRetorno > 0 && acimaMedia > abaixoMedia && last(acao.mediaMovelSimplesRetorno5) > mediaRetorno && mediaVolume > 1000
        #     global alocacoes[acao.CODNEG] = [1. / (acao.variancia / somaVariancia)]
        #     push!(alocacoesAux, 1. / (acao.variancia / somaVariancia))
        #     push!(codigos, acao.CODNEG)
        #     write(f, replace("{\"portifolio\":\"NAO\",\"codigo\":\"$(acao.CODNEG)\",\"variancia\":$(acao.variancia),\"desviopadrao\":$(acao.desvioPadrao),\"media\":$(acao.media),\"volume\":$(mean(acao.QUATOT)),\"mmscurto\":$(last(acao.mediaMovelSimplesCurtoPrazo, 5)),\"mmslongo\":$(last(acao.mediaMovelSimplesLongoPrazo, 5)),\"mmsretorno\":$(last(acao.mediaMovelSimplesRetorno5, 5)), \"mediaretorno\":$(mediaRetorno)},\n", "Float64[]" => "[]", "NaN" => "0"))
        # end
    end
    write(f, "{\"codigo\":\"AAAAAA\"}]")
    flush(f)
    close(f)
    acoes = nothing
end

b = 1600.
a = transpose(alocacoesAux) \ [b]
for i in 1:length(codigos)
    print("$(codigos[i]) $(a[i] * alocacoesAux[i]) -> $(100. * ((a[i] * alocacoesAux[i]) / b))% => $(b * (((a[i] * alocacoesAux[i]) / b)))\n")
end