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
  final TextEditingController _datumController = TextEditingController();
  final TextEditingController _tachometrController = TextEditingController();
  final TextEditingController _mnozstviPalivaController = TextEditingController();
  final TextEditingController _cenaZaLitrController = TextEditingController();
  final TextEditingController _poznamkyController = TextEditingController();

  final List<Map<String, dynamic>> _entries = [];

  void _addEntry() {
    final datum = _datumController.text;
    final tachometr = double.tryParse(_tachometrController.text);
    final mnozstviPaliva = double.tryParse(_mnozstviPalivaController.text);
    final cenaZaLitr = double.tryParse(_cenaZaLitrController.text);
    final poznamky = _poznamkyController.text;

    if (datum.isNotEmpty && tachometr != null && mnozstviPaliva != null && cenaZaLitr != null) {
      setState(() {
        _entries.add({
          'datum': datum,
          'tachometr': tachometr,
          'mnozstviPaliva': mnozstviPaliva,
          'cenaZaLitr': cenaZaLitr,
          'poznamky': poznamky,
        });
      });
      _clearInputs();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vyplňte prosím všechna pole správně.'))
      );
    }
  }

  void _clearInputs() {
    _datumController.clear();
    _tachometrController.clear();
    _mnozstviPalivaController.clear();
    _cenaZaLitrController.clear();
    _poznamkyController.clear();
  }

  double _calculateAverageConsumption() {
    if (_entries.length < 2) return 0;

    double totalDistance = 0;
    double totalFuel = 0;

    for (int i = 1; i < _entries.length; i++) {
      totalDistance += _entries[i]['tachometr'] - _entries[i - 1]['tachometr'];
      totalFuel += _entries[i]['mnozstviPaliva'];
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
            TextField(
              controller: _datumController,
              decoration: InputDecoration(labelText: 'datum'),
            ),
            TextField(
              controller: _tachometrController,
              decoration: InputDecoration(labelText: 'tachometr (km)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _mnozstviPalivaController,
              decoration: InputDecoration(labelText: 'množství paliva (l)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _cenaZaLitrController,
              decoration: InputDecoration(labelText: 'Cena za litr'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _poznamkyController,
              decoration: InputDecoration(labelText: 'poznámky'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addEntry,
              child: Text('přidat'),
            ),
            SizedBox(height: 16),
            Text(
              'Průměrná spotřeba: ${_calculateAverageConsumption().toStringAsFixed(2)} l/100km',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  final entry = _entries[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('Datum: ${entry['datum']}'),
                      subtitle: Text(
                          'stav tachometru: ${entry['tachometr']} km \nmnožství paliva: ${entry['mnozstviPaliva']} L\n Cena: ${entry['cenaZaLitr']} per L \nPoznámky: ${entry['poznamky']}'),
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