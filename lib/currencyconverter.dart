import 'dart:math';

import 'package:currencyconverterflutterapp/responsefiles/currencyresponse.dart' as resp;
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'apis.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CurrencyConverter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CurrencyConverterState();
  }
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  Apis apis = Apis();
  var _formKey = GlobalKey<FormState>();

  var _progressBar = true;
  var _data = false;

  SharedPreferences sharedPref;

  DateTime firstDateTime = DateTime.now();

  TextEditingController baseCurrencyRateTextController = TextEditingController(text: '1');

  List<String> currencyList = List<String>();
  List<String> currencyRateList = List<String>();

  String baseCurName;

  double baseCurr;

  Map<String, double> currency = Map();

  @override
  void initState() {
    super.initState();
    initializeSharedPreference();
    getDataFromApi();
  }

  initializeSharedPreference() async {
    sharedPref = await SharedPreferences.getInstance();
    String tempFirstDateTime = (sharedPref.getString("dateTimeValue")) ?? DateTime.now().toString();
    baseCurr = (sharedPref.getDouble("changedBaseCurrencyValue")) ?? 1.0;
    baseCurrencyRateTextController.text = baseCurr.toString();
    firstDateTime =  (DateTime.parse(tempFirstDateTime));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: (_data == false) ? null : AppBar(title: getHeader()),
      body: AbsorbPointer(
        absorbing: _progressBar,
        child: Container(
          child: Stack(
            children: <Widget>[
              (_data == false)
                  ? Container(height: 10, width: 10)
                  : Form(
                key: _formKey,
                child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      getTextViewAndButton(),
                      Divider(thickness: 3, color: Colors.black,),
                      SizedBox(height: 10),
                      getCurrencyListView(),
                    ]),
              ),
              getProgressBar(_progressBar)
            ],
          ),
        ),
      ),
    );
  }

  getHeader(){
    return Container(
        padding: EdgeInsets.only(left: 15, right: 15),
      color: Colors.blue,
      child:Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(baseCurName, style: TextStyle(color: Colors.white, fontSize: 15)),
              Text(firstDateTime.toString().substring(0, 19), style: TextStyle(color: Colors.white, fontSize: 13),)
            ],
          ),
          Spacer(),
          MaterialButton(
            child: new Text(
              'Refresh',
            ),
              color: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11.0)),
            onPressed: () {
              setState(() {
                onTapRefreshButton();
              });
            },
          ),
        ],
      )
    );
  }

  getTextViewAndButton() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: TextFormField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: new TextStyle(
                fontFamily: 'Roboto',
                color: Colors.black,
                fontSize: 12,
              ),
              controller: baseCurrencyRateTextController,
              inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9]"))],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0.0),
                isDense: true,
                border: InputBorder.none,
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(7)),
            ),
          ),
          SizedBox(height: 10),
          MaterialButton(
            child: new Text(
              'Convert',
            ),
            color: Colors.grey.shade200,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11.0)),
            onPressed: () {
              setState(() {
                onTapConvertButton();
              });
            },
          ),
        ],
      ),
    );
  }

  getCurrencyListView() {
    return (_data == false)
        ? SizedBox()
        : Container(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: currency.length,
        itemBuilder: (context, index) {
          String key = currency.keys.elementAt(index);
          return Container(
            padding: EdgeInsets.only(bottom: 3),
            child: Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width/2.5),
                Text("$key : " + (dp(currency[key]*baseCurr, 4)).toString(), textAlign: TextAlign.start, style: new TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 14,
                )),
              ],
            ),
          );
        },
      ),
    );
  }

  getDataFromApi(){
    Future<resp.CurrencyConverter> map = apis.getCurrencyFromApi();
    map.then((value){
//      currencyList = value.rates.keys.toList();
//      print(currencyList);
      currency = value.rates;
      updateCurrencyRates();
      setState(() {
        baseCurName = value.base;
        _progressBar = false;
        _data = true;
      });

    });
  }

  void onTapRefreshButton() {
    sharedPref.setString("dateTimeValue", DateTime.now().toString());
    setState(() {
      firstDateTime = DateTime.now();
      _progressBar = true;
    });
    getDataFromApi();

  }

  void onTapConvertButton() {
    sharedPref.setDouble("changedBaseCurrencyValue", double.parse(baseCurrencyRateTextController.text));
    updateCurrencyRates();
  }

  updateCurrencyRates(){
    print(baseCurr);
    setState(() {
      baseCurr = double.parse(baseCurrencyRateTextController.text);
    });
  }

  double dp(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).roundToDouble() / mod);
  }

  getProgressBar(bool _progressBar) {
    return Visibility(
      visible: _progressBar,
      child: Center(
        child: Container(
          height: 70,
          width: 70,
          padding: EdgeInsets.all(15),
          child: Image.asset(
            "images/loading.gif",
          ),
        ),
      ),
    );
  }
}
