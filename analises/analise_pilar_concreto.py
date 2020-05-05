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
from models.analise import Analise
from util.barra_aco import listar_barras_aco, get_diametro_barra_from_diametro, get_diametro_barra_from_area

class AnalisePilarConcreto(Analise):
    def __init__(self):
        super().__init__()
        self.__altura = 0.
        self.__largurax = 0.
        self.__larguray = 0.
        self.__fck = 0.
        self.__quantidade_barra_armacao: int = 0.
        self.__material_aco: Material = None
        self.__material_concreto: Material = None
    
    def set_material_concreto(self, concreto: Material):
        self.__material_concreto = concreto
    
    def get_material_concreto(self) -> Material:
        return self.__material_concreto

    def set_material_aco(self, aco: Material):
        self.__material_aco = aco
    
    def get_material_aco(self) -> Material:
        return self.__material_aco

    def set_fck(self, fck: float):
        self.__fck = fck
    
    def get_fck(self) -> float:
        return self.__fck
    
    def get_fy(self) -> float:
        return self.get_material_aco().get_tensao_escoamento()
    
    def set_quantidade_barra_armacao(self, quantidade_barras: int):
        self.__quantidade_barra_armacao = quantidade_barras
    
    def get_quantidade_barra_armacao(self) -> int:
        return self.__quantidade_barra_armacao
    
    def set_dimensoes(self, altura: float, largurax: float, larguray: float):
        self.__altura = altura
        self.__largurax = largurax
        self.__larguray = larguray
    
    def get_dimensoes(self) -> tuple:
        return (self.__altura, self.__largurax, self.__larguray)
    
    def get_area_secao(self) -> float:
        return self.get_dimensoes()[1] * self.get_dimensoes()[2]
    
    def get_carga_ruptura(self) -> float:
        return self.get_carga_total() * self.get_coeficiente_seguranca()
    
    def get_relacao_af_ac(self) -> float:
        return (self.get_carga_flambagem() - ((self.get_area_secao() * 100 * 100) * (self.get_fck() * 10))) / (self.get_fy() * (self.get_area_secao() * 100 * 100))

    def get_area_armacao(self) -> float:
        return self.get_relacao_af_ac() * (self.get_area_secao() * 100 * 100)
    
    def get_forca_escoamento_aco(self) -> float:
        return self.get_fy() * self.get_area_armacao()
    
    def get_indice_esbeltez(self) -> float:
        return (self.get_dimensoes()[0] * 100) / math.sqrt(self.get_momento_inercia() / (self.get_area_secao() * 100 * 100))
    
    def get_momento_inercia(self) -> float:
        return ((self.get_dimensoes()[1] * 100) * ((self.get_dimensoes()[2]* 100) ** 3)) / 12.

    def get_coeficiente_flambagem(self) -> float:
        coeficiente_flambagem: float = 0.

        if(self.get_indice_esbeltez() >= 50 and self.get_indice_esbeltez() <= 100.):
            return 100. / (150. - self.get_indice_esbeltez())
        else:
            return 1.
    
    def get_carga_flambagem(self) -> float:
        fator_multiplicador: float = 1.

        if(self.get_dimensoes()[1] < .2 or self.get_dimensoes()[2] < .2):
            fator_multiplicador = 1.3

        return self.get_coeficiente_flambagem() * self.get_carga_ruptura() * fator_multiplicador

    def get_menor_dimensao_secao(self) -> float:
        menor_dimensao: float = 100. * (self.get_dimensoes()[0] / 25)
        if (menor_dimensao < 14.):
            return 14.
        else:
            return menor_dimensao

    def get_memoria_calculo(self):
        super().get_memoria_calculo()

        print('\n\n{:_^80}\n'.format('[ PARAMETROS DE PROJETO ]'))
        print('{0:.<60}{1:.> 20,.3f}'.format('Coeficiente de Seguranca', self.get_coeficiente_seguranca()))
        print('{0:.<60}{1:.> 16,.3f} MPa'.format('Tensao de Ruptura do Concreto (fck)', self.get_fck()))
        print('{0:.<60}{1:.> 10,.3f} kgf/cm.cm'.format('Tensao de Escoamento a Compressao do Aco (fy)', self.get_fy()))
        
        print('\n{0:.<60}{1:.> 8,.3f} m x {2:,.3f} m'.format('Dimensao da Secao Transversal (base x altura)', self.get_dimensoes()[1], self.get_dimensoes()[2]))
        print('{0:.<58}{1:.> 16,.3f} cm.cm'.format('Area da Secao de Concreto (AC)', self.get_area_secao() * 100 * 100))
        print('{0:.<60}{1:.> 14,.3f} cm.cm'.format('Area da Armacao (Af)', self.get_area_armacao()))
        print('{0:.<60}{1:.> 18,.3f} m'.format('Altura do Pilar', self.get_dimensoes()[0]))
        print('{0:.<60}{1:.> 20,.3f}'.format('Indice de Esbeltez', self.get_indice_esbeltez()))
        print('{0:.<60}{1:.> 20,.3f}'.format('Coeficiente de Flambagem', self.get_coeficiente_flambagem()))
        
        print('\n{0:.<56}{1:.> 14,.3f} kgf/cm.cm'.format('Carga de Ruptura (NR)', self.get_carga_ruptura()))
        print('{0:.<50}{1:.> 20,.3f} kgf/cm.cm'.format('Forca de Escoamento no Aco (Nae)', self.get_forca_escoamento_aco()))
        print('{0:.<60}{1:.> 20.2%}'.format('Relacao Af/AC', self.get_relacao_af_ac()))
        print('{0:.<56}{1:.> 20,.3f} kgf'.format('Carga de Flambagem (Nfl)', self.get_carga_flambagem()))

        if(self.get_relacao_af_ac() <= 0):
            print('\n\n{:#^80}'.format('[ FALHA: SECAO DE CONCRETO SUPER DIMENSIONADA PARA ESSA CARGA ]'))
            print('\n\n')
            exit()

        print('\n\n{:_^80}\n'.format('[ RESULTADO - DIMENSIONAMENTO ]'))
        print('{0:.<60}{1:.> 20.0f}'.format('Quantidade de Barras na Armacao', self.get_quantidade_barra_armacao()))
        print('{0:.<60}{1:.> 17,.3f} mm'.format('Diametro da Armacao Principal - Dimensao Comercial Adotada', get_diametro_barra_from_area(self.get_area_armacao() / self.get_quantidade_barra_armacao())))
        print('{0:.<60}{1:.> 17,.3f} mm'.format('Diametro do Estribo - Dimensao Comercial Adotada', get_diametro_barra_from_diametro(12.5 / self.get_quantidade_barra_armacao())))
        print('{0:.<60}{1:.> 17,.3f} cm'.format('Espacamento do Estribo', (12. * get_diametro_barra_from_area(self.get_area_armacao() / self.get_quantidade_barra_armacao())) / 10.) )
        print('{0:.<60}{1:.> 17,.3f} cm'.format('Menor Dimensao do Pilar - bminimo', self.get_menor_dimensao_secao()))
        
        print('\n\n')
        if(self.get_indice_esbeltez() > 140.):
            print('{:*^80}'.format('[ FALHA: INDICE DE ESBELTEZ DEVE SER MENOR QUE 140 ]'))
        if(self.get_dimensoes()[1] < .14 or self.get_dimensoes()[2] < .14):
            print('{:*^80}'.format('[ FALHA: MENOR DIMENSAO ADMISSIVEL DA SECAO DO PILAR DEVE SER 14cm ]'))
        if(self.get_relacao_af_ac() < .008 or self.get_relacao_af_ac() > .06):
            print('{:*^80}'.format('[ FALHA: RELACAO Af/AC DEVE ESTAR ENTRE 0.8% E 6% ]'))
        print('\n\n')

    def ler_parametros(self):
        material_concreto = Material()
        material_aco = Material()
        material_aco.set_tensao_escoamento(4200.)

        self.set_material_aco(material_aco)
        self.set_material_concreto(material_concreto)

        # Carga aplicada no pilar. Deve ser informado o valor em kgf:
        carga_no_pilar = float(input('Digite a carga aplicada (kgf): '))
        
        # Base da secao do pilar. Deve ser informado em cm:
        base_secao = float(input('Digite a base da seção (cm): '))

        # Altura da secao do pilar. Deve ser informado em cm:
        altura_secao = float(input('Digite a altura da seção (cm): '))

        # Altura do pilar. Deve ser informado em m:
        altura_pilar = float(input('Digite a altura do pilar (m): '))

        # Quantidade de barras na armacao principal do pilar:
        quantidade_barras = int(input('Digite a quantidade de barras da armação principal: '))

        # Coeficiente de majoracao/seguranca a ser aplicado:
        coeficiente_seguranca = float(input('Digite o fator de segurança: '))

        fck_concreto = int(input('Digite o fck do concreto: '))

        self.adicionar_carga(carga_no_pilar, 'Sobrecarga')
        self.set_dimensoes(altura_pilar, base_secao / 100., altura_secao / 100.)
        self.set_quantidade_barra_armacao(quantidade_barras)
        self.set_coeficiente_seguranca(coeficiente_seguranca)
        self.set_fck(fck_concreto)

        peso_proprio_estrutura = 2500 * self.get_dimensoes()[0] * self.get_dimensoes()[1] * self.get_dimensoes()[2]
        self.adicionar_carga(peso_proprio_estrutura, 'Peso Proprio da Estrutura')