import 'dart:convert';
import 'package:currencyconverterflutterapp/responsefiles/currencyresponse.dart';
import 'package:http/http.dart' as http;

class Apis {
  static final CURRENCY_LIST_API = "https://api.exchangeratesapi.io/latest";

  Future<CurrencyConverter> getCurrencyFromApi() async {
    final response = await http
        .get(CURRENCY_LIST_API);
    return CurrencyConverter.fromJson(json.decode(response.body));
  }
}


