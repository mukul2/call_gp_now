
import 'package:call_gp_now/view/patient/counter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DecrementButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final CounterBlock counterBlock = Provider.of<CounterBlock>(context);

    return FlatButton.icon(
      icon : Icon(Icons.add),
      onPressed: ()=>counterBlock.decrement(),
      label: Text("Minus"),);
  }

}