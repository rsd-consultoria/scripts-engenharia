#=
MIT License

Copyright (c) 2022 Rafael Dias

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
=#
println("Quantos m3 precisa:")
metros_cubicos_concreto = parse(Float32, readline())
println("Especificação do cimento")
println("Composto: I, II, III, IV, V:")
cimento_composto = readline()
println("Adição: S, E, Z, F, ARI, B, P, RS, BP:")
cimento_adicao = readline()
println("Classe de resistência: 25, 32, 40:")
cimento_resistencia = parse(Int, readline())
cimento_tipo = "CP$(cimento_composto)-$(cimento_adicao) $(cimento_resistencia)"
println("Peso específico do cimento (kg/m3): ")
cimento_gama = parse(Float32, readline())       # kg/m3

println("Especificação da areia")
println("Módulo de finura: ")
areia_mod_finura = parse(Float32, readline()) #2.4
println("Peso específico da areia (kg/m3): ")
areia_gama = parse(Float32, readline()) #2650.0         # kg/m3
println("Massa unitária da areia (kg/m3): ")
areia_massa_unit = parse(Float32, readline()) #1450.0   # kg/m3

println("Especificação da brita")
println("Peso específico da brita (kg/m3): ")
brita_gama = parse(Float32, readline()) #2750.0         # kg/m3
println("Massa unitária da brita (kg/m3): ")
brita_massa_unit = parse(Float32, readline()) #1550.0   # kg/m3
println("Diâmetro máximo da brita (mm): ")
brita_diametro_max = parse(Float32, readline()) #19.0   # mm
#=
proporcao_britas
proporcao_britas = B0B1
proporcao_britas = B1B2
proporcao_britas = B2B3
proporcao_britas = B3B4
=#
println("Proporção de brita: B0B1, B1B2, B2B3, B3B4:")
proporcao_britas = readline() #"B0B1"
if proporcao_britas == "B0B1"
    brita_ba = 0.3
    brita_bb = 0.7
elseif proporcao_britas == "B1B2"
    brita_ba = 0.5
    brita_bb = 0.5
elseif proporcao_britas == "B2B3"
    brita_ba = 0.5
    brita_bb = 0.5
else
    proporcao_britas == "B3B4"
    brita_ba = 0.5
    brita_bb = 0.5
end


println("Especificação do concreto")
println("fck do concreto (MPa):")
concreto_fck = parse(Float32, readline()) #20  # MPa
println("Abatimento do concreto (mm):")
concreto_abatimento = parse(Float32, readline()) #100.0  # mm
println("Tolerância do abatimento (mm):")
concreto_abat_toler = parse(Float32, readline()) #10.0  # (+/-)mm
# desvio padrão depende do controle de qualidade na execução do concreto
# 4.0 5.5 7.0
println("Desvio padrão (preparação): 4, 5.5, 7")
concreto_sd = parse(Float32, readline()) #7.0
concreto_fcj = concreto_fck + (1.645 * concreto_sd)   # MPa
# 20, 25, 30, 35, 40, 45, 50, 60, 70, 80, 90
println("Classe de resistência do concreto: 20, 25, 30, 35, 40, 45, 50, 60, 70, 80, 90:")
concreto_classe_resistencia = parse(Float32, readline()) #20

println("Tipo de agregado graúdo:")
println("1 para basalto e diabásio")
println("2 para granito e gnaisse")
println("3 para calcário")
println("4 para arenito")
opcao_agregado = parse(Int, readline()) #2
if opcao_agregado == 1
    global concreto_alfa_E = 1.2
    global descricao_agregado = "Basalto e Diabásio"
elseif opcao_agregado == 2
    global concreto_alfa_E = 1.0
    global descricao_agregado = "Granito e Gnaisse"
elseif opcao_agregado == 3
    global concreto_alfa_E = 0.9
    global descricao_agregado = "Calcário"
elseif opcao_agregado == 4
    global concreto_alfa_E = 0.7
    global descricao_agregado = "Arenito"
end

if concreto_classe_resistencia < 55
    global concreto_Eci = concreto_alfa_E * (5600.0 * sqrt(concreto_fck)) / 1000.0   # GPa
else
    global concreto_Eci = (21.5e3 * concreto_alfa_E * ((concreto_fck / 10.0) + 1.25)^(1.0 / 3.0)) / 1000.0   # GPa
end

# Consultar curva de Abrams e encontrar relação A/C dado o fcm do concreto
println("     ***************** ATENÇÃO ***************************")
println("     Encontrar na tabela a relação A/C (curva de Abrams) \n\r     para fcj=$(concreto_fcj) MPa:")
println("     *****************************************************")
concreto_rel_ac = parse(Float32, readline()) #0.51

# Consultar tabela para consumo de água
println("     ***************** ATENÇÃO ***************************")
println("     Encontrar na tabela o consumo de água (l):")
println("     *****************************************************")
consumo_agua = parse(Float32, readline()) #205.0                                # l
consumo_cimento = consumo_agua / concreto_rel_ac    # kg/m3
consumo_agregado_graudo = 0.69 * brita_massa_unit  # kg/m3
consumo_agr_b1 = consumo_agregado_graudo * brita_ba # kg/m3
consumo_agr_b2 = consumo_agregado_graudo * brita_bb # kg/m3
volume_areia = 1.0 - ((consumo_cimento / cimento_gama) + (consumo_agregado_graudo / brita_gama) + (consumo_agua / 1000.0))   # m3
consumo_areia = volume_areia * areia_gama

# Apresentação do traço
_c = consumo_cimento / consumo_cimento
_a = consumo_areia / consumo_cimento
_b1 = consumo_agr_b1 / consumo_cimento
_b2 = consumo_agr_b2 / consumo_cimento
_ac = consumo_agua / consumo_cimento

Cmd(`clear`)
println("\n\n")
println("     *****************************************************")
println("     *                                                   *")
if isapprox(_b2, 0.0)
    println("     *    TRAÇO: $(round(_c, digits=3)) : $(round(_a, digits=3)) : $(round(_b1, digits=3)) : $(round(_ac, digits=3))")
else
    println("     *    TRAÇO: $(round(_c, digits=3)) : $(round(_a, digits=3)) : $(round(_b1, digits=3)) : $(round(_b2, digits=3)) : $(round(_ac, digits=3))")
end
println("     *                                                   *")
println("     *****************************************************")
println("\n\n====================== RESUMO por 1m3 ========================")
println("Consumo cimento (kg):\t\t$(round(consumo_cimento ,digits=1)) --> $(round(consumo_cimento / 50.0,digits=1, )) sacos de 50kg")
println("Consumo areia (kg):\t\t$(round(consumo_areia ,digits=1))")
println("Consumo brita $(SubString(proporcao_britas, 1, 2)) (kg):\t\t$(round(consumo_agr_b1 ,digits=1))")
println("Consumo brita $(SubString(proporcao_britas, 3, 4)) (kg):\t\t$(round(consumo_agr_b2 ,digits=1))")
println("Consumo água (l):\t\t$(round(consumo_agua ,digits=1)) --> $(round(consumo_agua / 20, digits=1)) latas de 20l")

quantidade = metros_cubicos_concreto
consumo_cimento *= quantidade
consumo_areia *= quantidade
consumo_agr_b1 *= quantidade
consumo_agr_b2 *= quantidade
consumo_agua *= quantidade
println("\n\n====================== RESUMO para $(quantidade)m3 ========================")
println("Consumo cimento (kg):\t\t$(round(consumo_cimento ,digits=1)) --> $(round(consumo_cimento / 50.0,digits=1)) sacos de 50kg")
println("Consumo areia (kg):\t\t$(round(consumo_areia ,digits=1))")
println("Consumo brita $(SubString(proporcao_britas, 1, 2)) (kg):\t\t$(round(consumo_agr_b1 ,digits=1))")
println("Consumo brita $(SubString(proporcao_britas, 3, 4)) (kg):\t\t$(round(consumo_agr_b2 ,digits=1))")
println("Consumo água (l):\t\t$(round(consumo_agua ,digits=1)) --> $(round(consumo_agua / 20, digits=1)) latas de 20l")
println("\n")
println("================== Propriedades do Concreto ==================")
println("Cimento:\t\t\t$(cimento_tipo)")
println("Classe de Resistência:\t\tC$(concreto_classe_resistencia)")
println("Desvio Padrão (MPa):\t\t$(concreto_sd)")
println("Agregado Graúdo:\t\t$(descricao_agregado)")
println("fck (MPa):\t\t\t$(round(concreto_fck ,digits=1))")
println("fcj (MPa):\t\t\t$(round(concreto_fcj ,digits=1))")
println("Eci (GPa):\t\t\t$(round(concreto_Eci ,digits=1))")
println("Abatimento (mm):\t\t$(round(concreto_abatimento ,digits=1)) +/- $(round(concreto_abat_toler ,digits=1))")
println("\n\n")