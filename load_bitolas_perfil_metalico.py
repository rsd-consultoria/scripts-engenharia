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
import sqlite3

caminho_arquivo_origem = 'perfil-estrutural-tabela-de-bitolas.csv'
caminho_banco_dados = 'bitolas_gerdau'

tabela_bitolas = '''create table bitolas_gerdau (
    bitola text,
    massa real,
    d real,
    bf real,
    tw real,
    tf real,
    h real,
    d1 real,
    area real,
    ix real,
    wx real,
    rx real,
    zx real,
    iy real,
    wy real,
    ry real,
    zy real,
    rt real,
    it real,
    mesa real,
    alma real,
    cw real,
    u real,
    bitola_pol text
)'''

tabela_materias = '''
create table materiais (
    descricao text,
    limite_escoamento real,
    limite_resistencia real,
    alongamento_apos_ruptura real,
    limite_escoamento_max real,
    limite_resistencia_max real,
    alongamento_apos_ruptura_max real
)
'''

conn = sqlite3.connect(caminho_banco_dados)
c = conn.cursor()

c.execute('drop table if exists bitolas_gerdau')
c.execute(tabela_bitolas)
c.execute('drop table if exists materiais')
c.execute(tabela_materias)

arquivo_origem = open(caminho_arquivo_origem, 'r')

for linha in arquivo_origem.readlines():
    linha = linha.replace('.', '').replace(',', '.').split(';')
    c.execute('insert into bitolas_gerdau values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        (linha[0].replace('"', ''),
        linha[1],
        linha[2],
        linha[3],
        linha[4],
        linha[5],
        linha[6],
        linha[7],
        linha[8],
        linha[9],
        linha[10],
        linha[11],
        linha[12],
        linha[13],
        linha[14],
        linha[15],
        linha[16],
        linha[17],
        linha[18],
        linha[19],
        linha[20],
        linha[21],
        linha[22],
        linha[23].replace('"', ''))
    )


c.execute("insert into materiais values('ASTM A 572 Grau 50', 345, 450, 18, 0, 0, 0)")
c.execute("insert into materiais values('ASTM A 572 Grau 60', 415, 520, 16, 0, 0, 0)")
c.execute("insert into materiais values('ASTM A 992', 345, 450, 18, 450, 0, 0)")
c.execute("insert into materiais values('ACO COR 500', 370, 500, 18, 0, 0, 0)")
c.execute("insert into materiais values('ASTM A 131 AH32', 315, 440, 19, 0, 590, 0)")
c.execute("insert into materiais values('ASTM A 131 AH36', 355, 490, 19, 0, 620, 0)")

conn.commit()
arquivo_origem.close()

for row in c.execute("select * from bitolas_gerdau"):
    print(row)

conn.close()
