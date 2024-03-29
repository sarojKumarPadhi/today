import 'package:ehs_new/utils/AppConstant.dart';
import 'package:ehs_new/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../Utils/Session.dart';
import '../Utils/String.dart';

Widget text(
    String text, {
      var fontSize = textSizeLargeMedium,
      Color? textColor,
      var fontFamily,
      var isCentered = false,
      var maxLine = 1,
      var latterSpacing = 0.5,
      bool textAllCaps = false,
      var isLongText = false,
      bool lineThrough = false,
    }) {
  return Text(
    textAllCaps ? text.toUpperCase() : text,
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontFamily: fontFamily ?? null,
      fontSize: fontSize,
      color: textColor,
      height: 1.5,
      letterSpacing: latterSpacing,
      decoration: lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
    ),
  );
}

Widget dynamicText(
    String text, {
      var fontSize = textSizeSMedium,
      Color? textColor,
      var fontFamily,
      var isCentered = false,
      var maxLine = 2,
      var latterSpacing = 0.5,
      bool textAllCaps = false,
      var isLongText = false,
      bool lineThrough = false,
    }) {
  return Expanded(
    child: Text(
      textAllCaps ? text.toUpperCase() : text,
      textAlign: isCentered ? TextAlign.center : TextAlign.start,
      maxLines: isLongText ? null : maxLine,
      /*overflow: TextOverflow.clip,*/
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: textSizeSMedium,
        color: textColor,
        height: 1.5,
        letterSpacing: latterSpacing,
        decoration: lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
      ),
    ),
  );
}

Widget dynamicTextbox(double height, TextEditingController controller, bool _enabled){
  return Container(
    height: height,
    margin: const EdgeInsets.only(bottom: 15, top: 10),
      decoration: boxDecoration(
          showShadow: false,
          bgColor: ehs_white,
          radius: 4,
          color: dynamicTextBorderColor),
      padding: EdgeInsets.all(0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              enabled: _enabled,
              onChanged: (text){
                print('First text field: $text');
              },
              controller: controller,
              onEditingComplete: (){
              },
              keyboardType: TextInputType.text,
              style: TextStyle(
                  fontSize: textSizeSMedium,
                  fontFamily: 'Inter'),
              decoration: InputDecoration(
                counterText: "",
                contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
               /* hintText: Ehs_hint_user_name,*/
                hintStyle: TextStyle(
                    color: hintColor,
                    fontSize: textSizeMedium),
                border: InputBorder.none,
              ),
              validator: (val) => validateUserName(
                  val!,
                  USER_REQUIRED
              ),
              onSaved: (String? value){
                print(value);
              },
            ),
          )
        ],
      ));
}


Function(BuildContext, String) placeholderWidgetFn() => (_, s) => placeholderWidget();

Widget placeholderWidget() => Image.asset('images/LikeButton/image/grey.jpg', fit: BoxFit.cover);

BoxDecoration boxDecoration({double radius = 2, Color color = Colors.transparent, Color? bgColor, var showShadow = false}) {
  return BoxDecoration(
    color: bgColor,
    boxShadow: showShadow ? defaultBoxShadow(shadowColor: shadowColorGlobal) : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

Widget indicator({required bool isActive}) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 150),
    margin: EdgeInsets.symmetric(horizontal: 4.0),
    height: isActive ? 6.0 : 4.0,
    width: isActive ? 6.0 : 4.0,
    decoration: BoxDecoration(
      color: isActive ? headerColor : Color(0xFF929794),
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
  );
}

class QIBusAppButton extends StatefulWidget {
  var textContent;
  VoidCallback onPressed;
  QIBusAppButton({required this.textContent, required this.onPressed});

  @override
  State<StatefulWidget> createState() {
    return QIBusAppButtonState();
  }
}

class QIBusAppButtonState extends State<QIBusAppButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          padding: const EdgeInsets.all(0.0),
        ),
        child: Container(
          width: 250,
          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: headerColor),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.textContent,
                style: TextStyle(fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ));
  }

  @override
  State<StatefulWidget>? createState() {
    // TODO: implement createState
    return null;
  }

}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
            margin: const EdgeInsets.only(left: 7),
            child: const Text("Please wait.....")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showSuccessDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        Container(
            margin: const EdgeInsets.only(left: 7),
            child: const Text("Successfully Saved....")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

