// To parse this JSON data, do
//
//     final currencyConverter = currencyConverterFromJson(jsonString);

import 'dart:convert';

CurrencyConverter currencyConverterFromJson(String str) => CurrencyConverter.fromJson(json.decode(str));

String currencyConverterToJson(CurrencyConverter data) => json.encode(data.toJson());

class CurrencyConverter {
  CurrencyConverter({
    this.rates,
    this.base,
    this.date,
  });

  Map<String, double> rates;
  String base;
  DateTime date;

  factory CurrencyConverter.fromJson(Map<String, dynamic> json) => CurrencyConverter(
    rates: Map.from(json["rates"]).map((k, v) => MapEntry<String, double>(k, v.toDouble())),
    base: json["base"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "rates": Map.from(rates).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "base": base,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
  };
}
