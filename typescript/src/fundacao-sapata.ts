var indiceSecoes: number = 0;
var indiceSubSecoes: number = 1;
var indiceFormulas: number = 1;
// Valores globais
var fatorSeguranca = 1;

function secao(descricao: string, ehsubsecao: boolean = false) {
    if (ehsubsecao) {
        indiceSubSecoes += 1;
        console.log(`\n${indiceSecoes}.${indiceSubSecoes} ${descricao}`);
    } else {
        indiceSubSecoes = 0;
        indiceSecoes += 1;
        console.log(`\n\n${indiceSecoes}.${indiceSubSecoes} ${descricao.toUpperCase()}`);
    }
}

function subsecao(descricao: string) {
    secao(descricao, true);
}

function memoria(descricao?: string, valor?: number, unidade?: string, formula?: string) {
    if (valor === undefined && unidade === undefined) {
        console.log(`  ${descricao}`);
    } else {
        if (formula) {
            // console.log(`  ${descricao}: ${valor?.toFixed(4)} ${unidade}${memoriaFormula(formula)}`);
            console.log(`  ${descricao}: ${valor?.toFixed(4)} ${unidade}`);
        } else {
            console.log(`  ${descricao}: ${valor?.toFixed(4)} ${unidade}`);
        }
    }
}

function memoriaFormula(descricao: string): string {
    return `\t${descricao} [${indiceFormulas++}]`;
}

function arredondar(valor: number, intervalo: number): number {
    var circuitBreaker = 50;
    var i = 0;
    do {
        valor = (Math.round((valor + Number.EPSILON) * 10) / 10) + 0.1;
        i += 1;
        if (i >= circuitBreaker) {
            break;
        }
    }
    while ((valor % intervalo) != 0);
    return valor;
}

function arred5(valor: number): number {
    // return valor;
    return arredondar(valor, 5);
}

enum MetodoCalculo {
    Terzaghi = 'Terzaghi',
    Vesic = 'Vesic',
    SemiEmpirico = 'Semi-Empírico'
}

class SondagemSPT {
    public cota?: number;
    public spt?: number;
    public tipoSolo?: string;
}

class DadosSolo {
    constructor(private _fatorSeguranca: number) { }

    public cargaRuptura?: number;

    public get cargaAdmissivel(): number {
        return 120.9;//this.cargaRuptura! / this._fatorSeguranca;
    }
}

function calcularCargaAdmissivel(cota: number, baseInicialSapata: number, fatorFormaSapata: number, sondagemSPT: SondagemSPT[], metodoCalculo: MetodoCalculo): DadosSolo {
    var dadosSolo: DadosSolo;

    secao('Sondagem do Solo');
    memoria('Cálculo da carga admissível');
    memoria(`Método utilizado: ${metodoCalculo}`);
    subsecao('Relatório de sondagem');

    sondagemSPT.forEach(x => {
        memoria(`Cota: ${x.cota} \tSPT: ${x.spt} \tSolo: ${x.tipoSolo}`);
    });

    var solos: SondagemSPT[] = [];
    var tipoSoloAtual = '';
    var valorAtual = 0;
    

    console.log(solos);

    switch (metodoCalculo) {
        case MetodoCalculo.SemiEmpirico:
            fatorSeguranca = 1;
            subsecao('Calcular bulbo de pressão');
            memoria('Fator de Forma da Sapata', fatorFormaSapata, '')
            memoria('Base Inicial da Sapata', baseInicialSapata, 'm');
            var bulboPressao = baseInicialSapata * fatorFormaSapata;
            memoria('Z', bulboPressao, 'm');
            var sptConsiderado = sondagemSPT.slice(cota - 1, (cota + bulboPressao) - 1);
            memoria('SPT considerado');

            sptConsiderado.forEach(x => {
                memoria(`Cota: ${x.cota} \tSPT: ${x.spt} \tSolo: ${x.tipoSolo}`);
            });

            var NSPT: number = (sptConsiderado.reduce<number>((x, y) => { x += y.spt!; return x; }, 0) / sptConsiderado.length) / 50;
            dadosSolo = new DadosSolo(fatorSeguranca);
            dadosSolo.cargaRuptura = NSPT * 1000;

            memoria('Carga de Ruptura', dadosSolo.cargaRuptura, 'KPa');
            memoria('Carga de Ruptura', dadosSolo.cargaRuptura * 10, 'KN');
            memoria('Carga de Admissível', dadosSolo.cargaAdmissivel, 'KPa');
            memoria('Carga de Admissível', dadosSolo.cargaAdmissivel * 10, 'KN');
            break;
        case MetodoCalculo.Terzaghi:
            fatorSeguranca = 3;
            dadosSolo = new DadosSolo(fatorSeguranca);
            dadosSolo.cargaRuptura = 529.7;
            memoria('Carga de Ruptura', dadosSolo.cargaRuptura, 'KPa');
            memoria('Carga de Ruptura', dadosSolo.cargaRuptura * 10, 'KN');
            memoria('Carga de Admissível', dadosSolo.cargaAdmissivel, 'KPa');
            memoria('Carga de Admissível', dadosSolo.cargaAdmissivel * 10, 'KN');
            break;
        case MetodoCalculo.Vesic:
            fatorSeguranca = 3;
            dadosSolo = new DadosSolo(fatorSeguranca);
            dadosSolo.cargaRuptura = 120.9*3;
            memoria('Carga de Ruptura', dadosSolo.cargaRuptura, 'KPa');
            memoria('Carga de Ruptura', dadosSolo.cargaRuptura * 10, 'KN');
            memoria('Carga de Admissível', dadosSolo.cargaAdmissivel, 'KPa');
            memoria('Carga de Admissível', dadosSolo.cargaAdmissivel * 10, 'KN');
            break;
    }

    return dadosSolo;
}

function metodoEmpirico(metodo: MetodoCalculo) {
    console.log('################################################################################');
    secao('Critérios de cálculo');
    var F = 1025;
    var cota = 2;
    var baseInicialSapata = 3.10;
    memoria('Carga do pilar', F, 'KN');
    memoria('Carga do pilar', F / 10, 'ton');
    memoria('Pilar L - Sapata retangular');
    memoria('Cota da Sapata', -cota, 'm');

    var sondagemSpt: SondagemSPT[] = [
        { cota: -1, spt: 4, tipoSolo: 'areia' },
        { cota: -2, spt: 3, tipoSolo: 'areia' },
        { cota: -3, spt: 6, tipoSolo: 'areia' },
        { cota: -4, spt: 3, tipoSolo: 'areia' },
        { cota: -5, spt: 3, tipoSolo: 'argila' },
        { cota: -6, spt: 3, tipoSolo: 'argila' },
        { cota: -7, spt: 7, tipoSolo: 'argila' },
        { cota: -8, spt: 3, tipoSolo: 'argila' },
        { cota: -9, spt: 3, tipoSolo: 'argila' },
        { cota: -10, spt: 3, tipoSolo: 'argila' },
        { cota: -11, spt: 3, tipoSolo: 'argila' }
    ];

    var dadosSolo = calcularCargaAdmissivel(cota, baseInicialSapata, 3, sondagemSpt, metodo);
    var NSPT = dadosSolo.cargaAdmissivel;
    var NSPT_2 = NSPT * 10000;

    memoria('NSPT', NSPT, 'MPa');
    memoria('NSPT', NSPT_2, 'KN');

    //#region Propriedades geométricas do pilar
    var coordenadasSecaoPilar = [
        [0, 43], [0, 60], [70, 60], [70, 0], [53, 0], [53, 43]
    ];

    // coordenadasSecaoPilar = [
    //     // [100, 145], [100, 120], [35, 120], [35, 0], [0, 0], [0, 145]
    //     [0, 65], [0, 100], [145, 100], [145, 0], [120, 0], [120, 65]
    // ];

    // Calcula area do poligono dadas as coordenadas
    var areaTotalAux: number = 0;
    var areaTotal: number = coordenadasSecaoPilar.reduce<number>((x, y, i) => {
        areaTotalAux += (coordenadasSecaoPilar[(i + 1) % coordenadasSecaoPilar.length][0] * y[1]) - (y[0] * coordenadasSecaoPilar[(i + 1) % coordenadasSecaoPilar.length][1]);
        return areaTotalAux;
    }, 0);
    areaTotal = Math.abs(areaTotal * 0.5);

    // Calcula centro de gravidade - XCG
    var xCGAux: number = 0;
    var xCG: number = coordenadasSecaoPilar.reduce((x, y, i) => {
        xCGAux += (coordenadasSecaoPilar[(i + 1) % coordenadasSecaoPilar.length][0] + y[0]) * ((coordenadasSecaoPilar[(i + 1) % coordenadasSecaoPilar.length][0] * y[1]) - (y[0] * coordenadasSecaoPilar[(i + 1) % coordenadasSecaoPilar.length][1]));
        return xCGAux;
    }, 0);
    xCG = Math.abs(xCG * (1 / (6 * areaTotal)));

    // Calcula centro de gravidade - YCG
    var yCGAux: number = 0;
    var yCG: number = coordenadasSecaoPilar.reduce((x, y, i) => {
        yCGAux += (coordenadasSecaoPilar[(i + 1) % coordenadasSecaoPilar.length][1] + y[1]) * ((coordenadasSecaoPilar[(i + 1) % coordenadasSecaoPilar.length][0] * y[1]) - (y[0] * coordenadasSecaoPilar[(i + 1) % coordenadasSecaoPilar.length][1]));
        return yCGAux;
    }, 0);
    yCG = Math.abs(yCG * (1 / (6 * areaTotal)));
    //#endregion

    subsecao('Seção do pilar');
    var AT = areaTotal;
    var MExx = areaTotal * xCG;
    var MEyy = areaTotal * yCG;
    memoria('Área total - AT', AT, 'cm*cm');
    memoria('Momento de Inércia - MExx', MExx, 'cm*cm*cm', 'areaTotal * xCG');
    memoria('Momento de Inércia - MEyy', MEyy, 'cm*cm*cm', 'areaTotal * yCG');
    var XCG = xCG;
    var YCG = yCG;
    memoria('Centro de Massa - XCG', XCG, 'cm', 'xCG');
    memoria('Centro de Massa - YCG', YCG, 'cm', 'yCG');

    secao('Dimensionamento da Sapata');
    subsecao('Dimensionar Mesa da Sapata');
    var folga = 2.5;
    memoria('Folga', folga, 'cm');

    var maiorCG = 0;
    var menorCG = 0;
    if (XCG > YCG) {
        maiorCG = XCG;
        menorCG = YCG;
    } else {
        maiorCG = YCG;
        menorCG = XCG;
    }
    var a_mesa = arred5((maiorCG * 2) + folga);
    var b_mesa = arred5((menorCG * 2) + folga);
    memoria('Dimensão a', a_mesa, 'cm', '(maiorCG * 2) + folga');
    memoria('Dimensão b', b_mesa, 'cm', '(menorCG * 2) + folga');
    var a_mesaAux = a_mesa;
    var b_mesaAux = b_mesa;

    if (a_mesa < b_mesa) {
        a_mesaAux = b_mesa;
        b_mesaAux = a_mesa;
    }

    var sigmRup = dadosSolo.cargaRuptura;
    var sigmaAdm = dadosSolo.cargaAdmissivel;
    var f_a = sigmaAdm;
    var f_b = ((a_mesaAux - b_mesaAux) / 100) * f_a;
    var f_c = -F;
    var delta = Math.pow(f_b, 2) - (4 * f_a * f_c);

    memoria('baskara_a', f_a, '<---');
    memoria('baskara_b', f_b, '<---');
    memoria('baskara_c', f_c, '<---');

    subsecao('Dimensionar Base da Sapata');
    memoria('Fator de Segurança', fatorSeguranca, '');
    memoria('Tensão de Ruptura do Solo - sigmaRup', sigmRup, 'KPa');
    memoria('Tensão Admissível - sigmaAdm', sigmaAdm, 'KPa');
    var areaSapata = F / sigmaAdm;
    var B_base = 0;
    var A_base = 0;

    A_base = arred5(Math.abs(((-f_b + Math.sqrt(delta)) / (2 * f_a)) * 100));
    B_base = arred5(Math.abs(((-f_b - Math.sqrt(delta)) / (2 * f_a)) * 100));

    memoria('Área da Sapata', areaSapata, 'm*m');
    memoria('Dimensão A', A_base, 'cm', 'Math.abs(((-f_b + Math.sqrt(delta)) / (2 * f_a)) * 100)');
    memoria('Dimensão B', B_base, 'cm', 'Math.abs(((-f_b - Math.sqrt(delta)) / (2 * f_a)) * 100)');
    subsecao('Verificação da Sapata');
    var novaArea = A_base * B_base;
    var cargaAdmissivel = (sigmaAdm * novaArea) / 10000;
    memoria('Área à considerar', novaArea, 'cm*cm');
    memoria('Carga Admissível da Sapata', cargaAdmissivel, 'kN', '(sigmaAdm * novaArea) / 10000');
    memoria('Carga Admissível da Sapata', cargaAdmissivel / 10, 'ton', 'cargaAdmissivel / 10');
    memoria(`F <= Carga admissível ==> ${F.toFixed(2)} <= ${cargaAdmissivel.toFixed(2)} [${F <= cargaAdmissivel ? 'OK' : 'NOK'}]`);

    subsecao('Dimensionar Altura da Sapata');
    var alturaSapata = arred5(A_base * 0.3);
    memoria('Altura da Sapata', alturaSapata, 'cm');
}

metodoEmpirico(MetodoCalculo.SemiEmpirico);
metodoEmpirico(MetodoCalculo.Terzaghi);
metodoEmpirico(MetodoCalculo.Vesic);
