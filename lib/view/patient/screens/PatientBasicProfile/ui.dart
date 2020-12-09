import 'dart:async';
import 'dart:convert';
import 'dart:io' show File, Platform;
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:call_gp_now/chat/model/chat_message.dart';
import 'package:call_gp_now/myCalling/call.dart';
import 'package:call_gp_now/projPaypal/config.dart';
import 'package:call_gp_now/streams/AuthControllerStream.dart';
import 'package:call_gp_now/utils/mySharedPreffManager.dart';
import 'package:call_gp_now/view/login_view.dart';
import 'package:call_gp_now/view/patient/counter_bloc.dart';
import 'package:call_gp_now/view/patient/screens/PatientBasicProfile/stream.dart';
import 'package:call_gp_now/view/patient/screens/PatientBasicProfile/widgets.dart';
import 'package:call_gp_now/view/patient/sharedActivitys.dart';
import 'package:call_gp_now/view/patient/sharedData.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:call_gp_now/chat/model/chat_screen.dart';
import 'package:call_gp_now/chat/model/root_page.dart';
import 'package:call_gp_now/chat/service/authentication.dart';
import 'package:call_gp_now/networking/ApiProvider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';


final String _baseUrl = "https://appointmentbd.com/api/";
final String _baseUrl_image = "https://appointmentbd.com/";
class BasicProfile extends StatefulWidget {


  @override
  _BasicProfileState createState() => _BasicProfileState();
}

class _BasicProfileState extends State<BasicProfile> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //this one is ok
    print("hitting streambuilder");
    return StreamBuilder<StatusModel>(
        stream: PatientProfileStream.getInstance().onDataChanged,
        initialData: StatusModel(Status.loading,null),
        builder: (c, snapshot) {
          StatusModel state = snapshot.data;
          print("patioent basic pro some state came "+state.status.toString());


            if (state.status == Status.done) {
              return ProfileBasicPatient(state);
            } else if (state.status == Status.loading) {
              return Scaffold(
                appBar: AppBar(),
                body: Center(child: Text("Please wait"),),
              );
            }





          return Scaffold(
            body: Center(child: Text("Please wait"),),
          );
          //return  MyHomePageP(title: 'Flutter Demo Home Page');
        });

    /*
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 10,
        title: Text("Profile Information"),
      ),
      body: ListView(
        children: <Widget>[
          Center(
              child: InkWell(
                onTap: () async {
                  var header = <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization':widget. prefs.getString("auth"),};
                  File image =
                  await ImagePicker.pickImage(source: ImageSource.gallery);
                  var stream =
                  new http.ByteStream(DelegatingStream.typed(image.openRead()));
                  var length = await image.length();

                  var uri = Uri.parse(_baseUrl + "update-user-info");

                  var request = new http.MultipartRequest("POST", uri);
                  var multipartFile = new http.MultipartFile(
                      'photo', stream, length,
                      filename: basename(image.path));
                  //contentType: new MediaType('image', 'png'));

                  request.files.add(multipartFile);
                  request.fields.addAll(<String, String>{'user_id': widget. prefs.getString("uid")});
                  request.headers.addAll(header);
                  //  showThisToast(AUTH_KEY + "/n" + UID);

                  var response = await request.send();

                  print(response.statusCode);
                  // showThisToast(response.statusCode.toString());

                  response.stream.transform(utf8.decoder).listen((value) {
                    //print(value);
                    //showThisToast(value);

                    var data = jsonDecode(value);
                    //showThisToast(data.t);
                    // showThisToast((data["photo"]).toString());
                    widget.   prefs.setString("uphoto",data["photo"].toString());
                    setState(() {
                     // user_picture = (data["photo"]).toString();
                     // UPHOTO = user_picture;
                    });
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        //  top: 0,bottom: 0,left: 0,right: 0,
                          child: CircleAvatar(
                            radius: 72,
                            backgroundColor: Colors.orange,
                          )),
                      Center(
                        // top: 0,bottom: 0,left: 0,right: 0,

                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(
                              _baseUrl_image +widget. prefs.getString("uphoto")),
                        ),
                      )
                    ],
                  ),
                ),
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 00),
            child: Card(
              elevation: 10,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      final _formKey = GlobalKey<FormState>();
                      String newName;
                      return showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Edit Display Name'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        TextFormField(
                                          initialValue: widget. prefs.getString("uname"),
                                          validator: (value) {
                                            newName = value;
                                            if (value.isEmpty) {
                                              return 'Please enter Display Name';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text('Update'),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    var status = updateDisplayName(
                                        AUTH_KEY, widget. prefs.getString("uid"), newName);
                                    USER_NAME = newName;

                                    widget.   prefs.setString("uname", newName);

                                    setState(() {

                                    });
                                    status.then(
                                            (value) =>
                                            Navigator.of(context).pop());
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    subtitle: Padding(
                      padding: EdgeInsets.fromLTRB(00, 00, 00, 00),
                      child: Text(widget. prefs.getString("uname")),
                    ),
                    title: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 00, 00, 00),
                          child: Text("Display Name"),
                        ),
                        Padding(
                          child: Text(
                            "EDIT",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          padding: EdgeInsets.fromLTRB(10, 00, 00, 00),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  ListTile(
                    subtitle: Padding(
                      padding: EdgeInsets.fromLTRB(00, 00, 00, 00),
                      child: Text(widget. prefs.getString("uphone")),
                    ),
                    title: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 00, 00, 00),
                          child: Text("Phone"),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  ListTile(
                    subtitle: Padding(
                      padding: EdgeInsets.fromLTRB(00, 00, 00, 00),
                      child: Text(widget. prefs.getString("uemail")),
                    ),
                    title: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 00, 00, 00),
                          child: Text("Email"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

     */
  }
}

