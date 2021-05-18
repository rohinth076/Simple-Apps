import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  TextEditingController inputController = TextEditingController();
  TextEditingController outputController = TextEditingController();
  String s = '';

  void solve(String e) {
    Parser p = Parser();
    Expression exp = p.parse(e);
    ContextModel cm = ContextModel();
    outputController.text = '${exp.evaluate(EvaluationType.REAL, cm)}';
  }

  bool validate(String ch, [bool flag = false]) {
    s = inputController.text;
    s = s.replaceAll("x", "*");
    s = s.replaceAll("÷", "/");
    if (s.isEmpty && flag) {
      outputController.text = '';
      return true;
    }
    try {
      solve(s + ch);
    } catch (e) {
      try {
        solve(s);
      } catch (ei) {
        if (flag) {
          solve(s.substring(0, s.length - 1));
        }
        return false;
      }
    }
    return true;
  }

  void result() {
     inputController.text  = outputController.text;
     outputController.text = '';
  }

  void insert(String c) {
    if (c.compareTo("C") == 0) {
      inputController.text = outputController.text = "";
    } else if (c.compareTo("=") == 0) {
      result();
    } else {
      if (inputController.text.length <= 16) {
        if (validate(c))
          setState(() => {inputController.text = inputController.text + c});
      }
    }
  }

  Expanded newButton(String symbol, [Color c = Colors.black]) {
    return Expanded(
        child: TextButton(
      child: Text(symbol),
      style: TextButton.styleFrom(
          primary: c,
          textStyle: TextStyle(
            fontSize: 29,
          )),
      onPressed: (() => {
            insert(
              symbol,
            )
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Container(
            child: Row(
              children: [
                Icon(
                  Icons.calculate_outlined,
                ),
                Text(
                  ' Calculator',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          backgroundColor: Colors.cyan,
        ),
        body: Material(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  height: 100,
                ),
                Row(
                  children: [
                    Container(
                      width: 320,
                      child: TextField(
                        textAlign: TextAlign.right,
                        controller: inputController,
                        enabled: false,
                        style: TextStyle(
                          fontSize: 30,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      width: 320,
                      child: TextField(
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                        controller: outputController,
                        enabled: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 70,
                ),
                Row(
                  children: [
                    newButton('C'),
                    Expanded(
                      child: TextButton.icon(
                        label: Text(''),
                        icon: Icon(
                          Icons.backspace_outlined,
                          color: Colors.black,
                        ),
                        style: TextButton.styleFrom(
                            textStyle: TextStyle(
                          fontSize: 25,
                        )),
                        onPressed: (() => {
                              s = inputController.text,
                              if (s.isNotEmpty)
                                {
                                  setState(() => {
                                        inputController.text =
                                            s.substring(0, s.length - 1),
                                        validate('', true),
                                      }),
                                }
                            }),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 50,
                    ),
                    newButton('÷', Colors.blue),
                  ],
                ),
                Container(
                  height: 10,
                ),
                Row(
                  children: [
                    newButton("7"),
                    newButton("8"),
                    newButton('9'),
                    newButton('x', Colors.blue),
                  ],
                ),
                Container(
                  height: 10,
                ),
                Row(
                  children: [
                    newButton("4"),
                    newButton("5"),
                    newButton('6'),
                    newButton('-', Colors.blue),
                  ],
                ),
                Container(
                  height: 10,
                ),
                Row(
                  children: [
                    newButton("1"),
                    newButton("2"),
                    newButton('3'),
                    newButton('+', Colors.blue),
                  ],
                ),
                Container(
                  height: 10,
                ),
                Row(
                  children: [
                    newButton("0"),
                    newButton("00"),
                    newButton('.'),
                    newButton('=', Colors.blue),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
