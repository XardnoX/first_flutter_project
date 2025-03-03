import 'package:flutter/material.dart';

void main() {
  runApp(FuelTrackerApp());
}

class FuelTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuel Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FuelTrackerScreen(),
    );
  }
}

class FuelTrackerScreen extends StatefulWidget {
  @override
  _FuelTrackerScreenState createState() => _FuelTrackerScreenState();
}

class _FuelTrackerScreenState extends State<FuelTrackerScreen> {
//  final TextEditingController datumController = TextEditingController();
  final TextEditingController tachometrController = TextEditingController();
  final TextEditingController mnozstviPalivaController = TextEditingController();
  final TextEditingController cenaZaLitrController = TextEditingController();
  final TextEditingController poznamkyController = TextEditingController();

  final List<Map<String, dynamic>> entries = [];

  void addEntry() {
//  final datum = datumController.text;
    final tachometr = double.tryParse(tachometrController.text);
    final mnozstviPaliva = double.tryParse(mnozstviPalivaController.text);
    final cenaZaLitr = double.tryParse(cenaZaLitrController.text);
    final poznamky = poznamkyController.text;
    DateTime now = DateTime.now();
    DateTime datum = DateTime(now.year, now.month, now.day, now.hour);

    if (tachometr != null && mnozstviPaliva != null && cenaZaLitr != null) {
      setState(() {
        entries.add({
          'datum': datum,
          'tachometr': tachometr,
          'mnozstviPaliva': mnozstviPaliva,
          'cenaZaLitr': cenaZaLitr,
          'poznamky': poznamky,
        });
      });
      clearInputs();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vyplňte prosím všechna pole správně.'))
      );
    }
  }

  void clearInputs() {
//    datumController.clear();
    tachometrController.clear();
    mnozstviPalivaController.clear();
    cenaZaLitrController.clear();
    poznamkyController.clear();
  }


  double vypocetPrumerneSpotreby() {
    if (entries.length < 2) return 0;

    double totalDistance = 0;
    double totalFuel = 0;

    for (int i = 1; i < entries.length; i++) {
      totalDistance += entries[i]['tachometr'] - entries[i - 1]['tachometr'];
      totalFuel += entries[i]['mnozstviPaliva'];
    }

    return totalFuel > 0 ? (totalFuel / totalDistance) * 100 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tankování paliva do automobilu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
        /*    TextField(
              controller: datumController,
              decoration: InputDecoration(labelText: 'datum'),
            ),

         */

            TextField(
              controller: tachometrController,
              decoration: InputDecoration(labelText: 'tachometr (km)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: mnozstviPalivaController,
              decoration: InputDecoration(labelText: 'množství paliva (l)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: cenaZaLitrController,
              decoration: InputDecoration(labelText: 'Cena za litr'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: poznamkyController,
              decoration: InputDecoration(labelText: 'poznámky'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addEntry,
              child: Text('přidat'),
            ),
            SizedBox(height: 16),
            Text(
              'Průměrná spotřeba: ${vypocetPrumerneSpotreby().toStringAsFixed(2)} l/100km',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('Datum: ${entry['datum']}'),
                      subtitle: Text(
                          'stav tachometru: ${entry['tachometr']} km \nmnožství paliva: ${entry['mnozstviPaliva']} L\nCena: ${entry['cenaZaLitr']} za L \nCelková cena za tankování ${(entry['mnozstviPaliva'] * entry['cenaZaLitr'])} Kč\nPoznámky: ${entry['poznamky']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}