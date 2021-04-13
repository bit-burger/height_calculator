
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:basic_utils/basic_utils.dart';
import 'awesome_flutter_tonyversion.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Height Calculator',
      theme: ThemeData(
        primaryColor: secondColor,
        scaffoldBackgroundColor: firstColor,
        textTheme: TextTheme(),
        brightness: Brightness.dark,
      ),
      home: MyApp()));
}

const Color firstColor = Color(0xFFA2C2CF);
const Color secondColor = Color(0xFF8E867B);
const Color thirdColor = Color(0xFFD3B695);
const Color fourthColor = Color(0xFF895423);
const Color fifthColor = Color(0xFF402F1C);

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String myHeight;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nodeText1.addListener(() {
      setState(() {});
    });
  }

  String lastString = "";
  final TextEditingController _controller = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();

  String textFieldHeight() {

    String s = _controller.text;

    for (int i = 0;i<2;i++) {
      if (s.length<5) {
        s = StringUtils.addCharAtPosition(s, "0", 0);

      }
    }

    s = StringUtils.addCharAtPosition(s, ".", s.length-4);
    s = s.substring(0,s.length-2);
    return s+"m";

  }

  void whenFinished() {
    if (_controller.text.length > 0) {
      CustomBgAlertBox(
          context: context,
          title: "Your height is:",
          infoMessage: textFieldHeight(),
          icon: Icons.height,
          bgColor: secondColor,
          buttonColor: firstColor,
          buttonTextColor: secondColor,
          messageTextColor: fifthColor,

          titleTextColor: fifthColor);

    }
    _controller.text="";
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: kIsWeb? Colors.transparent : Color(0xFF49565B),
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
            focusNode: _nodeText1,
            displayDoneButton: !kIsWeb,
            onTapAction: whenFinished,

        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Height Calculator",
          style: TextStyle(color: fifthColor),
        ),
      ),
      body: KeyboardActions(
        config: _buildConfig(context),
        child: Center(
          child: Container(
            width: 220,
            child: TextField(


              controller: this._controller,
              focusNode: _nodeText1,
              onSubmitted: (String text) {

                whenFinished();

              },
              onChanged: (String text) {
                print(text);

                if (text[text.length - 1] == "c") {
                  print("delete");
                  text = text.substring(0, text.length - 2);
                }
                if (text.length > 5) {
                  text = lastString;
                }

                String newString = "";
                for (int i = 0; i < text.length; i++) {
                  String char = text[i];
                  if (StringUtils.isDigit(char)) {
                    newString += char;
                  }
                }
                if (newString.length == 0) {
                  _controller.text = "";
                } else {
                  _controller.text = newString + "cm";
                }
                lastString = _controller.text;
                _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: _controller.text.length));
                setState(() {});
              },
              obscureText: false,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: _nodeText1.hasFocus ? secondColor : fifthColor,
              ),
              decoration: InputDecoration(
                labelText: "Height in cm",
                labelStyle: TextStyle(
                  color: _nodeText1.hasFocus ? secondColor : fifthColor,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  borderSide: BorderSide(color: fifthColor, width: 3.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  borderSide: BorderSide(color: secondColor, width: 5.0),
                ),
              ),
              showCursor: false,
              keyboardType: TextInputType.number,
            ),
          ),
        ),
      ),
    );
  }
}
