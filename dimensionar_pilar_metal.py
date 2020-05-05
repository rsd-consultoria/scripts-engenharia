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
import math

from models.material import Material
from models.perfil_metalico import PerfilMetalico

__cargas = list()

def adicionar_carga(carga: float, descricao: str):
    __cargas.append((carga, descricao))

def get_carga_total() -> float:
    if (len(__cargas) > 1):
        soma: float = 0.
        for carga in __cargas:
            soma += carga[0]
        return soma
    else:
        return __cargas[0][0]

def listar_cargas():
    print('{:=^80}\n'.format('[ CARGAS DE PROJETO ]'))
    for carga in __cargas:
        print('{0:.<50}{1:.> 26,.3f} kgf'.format(carga[1], carga[0]))
    print('\n{0:.<50}{1:.> 26,.3f} kgf'.format('(=) CARGA TOTAL', get_carga_total()))

def definir_perfil_metalico(perfil_metalico: PerfilMetalico):
    pass

def calcular_tensao_admissivel(E: float, indice_esbeltez: float, coeficiente_seguranca: float, tensao_escoamento: float) -> float:
    if(indice_esbeltez >= 105):
        return ((math.pi ** 2) * E) / ((indice_esbeltez ** 2) * coeficiente_seguranca)
    else:
        return (tensao_escoamento / coeficiente_seguranca) - (0.023 * (indice_esbeltez ** 2))

def get_memoria_calculo(altura: float, perfil_metalico: PerfilMetalico, coeficiente_seguranca: float, eixo: str):
    print('{:=^80}\n'.format('[ PARAMETROS DE PROJETO ]'))
    print('{0:.<50}{1:.>28.3f} m'.format('(1) Altura do pilar', altura))


    print('{0:.<12}{1:.>10,.3f} cm | {2:.<11}{3:.>10,.3f} cm | {4:.<11}{5:.>10,.3f} mm'.format('rx', perfil_metalico.get_rx(),
                                                                                    'ry', perfil_metalico.get_ry(),
                                                                                    'Altura', perfil_metalico.get_altura()))
    
    print('{0:.<9}{1:.>10,.3f} kgf/m | {2:.<7}{3:.>8,.3f} kgf/m.m'.format('Peso', perfil_metalico.get_peso(),
                                                                                        'fy', perfil_metalico.get_material().get_tensao_escoamento()))
    
    print('{0:.<13}{1:.>12}'.format('Perfil', perfil_metalico.get_material().get_tipo_material()))

    
    print('{0:.<50}{1:.>28}-{1}'.format('Eixo do perfil', eixo.upper()))
    print('{0:.<50}{1:.>30.3f}'.format('(2) Coeficiente de seguranca', coeficiente_seguranca))

    print('\n')
    adicionar_carga(perfil_metalico.get_peso() * altura, 'Peso Proprio')
    listar_cargas()
    
    # calcular indice de esbeltez
    if(eixo == 'y'):
        indice_esbeltez = (altura * 100.) / perfil_metalico.get_ry()
    else:
        indice_esbeltez = (altura * 100.) / perfil_metalico.get_rx()
    
    # determinar tensão admissivel à flambagem
    tensao_admissivel_a_flambagem = calcular_tensao_admissivel(perfil_metalico.get_material().get_indice_elasticidade(), 
                                                indice_esbeltez, coeficiente_seguranca,
                                                perfil_metalico.get_material().get_tensao_escoamento())
    
    # determinar tensão atuante
    tensao_atuante = get_carga_total() / perfil_metalico.get_area()

    # comparar tensao atuante x tensao admissivel
    dimensao_escolhida_atende = False
    if(tensao_atuante < tensao_admissivel_a_flambagem):
        dimensao_escolhida_atende = True
    
    # resultado do calculo
    print('\n\n{:=^80}\n'.format('[ RESULTADO - DIMENSIONAMENTO ]'))
    print('{0:.<50}{1:.>30,.3f}'.format('(4) Indice de esbeltez', indice_esbeltez))
    print('{0:.<50}{1:.>20,.3f} kgf/cm.cm'.format('(5) Tensao atuante', tensao_atuante))
    print('{0:.<50}{1:.>20,.3f} kgf/cm.cm'.format('(6) Tensao admissivel - Flambagem', tensao_admissivel_a_flambagem))

    if(dimensao_escolhida_atende):
        print('\n\n \n')
        print('\n\n{:#^80}\n'.format('[ SUCESSO: PERFIL ESCOLHIDO ATENDE (6) > (5) ]'))
    else:
        print('\n\n{:#^80}\n'.format('[ FALHA: PERFIL ESCOLHIDO NAO ATENDE (6) < (5) ]'))

if __name__ == "__main__":
    material = Material()
    material.set_tensao_escoamento(2500.)
    material.set_tipo_material('W 250 x 115.')

    ### INFORMAR NAS VARIAVEIS ABAIXO OS PARAMETROS INICIAIS

    # Carga aplicada no pilar. Deve ser informado o valor em kgf:
    carga_no_pilar = 4 * (366.686 / 10)

    # Altura do pilar. Deve ser informado em m:
    altura_pilar = 4.65

    # Coeficiente de majoracao/seguranca a ser aplicado:
    coeficiente_seguranca = 2

    ## Parametros do Perfil
    # rx
    rx = 11.38

    # ry
    ry = 6.62

    # Area da secao
    area_secao = 146.1

    # Altura da secao
    altura_secao = 269

    # Peso linear
    peso_linear = 115
    
    ### FIM

    perfil = PerfilMetalico(area_secao, rx, ry, material)
    perfil.set_peso(peso_linear)
    perfil.set_altura(altura_secao)

    adicionar_carga(carga_no_pilar, 'Carga da Laje')
    
    get_memoria_calculo(altura_pilar, perfil, coeficiente_seguranca, 'x')