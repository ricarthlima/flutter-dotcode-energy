import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _tsudController = TextEditingController();
  final TextEditingController _teController = TextEditingController();
  final TextEditingController _lastNumberController = TextEditingController();

  bool isBandeiraAmerela = false;
  bool isBandeiraVermelha = false;
  bool isTenPercentOthers = false;

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Configurações",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(),
                  TextFormField(
                    controller: _tsudController,
                    decoration: const InputDecoration(
                      label: Text("Consumo Ativo (kWh) - TUSD"),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _teController,
                    decoration: const InputDecoration(
                      label: Text("Consumo Ativo (kWh) - TE"),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _lastNumberController,
                    decoration: const InputDecoration(
                      label: Text("Valor da Última Leitura"),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isBandeiraAmerela,
                        onChanged: (value) {
                          setState(() {
                            isBandeiraAmerela = !isBandeiraAmerela;
                          });
                        },
                      ),
                      const Text("Bandeira Amarela?"),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isBandeiraVermelha,
                        onChanged: (value) {
                          setState(() {
                            isBandeiraVermelha = !isBandeiraVermelha;
                          });
                        },
                      ),
                      const Text("Bandeira Vermelha?"),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isTenPercentOthers,
                        onChanged: (value) {
                          setState(() {
                            isTenPercentOthers = !isTenPercentOthers;
                          });
                        },
                      ),
                      const Text("Adicionar 5% de outra taxas?"),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => onSubmit(),
                    child: const Text("Tudo certo!"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSubmit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setDouble("TUSD", double.parse(_tsudController.text));
    prefs.setDouble("TE", double.parse(_teController.text));
    prefs.setDouble("LAST_NUMBER", double.parse(_lastNumberController.text));
    prefs.setBool("YELLOW_FLAG", isBandeiraAmerela);
    prefs.setBool("RED_FLAG", isBandeiraVermelha);
    prefs.setBool("TEN_PERCENT", isTenPercentOthers);

    Navigator.pushReplacementNamed(context, "home");
  }

  void getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getKeys().isNotEmpty) {
      setState(() {
        _tsudController.text = prefs.getDouble("TUSD")!.toString();
        _teController.text = prefs.getDouble("TE")!.toString();
        _lastNumberController.text = prefs.getDouble("LAST_NUMBER")!.toString();
        isBandeiraAmerela = prefs.getBool("YELLOW_FLAG")!;
        isBandeiraVermelha = prefs.getBool("RED_FLAG")!;
        isTenPercentOthers = prefs.getBool("TEN_PERCENT")!;
      });
    }
  }
}
