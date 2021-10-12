import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Divider(
      height: 5.0,
      color: Colors.blueAccent,
      thickness: 2.0 ,
    );
  }
}