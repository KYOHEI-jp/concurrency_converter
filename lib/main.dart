import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
// 入力された金額を保持する変数
  double _amount = 0;

// コンボボックスで選択された通貨の種類を保持する変数
  String? _currency = 'JPY';

// 両替された円の金額を保持する変数
  double _result = 0;

// 為替レートを取得するAPIのURL
  String _apiUrl = 'https://api.exchangerate-api.com/v4/latest/JPY';

// 計算ボタンが押されたときの処理
  void _calculate() async {
// 入力された金額を取得する
    double amount = _amount;

// コンボボックスで選択された通貨の種類を取得する
    String? currency = _currency;

    var uri = Uri.parse(_apiUrl);

// APIを使って、為替レートを取得する
    var response = await http.get(uri);

// APIから返されたJSONをパースする
    Map<String, dynamic> data = json.decode(response.body);

// 為替レートを取得する
    double rate = data['rates'][currency];

// 入力された金額を円に両替する
    double result = amount * rate;

// 両替された円の金額を保存する
    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _amount = double.parse(value);
                });
              },
              decoration: InputDecoration(labelText: '円を入力', prefixText: '¥'),
            ),
            SizedBox(height: 80),
            DropdownButton(
              value: _currency,
              items: [
                DropdownMenuItem(
                  value: 'AED',
                  child: Text('AED - UAEディルハム'),
                ),
                DropdownMenuItem(
                  value: 'THB',
                  child: Text('THB - タイバーツ'),
                ),
                DropdownMenuItem(
                  value: 'IDR',
                  child: Text('IDR - インドネシアルピー'),
                ),
                DropdownMenuItem(
                  value: 'MYR',
                  child: Text('MYR - マレーシアリンギット'),
                ),
                DropdownMenuItem(
                  value: 'PHP',
                  child: Text('フィリピン・ペソ'),
                ),
                DropdownMenuItem(
                  value: 'SGD',
                  child: Text('シンガポール・ドル'),
                ),
                DropdownMenuItem(
                  value: 'JPY',
                  child: Text(
                    'JPY - 日本円（選べません）',
                    style: TextStyle(backgroundColor: Colors.grey),
                  ),
                  enabled: false,
                ),
                DropdownMenuItem(
                  value: 'NZD',
                  child: Text('NZD - ニュージーランドドル'),
                ),
                DropdownMenuItem(
                  value: 'VND',
                  child: Text('VND - ベトナムドン'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _currency = value;
                });
              },
            ),
            SizedBox(height: 80),
            ElevatedButton(
              child: Text('Calculate'),
              onPressed: _calculate,
            ),
            SizedBox(height: 8),
            Text('換算の結果: $_currencyで$_resultです'),
          ],
        ),
      ),
    );
  }
}
