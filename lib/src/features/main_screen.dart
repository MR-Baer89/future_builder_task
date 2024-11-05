import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _postalCodeController = TextEditingController();
  Future<String>? _cityFuture;

  @override
  void initState() {
    super.initState();
    _cityFuture = Future.value('Noch keine PLZ gesucht');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plz Suche'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: _postalCodeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Postleitzahl",
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _cityFuture = getCityFromZip(_postalCodeController.text);
                  });
                },
                child: const Text("Suche"),
              ),
              const SizedBox(height: 32),
              FutureBuilder<String>(
                future: _cityFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text(
                        'Fehler: Bitte gib eine gültige PLZ ein.');
                  } else if (snapshot.hasData &&
                      snapshot.data != 'Noch keine PLZ gesucht') {
                    return Text('${snapshot.data}');
                  } else {
                    return const Text('Noch keine PLZ gesucht');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _postalCodeController.dispose();
    super.dispose();
  }

  Future<String> getCityFromZip(String zip) async {
    await Future.delayed(const Duration(seconds: 3));

    switch (zip) {
      case "10115":
        return 'Berlin';
      case "20095":
        return 'Hamburg';
      case "80331":
        return 'München';
      case "50667":
        return 'Köln';
      case "60311":
      case "60313":
        return 'Frankfurt am Main';
      case "56244":
        return 'Freilingen';
      default:
        return 'Fehler: Bitte gib eine gültige PLZ ein.';
    }
  }
}
