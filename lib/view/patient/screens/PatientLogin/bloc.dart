import 'package:call_gp_now/models/login_response.dart';
import 'package:call_gp_now/networking/ApiProvider.dart';
import 'package:call_gp_now/streams/AuthControllerStream.dart';
import 'package:call_gp_now/utils/mySharedPreffManager.dart';
import 'package:call_gp_now/view/patient/screens/DoctorLogin/stream.dart';
import 'package:call_gp_now/view/patient/screens/DoctorLogin/ui.dart';
import 'package:call_gp_now/view/patient/screens/PatientLogin/stream.dart';
import 'package:call_gp_now/view/patient/screens/PatientLogin/ui.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Block {
  static Block block;

  clickedLogin(BuildContext context, String email, String password,String type) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {

     // Navigator.of(context).pop();
      //UserAuthStream.getInstanceNoCheck().loginProcessing();
      //update screen aout the process
      PatientLoginStream.getInstance().loginProcessing();
      LoginResponse loginResponse = await performLogin(email, password);
      //print(loginResponse.toString());
      //  showThisToast(loginResponse.message);

      //  showThisToast(loginResponse.toString());

      if (loginResponse != null && loginResponse.status) {
        //show login update status
        setLoginStatus(true);
        // AUTH_KEY = "Bearer " + loginResponse.accessToken;
        USER_ID = loginResponse.userInfo.id.toString();
        setUserType(loginResponse.userInfo.userType);

        Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
        SharedPreferences prefs = await _prefs;
        prefs.setString("uid", loginResponse.userInfo.id.toString());
        prefs.setString("uname", loginResponse.userInfo.name.toString());
        prefs.setString("uphone", loginResponse.userInfo.phone.toString());
        prefs.setString("uphoto", loginResponse.userInfo.photo.toString());
        prefs.setString("uemail", loginResponse.userInfo.email.toString());
        prefs.setString("utype", loginResponse.userInfo.userType.toString());
        prefs.setString(
            "udes", loginResponse.userInfo.designationTitle.toString());
        prefs.setString("auth", "Bearer " + loginResponse.accessToken);
        prefs.setBool("isLoggedIn", true);

        if (loginResponse.userInfo.userType.contains("d")) {
          DOC_HOME_VISIT = loginResponse.userInfo.home_visits;
          DoctorLoginStream.getInstance().signIn(loginResponse.userInfo.userType.toString());
        } else if (loginResponse.userInfo.userType.contains("p")) {
          PatientLoginStream.getInstance().signIn(loginResponse.userInfo.userType.toString());
        } else {
          //unknwon user
          // showThisToast("Unknown user");
        }
      } else {
        if(type=="p"){
          PatientLoginStream.getInstance().loginFailed();
        }else {
          DoctorLoginStream.getInstance().loginFailed();
        }


        //show login failed with worng pass

        //  showThisToast(loginResponse.message);
      }
    });
  }

  clickedImDoctor(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => NewDoctorLoginForm()));
    });
  }

  static Block getInstance() {
    if (block == null) {
      block = new Block();

      return block;
    } else {
      return block;
    }
  }
}
