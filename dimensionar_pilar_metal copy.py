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


## mudar para arquivo de utils
import platform    # For getting the operating system name
import subprocess  # For executing a shell command

def clear_screen():
    """
    Clears the terminal screen.
    """

    # Clear command as function of OS
    command = "cls" if platform.system().lower()=="windows" else "clear"

    # Action
    return subprocess.call(command) == 0
##


from models.material import Material
from models.perfil_metalico import PerfilMetalico
print('================== DIMENSIONAR PILAR METALICO - PERFIL I ou H ==================')

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
    print('----------------------------- CARGAS CONSIDERADAS -----------------------------')
    for carga in __cargas:
        print('{0}: {1:.> 30.4f} kgf'.format(carga[1], carga[0]))
    print('---------------------')
    print('(3) Carga Total: {0:.> 31.4f} kgf'.format(get_carga_total()))

def definir_perfil_metalico(perfil_metalico: PerfilMetalico):
    pass

def calcular_tensao_admissivel(E: float, indice_esbeltez: float, coeficiente_seguranca: float, tensao_escoamento: float) -> float:
    if(indice_esbeltez >= 105):
        return ((math.pi ** 2) * E) / ((indice_esbeltez ** 2) * coeficiente_seguranca)
    else:
        return (tensao_escoamento / coeficiente_seguranca) - (0.023 * (indice_esbeltez ** 2))

def calcular(altura: float, perfil_metalico: PerfilMetalico, coeficiente_seguranca: float, eixo: str):
    print('\n\n{:=^80}\n'.format('[ PARAMETROS DE PROJETO ]'))
    # print('{0:.<60}{1:.> 20.4f}'.format('Coeficiente de Seguranca', self.get_coeficiente_seguranca()))
    # parametros de projeto
    print('\n--------------------------- PARAMETROS DE PROJETO ----------------------------')
    print('(1) Altura do pilar: {0:.> 30.4f} m'.format(altura))
    print('Perfil I: ', 
        'rx=', perfil_metalico.get_rx(), 'cm |',
        'ry=', perfil_metalico.get_ry(), 'cm |',
        'area=', perfil_metalico.get_area(), 'cm.cm |',
        '\n\taltura=', perfil_metalico.get_altura() ,'pol |', 
        'peso=', perfil_metalico.get_peso() , 'kg/m |',
        '\n\tMaterial=', perfil_metalico.get_material().get_tipo_material() ,
        ' | Tensao de escoamento (fy)=', perfil_metalico.get_material().get_tensao_escoamento() , 'kgf/cm.cm')
    print('Eixo do perfil: {0:.>30}-{0}'.format(eixo.upper()))

    print('(2) Coeficiente de seguranca: {0:.> 30}'.format(coeficiente_seguranca))

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
    print('\n\n--------------------------------- RESULTADO ----------------------------------')
    print('(4) Indice de esbeltez: {0:.> 30.4f}'.format(indice_esbeltez))
    print('(5) Tensao atuante: {0:.> 30.4f} kgf/cm.cm'.format(tensao_atuante))
    print('(6) Tensao admissivel - Flambagem: {0:.> 30.4f} kgf/cm.cm'.format(tensao_admissivel_a_flambagem))

    if(dimensao_escolhida_atende):
        print('\n\nSUCESSO ----> PERFIL ESCOLHIDO ATENDE (6) > (5) \n')
    else:
        print('\n\nFALHA ====> PERFIL ESCOLHIDO NAO ATENDE (6) < (5) *** ESCOLHER OUTRO PERFIL *** <====\n')

if __name__ == "__main__":
    clear_screen()
    altura_pilar: float = 0.
    coeficiente_seguranca: float = 0.
    eixo: str = ''
    print('Adicionar cargas')
    print('================\n\n\n')
    flag_continue_lendo = True
    while(flag_continue_lendo):
        valor_lido = input('Informe a carga (kgf): ')
        if valor_lido == '':
            flag_continue_lendo = False
        else:
            carga: float = float(valor_lido)
            descricao = input('Informe a descricao: ')
            adicionar_carga(carga, descricao)
    
    clear_screen()

    flag_continue_lendo = True
    while(flag_continue_lendo):
        valor_lido = input('Informe a altura do pilar (m): ')
        if valor_lido == '':
            clear_screen()
        else:
            altura_pilar = float(valor_lido)
            flag_continue_lendo = False
    
    clear_screen()

    flag_continue_lendo = True
    while(flag_continue_lendo):
        valor_lido = input('Informe o coeficiente de seguranca: ')
        if valor_lido == '':
            clear_screen()
        else:
            coeficiente_seguranca = float(valor_lido)
            flag_continue_lendo = False
    
    clear_screen()

    flag_continue_lendo = True
    while(flag_continue_lendo):
        valor_lido = input('Informe o eixo (X ou Y): ')
        if (valor_lido.upper() != 'X' and valor_lido.upper() != 'Y'):
            clear_screen()
        else:
            eixo = valor_lido
            flag_continue_lendo = False
    
    clear_screen()

    material = Material(2100000.)
    material.set_tensao_escoamento(2500.)
    material.set_tipo_material('Aco ASTM A-36')

    # perfil I
    perfil = PerfilMetalico(23.6, 6.24, 1.79, material)
    perfil.set_peso(18.5)
    perfil.set_altura(6.)

    # # perfil Composto
    # perfil = PerfilMetalico(2.96, 0.77, 1.2, material)
    # perfil.set_peso(0.)
    # perfil.set_altura(5.)

    # # perfil Composto
    # perfil = PerfilMetalico(4.64, 1.18, 1.71, material)
    # perfil.set_peso(0.)
    # perfil.set_altura(5.)

    calcular(altura_pilar, perfil, coeficiente_seguranca, eixo)
    
    flag_continue_lendo = True
    while(flag_continue_lendo):
        valor_lido = input('Recalcular com outro perfil? (S/N): ')
        if (valor_lido.upper() == 'S'):
            for carga in __cargas:
                if carga[1] == 'Peso Proprio':
                    __cargas.remove(carga)
            clear_screen()
            # perfil H
            area = float(input('Informe a area da secao (cm.cm): '))
            rx = float(input('Informe o valor de rx (cm): '))
            ry = float(input('Informe o valor de ry (cm): '))
            peso = float(input('Informe o peso (kg/m): '))
            altura = float(input('Informe a altura (pol): '))
            perfil = PerfilMetalico(area, rx, ry, material)
            perfil.set_peso(peso)
            perfil.set_altura(altura)
            calcular(altura_pilar, perfil, coeficiente_seguranca, eixo)
        else:
            flag_continue_lendo = False