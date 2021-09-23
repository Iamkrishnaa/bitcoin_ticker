import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const apiKey = "468C1890-6E90-4B3D-BDDF-EA202BAF8C8B";
const apiLink = "https://rest.coinapi.io/v1/exchangerate";

class CoinData {
  getCoinData(String currency, String coin) async {
    var url = "$apiLink/$coin/$currency?apikey=$apiKey";
    var response = await http.get(Uri.parse(url));
    var resData = response.body;
    return jsonDecode(resData);
  }

  fetchCoinData(String currency, String coin) async {
    var coinData = await getCoinData(currency, coin);

    double value = coinData['rate'];
    return value.toStringAsFixed(0);
  }
}
