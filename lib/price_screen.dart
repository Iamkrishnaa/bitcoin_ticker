import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = "USD";
  String _btcValue = "?";
  String _ethValue = "?";
  String _ltcvalue = "?";

  bool isLoading = true;

  DropdownButton getAndroidDropdown() {
    List<DropdownMenuItem<String>> currenciesDropDownItems = [];
    for (String currency in currenciesList) {
      currenciesDropDownItems.add(DropdownMenuItem<String>(
        child: Text(currency),
        value: currency,
      ));
    }
    return DropdownButton(
      isExpanded: true,
      items: currenciesDropDownItems,
      value: selectedCurrency,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          updateCurrency();
        });
      },
    );
  }

  CupertinoPicker getIOSDropdown() {
    List<Text> currencies = [];

    for (String currency in currenciesList) {
      currencies.add(Text(
        currency,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      looping: true,
      itemExtent: 32.0,
      onSelectedItemChanged: (value) {
        setState(() {
          selectedCurrency = currenciesList[value];

          updateCurrency();
        });
      },
      children: currencies,
    );
  }

  getCoinValue(String crypto) {
    if (crypto == cryptoList[0]) {
      return _btcValue;
    }
    if (crypto == cryptoList[1]) {
      return _ethValue;
    }
    if (crypto == cryptoList[2]) {
      return _ltcvalue;
    }

    return "?";
  }

  void updateCurrency() async {
    isLoading = true;
    CoinData coins = CoinData();
    var currency = selectedCurrency;
    String btc = await coins.fetchCoinData(currency, cryptoList[0]);
    String eth = await coins.fetchCoinData(currency, cryptoList[1]);
    String ltc = await coins.fetchCoinData(currency, cryptoList[2]);

    setState(() {
      if (btc != null && eth != null && ltc != null) {
        _btcValue = btc;
        _ethValue = eth;
        _ltcvalue = ltc;
        isLoading = false;
      } else {
        _btcValue = "...";
        _ethValue = "...";
        _ltcvalue = "...";
      }
    });
  }

  handleLoader() {}

  @override
  void initState() {
    super.initState();
    updateCurrency();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          isLoading
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(),
          Expanded(
            child: ListView.builder(
              itemCount: cryptoList.length,
              itemBuilder: (context, index) {
                String crypto = cryptoList[index];
                String coinValue = getCoinValue(crypto);
                return Padding(
                  padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                  child: Card(
                    color: Colors.lightBlueAccent,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 28.0),
                      child: Text(
                        '1 $crypto = $coinValue $selectedCurrency',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS
                ? getIOSDropdown()
                : Container(
                    width: 150,
                    padding: const EdgeInsets.all(8.0),
                    child: getAndroidDropdown(),
                  ),
          ),
        ],
      ),
    );
  }
}
