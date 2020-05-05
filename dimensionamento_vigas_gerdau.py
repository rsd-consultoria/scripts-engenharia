# Copyright (c) 2020 rsdconsultorias.com.br

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
from functools import reduce

_tipos_carregamento: list = (
    (1, 'Carga Distribuída',
        (0.125, '****', 0.5, '****', 0.013, 1., 1.), 'TVAP 1'),
    (2, 'Uma Carga Concentrada',
        (0.250, '****', 0.500, '****', 0.021, 2.000, 0.80), 'TVAP 2'),
    (3, 'Duas Carga Concentradas',
        (0.333, '****', 1.000, '****', 0.036, 2.667, 1.022), 'TVAP 3'),
    (4, 'Três Carga Concentradas',
        (0.500, '****', 1.500, '****', 0.050, 4.000, 0.950), 'TVAP 4'))
# kg/m^2
_acoes_permanentes = list()
_acoes_variaveis = list()

# Cargas Permanentes
# _acoes_permanentes.append((37.7, 'Peso Proprio'))
while True:
    carga = input('Digite a carga permanente (kgf/m) [ex.: 12.34;Carga Permanente]: ')
    if carga == '0' or carga == '':
        break
    elif carga.split(';')[0].isnumeric:
        _acoes_permanentes.append((float(carga.split(';')[0]) * 1.0, carga.split(';')[1]))

# Cargas Variáveis
while True:
    carga = input('Digite a carga acidental (kgf/m) [ex.: 12.34;Carga Variável]: ')
    if carga == '0' or carga == '':
        break
    elif carga.split(';')[0].isnumeric:
        _acoes_variaveis.append((float(carga.split(';')[0]) * 1.0, carga.split(';')[1]))

carga_permanente_total = 0.
carga_variavel_total = 0.
if len(_acoes_permanentes) > 1:
    carga_permanente_total = reduce(lambda x, y: x + y, map(lambda x: x[0], _acoes_permanentes)) / 1000
elif len(_acoes_permanentes) == 1:
    carga_permanente_total = _acoes_permanentes[0][0] / 1000

if len(_acoes_variaveis) > 1: 
    carga_variavel_total = reduce(lambda x, y: x + y, map(lambda x: x[0], _acoes_variaveis)) / 1000
elif len(_acoes_variaveis) == 1:
    carga_variavel_total = _acoes_variaveis[0][0] / 1000

# unidade m
comprimento_viga = float(input('Digite o comprimento da viga (m): '))

# unidade m^2
area_influencia = 1

# unidade tf
acao_permanente_total = area_influencia * carga_permanente_total * comprimento_viga
acao_variavel_total = area_influencia * carga_variavel_total * comprimento_viga
reacao_permanente_total = 0.5 * (area_influencia * carga_permanente_total * comprimento_viga)
reacao_variavel_total = 0.5 * (area_influencia * carga_variavel_total * comprimento_viga)
reacao_total = reacao_permanente_total + reacao_variavel_total
acao_total = acao_permanente_total + acao_variavel_total


tipo_carregamento = int(input('Digite o tipo de carregamento (1, 2, 3, 4): '))
coeficiente_deslocamento_maximo = 350
# unidade cm -> Tabela C.1
deslocamento_maximo = (comprimento_viga * 100) / coeficiente_deslocamento_maximo

# -> Tabela 1 de Cargas Concentradas Equivalentes
momento_positivo_maximo = _tipos_carregamento[tipo_carregamento - 1][2][0]
momento_negativo_maximo = _tipos_carregamento[tipo_carregamento - 1][2][1]
reacao_no_apoio_simples = _tipos_carregamento[tipo_carregamento - 1][2][2]
reacao_no_apoio_engastado = _tipos_carregamento[tipo_carregamento - 1][2][3]
flecha_maxima = _tipos_carregamento[tipo_carregamento - 1][2][4]
carga_uniforme_equivalente = _tipos_carregamento[tipo_carregamento - 1][2][5]
coeficiente_flecha_carga_uniforme_equivalente = _tipos_carregamento[tipo_carregamento - 1][2][6]

maximo_momento_fletor = (carga_variavel_total * (comprimento_viga ** 2)) / 8

# depende do material --> tabela ?
modulo_elasticidade = 250

# unidade cm^4
inercia_necessaria = 0.1 * ((flecha_maxima * acao_variavel_total * ((comprimento_viga * 100) ** 3)) / (modulo_elasticidade * deslocamento_maximo))
modulo_resistencia_necessario = (maximo_momento_fletor * 100000) / (modulo_elasticidade * 10)


print('==========================[ DIMENSIONAR VIGA DE AÇO - Tabelas Gerdau ]==========================\n')

# print('{0:.<50}{1:.>20,.5f} m^2'.format('Área de Influência de Carga', area_influencia))

print('\n\nCARGAS CONCENTRADAS EQUIVALENTES\n')
print('{0:.<50}{1:.>27}'.format('Tipo de Carregamento', _tipos_carregamento[tipo_carregamento - 1][1].upper()))
print('  {0:.<48}{1:.>27}'.format('Usar tabela', _tipos_carregamento[tipo_carregamento - 1][3].upper()))
print('  {0:.<48}{1:.>27}'.format('a Momento Positivo Máximo', momento_positivo_maximo))
print('  {0:.<48}{1:.>27}'.format('b Momento Negativo Máximo', momento_negativo_maximo))
print('  {0:.<48}{1:.>27}'.format('c Reação no Apoio Simples', reacao_no_apoio_simples))
print('  {0:.<48}{1:.>27}'.format('d Reação no Apoio Engastado', reacao_no_apoio_engastado))
print('  {0:.<48}{1:.>27}'.format('e Flecha Máxima', flecha_maxima))
print('  {0:.<48}{1:.>27}'.format('f Carga Uniforme Equivalente', carga_uniforme_equivalente))
print('  {0:.<58}{1:.>17}'.format('g Coeficiente da flecha para carga uniforme equivalente', coeficiente_flecha_carga_uniforme_equivalente))

print('\n\nAÇÕES PERMANENTES')
for acao in _acoes_permanentes:
    print('  {0:.<48}{1:.>20,.5f} tf/m'.format(acao[1], acao[0]/1000))
print('\nAÇÕES VARIÁVEIS')
for acao in _acoes_variaveis:
    print('  {0:.<48}{1:.>20,.5f} tf/m'.format(acao[1], acao[0]/1000))

print('\n{0:.<50}{1:.>20,.5f} tf/m'.format('Carga Permanente Total', carga_permanente_total))
print('{0:.<50}{1:.>20,.5f} tf/m'.format('Carga Variável Total', carga_variavel_total))
print('{0:.<50}{1:.>20,.5f} tf/m'.format('Carga Total', carga_permanente_total + carga_variavel_total))

print('\n{0:.<50}{1:.>20,.5f} tf'.format('Ação Permanente Total', acao_permanente_total))
print('{0:.<50}{1:.>20,.5f} tf'.format('Reação Permanente Total', reacao_permanente_total))
print('{0:.<50}{1:.>20,.5f} tf'.format('Ação Variável Total', acao_variavel_total))
print('{0:.<50}{1:.>20,.5f} tf'.format('Reação Variável Total', reacao_variavel_total))
print('{0:.<50}{1:.>20,.5f} tf.m'.format('Máximo Momento Fletor', maximo_momento_fletor))

print('\n{0:.<50}{1:.>20,.5f} tf'.format('(!) Ação Total', acao_total))
print('{0:.<50}{1:.>20,.5f} tf'.format('Reação Total nos Apoios', reacao_total))
print('\n{0:.<50}{1:.>20,.5f} cm'.format('Deslocamento Máximo Admissível', deslocamento_maximo))
print('{0:.<50}{1:.>20,.5f} cm^4'.format('(!) Inércia Necessária (Ix)', inercia_necessaria))


print('\n\n{0:.<50}{1:.>20}'.format('Identificação da Viga', 'V1'))
print('{0:.<50}{1:.>20,.5f} m'.format('Comprimento da Viga', comprimento_viga))
print('\n{0:.<50}{1:.>20,.5f} kgf/cm^2'.format('Tensão de Escoamento do Aço', modulo_elasticidade * 10))
print('{0:.<50}{1:.>20,.5f} MPa'.format('Tensão de Escoamento do Aço', modulo_elasticidade))
print('{0:.<50}{1:.>20,.5f} cm^3'.format('(!) Módulo de Resistência Necessário (wx)', modulo_resistencia_necessario))

print('\n\n### BITOLAS ADMISSÍVEIS ###\n')

import sqlite3
conn = sqlite3.connect('bitolas_gerdau')
c = conn.cursor()
print('{0:<20} {1:>12} {2:>12} {3:>12} {4:>12} {5:>12} {6:>12} {7:>12} {8:>12} {9:>12} {10:>12}'.format('BITOLA', 'd (mm)', 'bf (mm)', 'tw (mm)', 'rx (cm)', 'ry (cm)', 'wx (cm^3)', 'wy (cm^3)', 'AREA (cm^2)', 'Ix (cm^4)', 'MASSA (kg/m)'))
print('------------------------------------------------------------------------------------------------------------------------------------------------------')
indice_bitola = 0
_bitolas_admissiveis = list(c.execute("select bitola, d, bf, tw, rx, ry, wx, wy, area, ix, massa from bitolas_gerdau where ix > {0} and wx > {1} order by ix asc limit 10".format(inercia_necessaria, modulo_resistencia_necessario)))
for row in _bitolas_admissiveis:
    indice_bitola += 1
    print('{0:<20} {1:>12} {2:>12} {3:>12} {4:>12} {5:>12} {6:>12} {7:>12} {8:>12} {9:>12} {10:>12}'.format('[{0}] {1}'.format(indice_bitola, row[0]), row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9], row[10]))
c.close()
conn.close()
print('\n\n\n')
bitola_selecionada = input('Indique a bitola desejada [1, ..., 10]: ')

print(_bitolas_admissiveis[int(bitola_selecionada) - 1])



