import 'package:call_gp_now/networking/ApiProvider.dart';
import 'package:call_gp_now/networking/Const.dart';
import 'package:call_gp_now/projPaypal/PaypalPayment.dart';
import 'package:call_gp_now/projPaypal/makePayment.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import '../login_view.dart';
import 'package:http/http.dart' as http;
List data;
String AUTH_KEY ;
class SubscriptionViewPatient extends StatefulWidget {

  SubscriptionViewPatient();

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<SubscriptionViewPatient> {


  Future<String> getData() async {
    final http.Response response = await http.post(
      "https://appointmentbd.com/api/" + 'get_subscription_list',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(
          <String, String>{'uid': USER_ID,'user_type': "patient"}),
    );

    this.setState(() {
      data = json.decode(response.body);
    });



    return "Success!";
  }

  @override
  void initState() async{
     this.getData();
     Future<SharedPreferences> _prefs =
     SharedPreferences.getInstance();
     SharedPreferences prefs;
     prefs = await _prefs;
     AUTH_KEY =  prefs.getString("auth");
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void pageChanged(int index) {
    setState(() {
      //bottomSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: new Text("Subscriptions"),

          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.work),
                text: "My Subscriptions",
              ),
              Tab(icon: Icon(Icons.pan_tool), text: "Get Subscription"),
            ],
          ),
        ),
        body: TabBarView(
          children: [MySubscription((data)), NewSubscription()],
        ),
      ),
    );
  }
}

Widget MySubscription(List data) {
  return new ListView.builder(
    itemCount: data == null ? 0 : data.length,

    itemBuilder: (BuildContext context, int index) {
      return new InkWell(
          onTap: (){
//            Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => OnlineDoctorList((data[index]["id"]).toString())));
          },
          child: Card(

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(00.0),
            ),
            child: ListTile(
              title: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: new Text(data[index]["dr_info"]["name"],
                  style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              subtitle:Padding(
                padding:  EdgeInsets.fromLTRB(10, 00, 0, 10),
                child: new Text((data[index]["number_of_months"]).toString()+" months",
                  style: TextStyle(fontWeight: FontWeight.bold),),
              ) ,

            ),
          ));
    },
  );
}
Widget NewSubscription() {

  return new Text("New Subscription");
}




//Widget tabBody(){
//  return
//}

//new SingleChildScrollView(
//child: Column(
//crossAxisAlignment: CrossAxisAlignment.center,
//children: <Widget>[
//CircleAvatar(
//radius: 70,
//backgroundImage: NetworkImage(
//"https://appointmentbd.com/" + widget.photo,
//)),
//Center(
//child: Padding(
//padding: EdgeInsets.all(10),
//child: Text(widget.designation_title),
//),
//
//),
//tabBody()
//
//
//],
//),
//)
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