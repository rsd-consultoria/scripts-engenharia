# CPII-E 32
# peso especifico do cimento kg/m3
gama_c = 3100.0

# AREIA
# modulo de finura da areia
MF = 2.6
# peso especifico kg/m3
gama_a = 2650.0
# massa unitaria kg/m3
massa_a = 1470.0

# BRITA
# peso especifico kg/cm3
gama_b = 2700.0
# massa unitaria kg/cm3
massa_b = 1500.0
Dmax = 25 #mm

# CONCRETO
fck = 25.0 #MPa
abat = 90 #mm
abat_tolerancia = 10 #+/-mm
sd = 5.5

# PROPORÇÃO DAS BRITAS
B1 = 0.8
B2 = 0.2

# 1 - calcular resistencia do corpo de prova MPa
@show fc28 = fck + 1.645 * sd

# 2 - encontrar relação água-cimento na curva de Abrams
@show relacao_ac = 0.475

# 3 - calcular modulo de elasticidade GPa
@show Eci = (5600.0 * sqrt(fck)) / 1000.0

# 4 - Encontrar consumo de água na tabela l/m3
@show consumo_agua = 200

# 5 - consumo de cimento kg/m3
@show consumo_cimento = consumo_agua / relacao_ac

# 6 - consumo de agregado graúdo m3
@show consumo_agr_graudo = 0.715 * massa_b

# 6.1 - consumo de agregado graudo B1 e B2
@show consumo_B1 = B1 * consumo_agr_graudo
@show consumo_B2 = B2 * consumo_agr_graudo

# 7 - consumo de agregado miudo m3
@show volume_areia = 1.0 - ((consumo_cimento / gama_c) + (consumo_agr_graudo / gama_b) + (consumo_agua / 1000.0))
@show consumo_areia = volume_areia * gama_a

# 8 - apresentacao do traço
_c = consumo_cimento / consumo_cimento
_a = consumo_areia / consumo_cimento
_b1 = consumo_B1 / consumo_cimento
_b2 = consumo_B2 / consumo_cimento
_ac = consumo_agua / consumo_cimento

println("\n\n")
println("TRAÇO: $(round(_c, digits=3)):$(round(_a, digits=3)):$(round(_b1, digits=3)):$(round(_b2, digits=3)):$(round(_ac, digits=3))")
println("\n--- RESUMO ---\n")
println("Consumo cimento (kg): $(round(consumo_cimento ,digits=1)) --> $(round(consumo_cimento / 50.0,digits=1)) sacos de 50kg")
println("Consumo areia (kg): $(round(consumo_areia ,digits=1))")
println("Consumo brita 1 (kg): $(round(consumo_B1 ,digits=1))")
println("Consumo brita 2 (kg): $(round(consumo_B2 ,digits=1))")
println("Consumo água (l): $(round(consumo_agua ,digits=1))")
println("\n\n")
