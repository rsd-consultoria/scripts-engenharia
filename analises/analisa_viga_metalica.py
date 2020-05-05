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

from models.analise import Analise
from models.perfil_metalico import PerfilMetalico

class AnaliseVigaMetalica(Analise):
    def __init__(self):
        super().__init__()

    def set_perfil_metalico(self, perfil: PerfilMetalico):
        self.add_material('Material do Perfil', perfil.get_material())
        self.adicionar_carga(perfil.get_peso(), 'Carga do Perfil')

    # 8.1
    def flambagem_local_alma(self, altura, espessura):
        return altura / espessura
    
    # 8.2
    def flambagem_local_mesa_comprimida(self, largura, espessura):
        return (largura / 2) / espessura
    
    # 8.3
    def flambagem_lateral_com_torsao(self, comprimento, ry):
        return comprimento / ry
    
    # 8.4 - Classe 1 - Secoes supercompactas
    def momento_plastificacao(self, modulo_resistente_plastico, tensao_escoamento):
        return modulo_resistente_plastico * tensao_escoamento
    
    def resistencia_nominal_momento_fletor(self, modulo_resistente_plastico, modulo_resistente_elastico, momento_fletor_inicio_escoamento, momento_fletor_flambagem_elastica, tensao_escoamento, parametro_esbeltez, parametro_esbeltez_p, parametro_esbeltez_r):
        if parametro_esbeltez <= parametro_esbeltez_p:
            # 8.5 - Classe 2 - Secoes compactas
            return self.momento_plastificacao(modulo_resistente_plastico, tensao_escoamento)
        elif (parametro_esbeltez > parametro_esbeltez_p) and (parametro_esbeltez <= parametro_esbeltez_r):
            # 8.6 - Classe 2 - Secoes compactas
            return self.momento_plastificacao(modulo_resistente_plastico, tensao_escoamento) 
            - (self.momento_plastificacao(modulo_resistente_plastico, tensao_escoamento) - momento_fletor_inicio_escoamento)
            * ((parametro_esbeltez - parametro_esbeltez_p)/(parametro_esbeltez_r - parametro_esbeltez_p))
        elif parametro_esbeltez > parametro_esbeltez_r:
            # 8.7 - Classe 2 - Secoes ezbeltas
            return modulo_resistente_elastico * momento_fletor_flambagem_elastica
    # 8.8
    def momento_dimensionamento(self, momento_fletor_atuante, coeficiente_majoracao):
        return momento_fletor_atuante * coeficiente_majoracao
    
    # 8.9

    # 8.10
    def coeficiente_seguranca_flexao(self):
        return 0.9
    
    # 8.11
    def momento_dimensionamento_1(self, tensao_escoamento):
        pass

    # 8.12
    def modulo_resistente_plastico(self, momento_dimensionamento, coeficiente_seguranca_flexao, tensao_escoamento):
        return momento_dimensionamento / (coeficiente_seguranca_flexao * tensao_escoamento)
    
    # 8.13

    # 8.14
    def lambda_pa(self, E, tensao_escoamento):
        return 3.5 * math.sqrt(E / tensao_escoamento)
    
    # 8.15
    def lambda_ra(self, E, tensao_escoamento):
        return 5.6 * math.sqrt(E / tensao_escoamento)
    
    def momento_na(self, parametro_esbeltez_a, parametro_esbeltez_pa, parametro_esbeltez_ra, momento_dimensionamento, coeficiente_seguranca_flexao, tensao_escoamento):
        if parametro_esbeltez_a <= parametro_esbeltez_pa:
            # 8.16
            return modulo_resistente_plastico(momento_dimensionamento, coeficiente_seguranca_flexao, tensao_escoamento)
        elif ((parametro_esbeltez_a > parametro_esbeltez_pa) and (parametro_esbeltez_a <= parametro_esbeltez_ra)):
            return 
            pass

    def get_memoria_calculo(self):
        super().get_memoria_calculo()

        print('\n\n{:=^80}\n'.format('[ PARAMETROS DE PROJETO ]'))


        print('\n\n{:=^80}\n'.format('[ RESULTADO - DIMENSIONAMENTO ]'))
        
        print('\n\n')
