import 'package:flutter/cupertino.dart';

class AppController extends ChangeNotifier{
  bool isVisibility = true;


  onChange(){
    isVisibility = !isVisibility;
    notifyListeners();
  }

}