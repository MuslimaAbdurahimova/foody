import 'package:flutter/material.dart';

class OnUnFocusTap extends StatelessWidget {
  final Widget child;
  const OnUnFocusTap({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus){
          currentFocus.unfocus();
        }
      },
      child: child,
    );
  }
}