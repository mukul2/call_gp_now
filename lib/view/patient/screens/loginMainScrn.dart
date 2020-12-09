import 'package:call_gp_now/models/login_response.dart';
import 'package:call_gp_now/networking/ApiProvider.dart';
import 'package:call_gp_now/streams/AuthControllerStream.dart';
import 'package:call_gp_now/utils/commonWidgets.dart';
import 'package:call_gp_now/utils/mySharedPreffManager.dart';
import 'package:call_gp_now/view/login_view.dart';
import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';






void showThisToast(String s) {
  Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}