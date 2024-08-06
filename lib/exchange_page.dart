import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExchangeRate extends StatefulWidget {
  @override
  _ExchangeRateState createState() => _ExchangeRateState();
}

class _ExchangeRateState extends State<ExchangeRate> {
  String baseCurrency = "USD";
  String targetCurrency = "CAD";
  double? exchangeRate;
  List<String> currencies = [];

  @override
  void initState() {
    super.initState();
    fetchCurrencies();
  }

  // Function to fetch the list of available currencies from the API
  Future<void> fetchCurrencies() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.exchangeratesapi.io/v1/latest?access_key=6e8202ba3b24f80931a9b44ba11a4a77'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          currencies = (data['rates'] as Map<String, dynamic>).keys.toList();
          exchangeRate = data['rates'][targetCurrency];
        });
      } else {
        print('Failed to load currencies');
      }
    } catch (error) {
      print('Error fetching the currencies: $error');
    }
  }

  // Function to fetch the exchange rate between the base and target currencies
  Future<void> fetchExchangeRate() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.exchangeratesapi.io/v1/latest?access_key=6e8202ba3b24f80931a9b44ba11a4a77&base=$baseCurrency'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          exchangeRate = data['rates'][targetCurrency];
        });
      } else {
        print('Failed to load exchange rate');
      }
    } catch (error) {
      print('Error fetching the exchange rate: $error');
    }
  }

  // Handler for changing the base currency
  void handleBaseCurrencyChange(String? value) {
    setState(() {
      baseCurrency = value!;
      fetchExchangeRate();
    });
  }

  // Handler for changing the target currency
  void handleTargetCurrencyChange(String? value) {
    setState(() {
      targetCurrency = value!;
      fetchExchangeRate();
    });
  }

  // Handler for swapping base and target currencies
  void swapCurrencies() {
    setState(() {
      String temp = baseCurrency;
      baseCurrency = targetCurrency;
      targetCurrency = temp;
      fetchExchangeRate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exchange Rate'),
        backgroundColor: Colors.blueGrey[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 56),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Base Currency'),
                value: baseCurrency,
                items: currencies.map((currency) {
                  return DropdownMenuItem<String>(
                    value: currency,
                    child: Text(currency),
                  );
                }).toList(),
                onChanged: handleBaseCurrencyChange,
              ),
            ),
            SizedBox(height: 36),
            IconButton(
              icon: Icon(
                Icons.swap_vert_outlined,
                size: 36,
                color: Colors.grey[600],
              ),
              onPressed: swapCurrencies,
            ),
            SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Target Currency'),
                value: targetCurrency,
                items: currencies.map((currency) {
                  return DropdownMenuItem<String>(
                    value: currency,
                    child: Text(currency),
                  );
                }).toList(),
                onChanged: handleTargetCurrencyChange,
              ),
            ),
            SizedBox(height: 32),
            exchangeRate != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '1 $baseCurrency = $exchangeRate $targetCurrency',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  )
                : CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
