import 'package:call_gp_now/main.dart';
import 'package:call_gp_now/models/login_response.dart';
import 'package:call_gp_now/networking/ApiProvider.dart';
import 'package:call_gp_now/streams/AuthControllerStream.dart';
import 'package:call_gp_now/utils/commonWidgets.dart';
import 'package:call_gp_now/utils/mySharedPreffManager.dart';
import 'package:call_gp_now/view/doctor/doctor_view.dart';
import 'package:call_gp_now/view/login_view.dart';
import 'package:call_gp_now/view/patient/patient_view.dart';
import 'package:call_gp_now/view/patient/screens/PatientHomePage/ui.dart';
import 'package:call_gp_now/view/patient/screens/PatientHomePage/widgets.dart';
import 'package:call_gp_now/view/patient/screens/PatientLogin/bloc.dart';
import 'package:call_gp_now/view/patient/screens/PatientLogin/stream.dart';
import 'package:call_gp_now/view/patient/screens/PatientLogin/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewPatientLoginForm extends StatefulWidget {
  @override
  NewPatientLoginFormtate createState() {
    return NewPatientLoginFormtate();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class NewPatientLoginFormtate extends State<NewPatientLoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.


  bool _isUsernameValid = true;
  bool _isPasswordValid = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   // widget._passwordControllerP = TextEditingController();
  }
  final _formKey = GlobalKey<FormState>();
  String email, password;
  String myMessage = "Submit";




  LoginResponse _loginResponse;
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    FocusNode myFocusNode = new FocusNode();
    FocusNode myFocusNode2 = new FocusNode();

    return StreamBuilder<Status>(
        stream: PatientLoginStream.getInstance().onAuthChanged,
        initialData: Status.initialStatePatient,
        builder: (c, snapshot) {
          final state = snapshot.data;
          print("some state came  patient login "+state.toString());
          if (state == Status.loadingPatient) {
            return Scaffold(body: Center(child:CircularProgressIndicator(),),);
          } else if (state == Status.loginSuccessPatient) {
            return PatientAPP();
          }else if (state == Status.guestPatient) {
            return PatientAPP();
          }else if (state == Status.signedOut) {
            return MyApp();
          }
          else if (state == Status.loginFailedPatient) {
              return Scaffold(
              body: Center(child: InkWell(
                onTap: (){PatientLoginStream.getInstance().tryAgain();},
                child: Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Wrong Email/Password.Try again",style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),),
            );
          }
          else if (state == Status.initialStatePatient) {
            return  Scaffold(
              body: loginForm(_formKey,context,"p") ,
            );



            print("login");
          }

          return Scaffold(
            body: Center(child: Image.asset("assets/my_gp_logo.jpeg",height: 200,width: 200,),),
          );
        });

    return Scaffold(
      body: loginForm(_formKey,context,"p") ,
    );




  }
}