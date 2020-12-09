import 'package:call_gp_now/models/login_response.dart';
import 'package:call_gp_now/networking/ApiProvider.dart';
import 'package:call_gp_now/streams/AuthControllerStream.dart';
import 'package:call_gp_now/utils/commonWidgets.dart';
import 'package:call_gp_now/utils/mySharedPreffManager.dart';
import 'package:call_gp_now/view/doctor/doctor_view.dart';
import 'package:call_gp_now/view/login_view.dart';
import 'package:call_gp_now/view/patient/screens/DoctorLogin/stream.dart';
import 'package:call_gp_now/view/patient/screens/DoctorLogin/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewDoctorLoginForm extends StatefulWidget {
  @override
  NewDoctorLoginFormstate createState() {
    return NewDoctorLoginFormstate();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class NewDoctorLoginFormstate extends State<NewDoctorLoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String email, password;
  String myMessage = "Submit";

  Widget StandbyWid = Text(
    "Login",
    style: TextStyle(color: Colors.white, fontSize: 18),
  );
  LoginResponse _loginResponse;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    FocusNode myFocusNode = new FocusNode();
    FocusNode myFocusNode2 = new FocusNode();
    return StreamBuilder<Status>(
        stream: DoctorLoginStream.getInstance().onAuthChanged,
        initialData: Status.initialStateDoctor,
        builder: (c, snapshot) {
          final state = snapshot.data;
          print("doc log some state came "+state.toString());
          if (state == Status.loadingDoctor) {
            return Scaffold(body: Center(child:CircularProgressIndicator(),),);
          } else if (state == Status.loginSuccessDoctor) {
            return DoctorAPP();
          } else if (state == Status.loginFailedDoctor) {
            return Scaffold(
              body: Center(child: InkWell(
                onTap: (){DoctorLoginStream.getInstance().tryAgain();},
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
          else if (state == Status.initialStateDoctor) {
            return  Scaffold(
              body: loginForm(_formKey,context,"d") ,
            );



            print("login");
          }

          return Scaffold(
            body: Center(child: Image.asset("assets/my_gp_logo.jpeg",height: 200,width: 200,),),
          );
        });
  }
}