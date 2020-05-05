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
from models.material import Material
from analises.analisa_viga_metalica import AnaliseVigaMetalica
from models.perfil_metalico import PerfilMetalico

if __name__ == "__main__":
    ### INFORMAR NAS VARIAVEIS ABAIXO OS PARAMETROS INICIAIS

    # Carga aplicada no pilar. Deve ser informado o valor em kgf:
    carga_no_pilar = 50000

    # Altura do pilar. Deve ser informado em m:
    altura_pilar = 3

    # Coeficiente de majoracao/seguranca a ser aplicado:
    coeficiente_seguranca = 2

    ## Parametros do Perfil
    # rx
    rx = 6.85

    # ry
    ry = 3.84

    # Area da secao
    area_secao = 47.8

    # Altura da secao
    altura_secao = 16.2

    # Peso linear
    peso_linear = 37.1
    
    ### FIM

    t = AnaliseVigaMetalica()
    t.adicionar_carga(50000, 'Carga de Projeto')
    
    perfil = PerfilMetalico(area_secao, rx, ry, Material())
    perfil.set_peso(peso_linear)
    perfil.set_altura(altura_secao)

    t.set_perfil_metalico(perfil)
    t.get_memoria_calculo()