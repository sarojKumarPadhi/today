import 'package:ehs_new/utils/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBtn extends StatelessWidget {
 final String title;
 final AnimationController btnCntrl;
 final Animation btnAnim;
 final VoidCallback onBtnSelected;

 const AppBtn(
      {required this.title, required this.btnCntrl, required this.btnAnim, required this.onBtnSelected})
      : super();

  Widget _buildBtnAnimation(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: CupertinoButton(
        child: Container(
          width: 250,
          height: 50,
          alignment: FractionalOffset.center,
          decoration: new BoxDecoration(
            color: headerColor,
            borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
          ),
          child: btnAnim.value < 307.0
              ? Text(title,
            textAlign: TextAlign.center,
            style: Theme
                .of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500, fontFamily: 'Inter', fontSize: 16))
            : new CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
        onPressed: (){
              onBtnSelected();
        },
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }


}