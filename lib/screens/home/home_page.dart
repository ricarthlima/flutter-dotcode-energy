import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? calcNumber;
  double? consumo = 0;
  final TextEditingController _controllerNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tela Inicial"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text(""),
              accountEmail: Text(""),
            ),
            ListTile(
              title: const Text("Configurações"),
              onTap: () => Navigator.pushReplacementNamed(
                context,
                "settings",
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Leitura Atual",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _controllerNumber,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 32),
                keyboardType: TextInputType.number,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () => calc(),
                  child: const Text("Consultar"),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Divider(),
              ),
              (calcNumber != null)
                  ? Column(
                      children: [
                        Text(
                          "Valor: R\$ " + calcNumber!.toStringAsFixed(2),
                          style: const TextStyle(fontSize: 24),
                        ),
                        Text(
                          "Consumo: " + consumo!.toStringAsFixed(2) + " kWh",
                          style: const TextStyle(fontSize: 24),
                        ),
                        const Text("Valores aproximados.")
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  void calc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    double tusd = prefs.getDouble("TUSD")!;
    double te = prefs.getDouble("TE")!;
    double lastNumber = prefs.getDouble("LAST_NUMBER")!;
    bool yellowFlag = prefs.getBool("YELLOW_FLAG")!;
    bool redFlag = prefs.getBool("RED_FLAG")!;
    bool tenPercent = prefs.getBool("TEN_PERCENT")!;

    double qtdAtual = double.parse(_controllerNumber.text) - lastNumber;
    double total = (tusd * qtdAtual) + (te * qtdAtual);

    if (yellowFlag) {
      total = total + (1.874 * (qtdAtual / 100));
    }
    // https://agenciabrasil.ebc.com.br/economia/noticia/2021-07/agencia-brasil-explica-como-funcionam-bandeiras-tarifarias

    if (redFlag) {
      total = total + (9.492 * (qtdAtual / 100));
    }

    if (tenPercent) {
      total = total * 1.05;
    }

    // Contribuição de Iluminação Pública
    // https://www.dme-pc.com.br/atendimento/orientacoes-ao-consumidor/contribuicao-de-iluminacao-publica-cip

    double cipRate = 0;
    if (qtdAtual <= 30) {
      cipRate = 0.25;
    } else if (qtdAtual <= 50) {
      cipRate = 0.5;
    } else if (qtdAtual <= 100) {
      cipRate = 2;
    } else if (qtdAtual <= 200) {
      cipRate = 4;
    } else if (qtdAtual <= 300) {
      cipRate = 5.5;
    } else {
      cipRate = 7;
    }

    // Valor da Tarifa de Iluminação Pública calculada por Engenharia Reversa
    total = total + (500 * (cipRate / 100));

    setState(() {
      calcNumber = total;
      consumo = qtdAtual;
    });
  }
}
