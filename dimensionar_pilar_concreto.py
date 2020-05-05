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
from analises.analise_pilar_concreto import AnalisePilarConcreto
from util.barra_aco import listar_barras_aco, get_diametro_barra_from_diametro, get_diametro_barra_from_area

def iniciar_analise_pilar_concreto(aco: Material, concreto: Material) -> AnalisePilarConcreto:
    analise = AnalisePilarConcreto()
    analise.set_material_aco(material_aco)
    analise.set_material_concreto(concreto)
    return analise

if __name__ == "__main__":
    material_concreto = Material()
    material_aco = Material()
    material_aco.set_tensao_escoamento(4200.)

    ### INFORMAR NAS VARIAVEIS ABAIXO OS PARAMETROS INICIAIS

    # Carga aplicada no pilar. Deve ser informado o valor em kgf:
    carga_no_pilar = 980.07882
    
    # Base da secao do pilar. Deve ser informado em cm:
    base_secao = 15

    # Altura da secao do pilar. Deve ser informado em cm:
    altura_secao = 15

    # Altura do pilar. Deve ser informado em m:
    altura_pilar = 3.

    # Quantidade de barras na armacao principal do pilar:
    quantidade_barras = 4

    # Coeficiente de majoracao/seguranca a ser aplicado:
    coeficiente_seguranca = 2
    
    ### FIM
    t = iniciar_analise_pilar_concreto(material_aco, material_concreto)
    t.adicionar_carga(carga_no_pilar, 'Carga no Pilar')

    t.set_coeficiente_seguranca(coeficiente_seguranca)
    t.set_fck(20)

    t.set_dimensoes(altura_pilar, base_secao / 100., altura_secao / 100.)
    peso_proprio_estrutura = 2500 * t.get_dimensoes()[0] * t.get_dimensoes()[1] * t.get_dimensoes()[2]
    t.adicionar_carga(peso_proprio_estrutura, 'Peso Proprio da Estrutura')
    t.set_quantidade_barra_armacao(quantidade_barras)
    t.get_memoria_calculo()
