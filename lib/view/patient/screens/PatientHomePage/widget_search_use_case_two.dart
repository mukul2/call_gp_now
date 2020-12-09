import 'dart:convert';

import 'package:call_gp_now/cachedData.dart';
import 'package:call_gp_now/chat/model/chat_screen.dart';
import 'package:call_gp_now/view/patient/OnlineDoctorsList.dart';
import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DoctorSearchActivityUseCaseTwo extends StatefulWidget {
  List downloadedData = [];
  List showData = [];
  List deptList = null;
  List lookingForList = [];
  int selectedPosition = -1;
  int typeSelectedPosition = 0;
  double boxHeight = 400 ;
  List chooseLocationObject =[];
  int selectedCoutry = -1 ;
  int selectedCity = -1 ;
  int selectedHospital = -1 ;
  String locationData ='[{"country":"United Kingdom","levels":[{"name":"First level 1","levels":["Second Level 1","Second Level 2"]},{"name":"First level 2","levels":["Second Level 1","Second Level 2"]},{"name":"First level 3","levels":["Second Level 1","Second Level 2"]}]},{"country":"United States","levels":[{"name":"First level 1","levels":["Second Level 1","Second Level 2"]},{"name":"First level 2","levels":["Second Level 1","Second Level 2"]},{"name":"First level 3","levels":["Second Level 1","Second Level 2"]}]}]';
  List country = [];
  bool _enabled2 = true;

  @override
  _DoctorSearchActivityUseCaseTwoState createState() =>
      _DoctorSearchActivityUseCaseTwoState();
}

class _DoctorSearchActivityUseCaseTwoState extends State<DoctorSearchActivityUseCaseTwo> {
  String key;

  getData() async {
    SharedPreferences prefs;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    prefs = await _prefs;
    final http.Response response = await http.post(
      "https://appointmentbd.com/api/" + 'doctor-search',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': prefs.getString("auth"),
      },
      // body: jsonEncode(<String, String>{'department_id': "17"}),
    );
    // showThisToast(response.statusCode.toString());

    setState(() {
      widget.downloadedData = json.decode(response.body);
      //showThisToast("doc size "+widget.downloadedData.length.toString());
      widget.showData.clear();
      widget.showData.addAll(widget.downloadedData);
    });

    //showThisToast(downloadedData.length.toString());
  }
  getCountryData() async {
    SharedPreferences prefs;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    prefs = await _prefs;
    final http.Response response = await http.post(
      "https://appointmentbd.com/api/" + 'country-list',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': prefs.getString("auth"),
      },
      // body: jsonEncode(<String, String>{'department_id': "17"}),
    );
    // showThisToast(response.statusCode.toString());

    setState(() {
      widget.downloadedData = json.decode(response.body);
      //showThisToast("doc size "+widget.downloadedData.length.toString());
      widget.showData.clear();
      widget.showData.addAll(widget.downloadedData);
    });

    //showThisToast(downloadedData.length.toString());
  }

  getDeptListData() async {
    SharedPreferences prefs;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    prefs = await _prefs;
    if (cachedDeptList == null) {
      print("api hit => " + "department-list");
      final http.Response response = await http.post(
        "https://appointmentbd.com/api/" + 'department-list',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': prefs.getString("auth"),
        },
      );
      setState(() {
        cachedDeptList = json.decode(response.body);
        widget.deptList = json.decode(response.body);
       // widget.deptList = widget.deptList.sublist(0, 10);
      });
    } else {
      setState(() {
        print("loaded from cache");
        widget.deptList = cachedDeptList;
       // widget.deptList = widget.deptList.sublist(0, 10);
      });
    }

    // data_ = json.decode(response.body);

    // showThisToast("dept size "+response.body);
  }
  void displayBottomSheet(BuildContext context, DoctorSearchActivityUseCaseTwo doctorSearchActivityUseCaseTwo) {
    setState(() {
      widget.chooseLocationObject = jsonDecode('[{"country":"United Kingdom","levels":[{"name":"First level 1","levels":["Second Level 1","Second Level 2"]},{"name":"First level 2","levels":["Second Level 1","Second Level 2"]},{"name":"First level 3","levels":["Second Level 1","Second Level 2"]}]},{"country":"United States","levels":[{"name":"First level 1","levels":["Second Level 1","Second Level 2"]},{"name":"First level 2","levels":["Second Level 1","Second Level 2"]},{"name":"First level 3","levels":["Second Level 1","Second Level 2"]}]}]');
    });
    //showThisToast(widget.chooseLocationObject.toString());
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(context).size.height  * 1,
            child: Scaffold(
              appBar: AppBar(backgroundColor: Colors.white,title: Text(widget.selectedCoutry.toString()+"Choose Country",style: TextStyle(color: Colors.black),),
                  iconTheme: IconThemeData(
                      color: Colors.black
                  ),),
              body: ListView.builder(
                itemCount:
                widget.chooseLocationObject == null ? 0 : widget.chooseLocationObject.length,
                itemBuilder: (BuildContext context, int index) {
                  return new InkWell(
                      onTap: () {

                        doctorSearchActivityUseCaseTwo.selectedCoutry=index;
                        showThisToast("clicked "+widget.selectedCoutry.toString());
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(0),
                          child: ListTile(
                           // trailing: Icon(Icons.done,color: widget.selectedCoutry==index?Colors.green:Colors.white,),
                            trailing:  doctorSearchActivityUseCaseTwo.selectedCoutry==index? Icon(Icons.done,color:Colors.green):Icon(Icons.done,color:Colors.white),

                            title: new Text(widget.selectedCoutry.toString()+" ="+widget.chooseLocationObject[index]["country"],
                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                            ),

                          ),
                        ),
                      ));
                },
              ),
            ),
          );
        });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getData();
    setState(() {
    /*  widget.lookingForList.add("GP");
      widget.lookingForList.add("Specialist");
      widget.lookingForList.add("Urgent Care");
      widget.lookingForList.add("Home Visit");

     */
      widget.chooseLocationObject =jsonDecode( widget.locationData);   // showThisToast("location object size "+widget.chooseLocationObject.length.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var _crossAxisSpacing = 8;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 3;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = 35;
    var _aspectRatio = _width / cellHeight;
    var _aspectRatio2 = _width / 45;
    setState(() {
      widget.lookingForList.clear();
      widget.lookingForList.add("GP");
      widget.lookingForList.add("Specialist");
      widget.lookingForList.add("Urgent Care");
      widget.lookingForList.add("Home Visit");
    });
    return Scaffold(
      backgroundColor: Colors.black12,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: widget.boxHeight,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Card(
                        color: Colors.white,
                        child: Container(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Im Looking for"),
                              widget.lookingForList!=null?
                                GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: _crossAxisCount,
                                      childAspectRatio: _aspectRatio2),
                                  shrinkWrap: true,
                                  itemCount:
                                  widget.lookingForList == null ? 0 : widget.lookingForList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new Padding(
                                      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                      child: Card(
                                        color: widget.typeSelectedPosition == index
                                            ? Colors.green
                                            : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              if(index==1){
                                                widget.boxHeight=450;
                                              }else{
                                                widget.boxHeight=400;
                                              }
                                              widget.typeSelectedPosition = index;
                                            });

                                            /*
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChooseDoctorOnline(
                                          (widget.deptList[index]["id"])
                                              .toString())));

                               */
                                          },
                                          child: Container(
                                            height: 25,
                                            child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(4),
                                                  child: new Text(
                                                    widget.lookingForList[index],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: widget.typeSelectedPosition == index
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ):CircularProgressIndicator(),
                                /*
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 2, 5, 2),
                                      child: Card(
                                        color: widget.typeSelectedPosition == 0
                                            ? Colors.green
                                            : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              widget.typeSelectedPosition = 0;
                                              widget.boxHeight = 350;
                                            });
        },
                                          child: Container(
                                            height: 25,
                                            child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                  child: new Text(
                                                    "General Practicians",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: widget.typeSelectedPosition== 0
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                      child: Card(
                                        color: widget.typeSelectedPosition == 1
                                            ? Colors.green
                                            : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              widget.typeSelectedPosition = 1;
                                              widget.boxHeight = 400;
                                            });
                                          },
                                          child: Container(
                                            height: 25,
                                            child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                                  child: new Text(
                                                    "Specialist",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: widget.typeSelectedPosition== 1
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                      child: Card(
                                        color: widget.typeSelectedPosition == 2
                                            ? Colors.green
                                            : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              widget.typeSelectedPosition = 2;
                                              widget.boxHeight = 400;
                                            });
                                          },
                                          child: Container(
                                            height: 25,
                                            child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                                  child: new Text(
                                                    "Urgent Care",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: widget.typeSelectedPosition== 2
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                      child: Card(
                                        color: widget.typeSelectedPosition == 3
                                            ? Colors.green
                                            : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              widget.typeSelectedPosition = 3;
                                              widget.boxHeight = 400;
                                            });
                                          },
                                          child: Container(
                                            height: 25,
                                            child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                                  child: new Text(
                                                    "Home Visit",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: widget.typeSelectedPosition== 3
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                 */



                                widget.typeSelectedPosition==1?Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    ),
                                    Text("Speciality or doctor"),
                                    Text(
                                      widget.selectedPosition != -1
                                          ? widget.deptList[widget.selectedPosition]
                                      ["name"]
                                          : "Tap to select speciality or doctor",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ):Container(
                                  height: 1,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                      child: Text("Prefered Location"),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          widget.chooseLocationObject =jsonDecode( widget.locationData);   // showThisToast("location object size "+widget.chooseLocationObject.length.toString());
                                          // showThisToast("location object size "+widget.chooseLocationObject.length.toString());
                                        });
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (ctx) {
                                              return Container(
                                                height: MediaQuery.of(context).size.height  * 1,
                                                child: Scaffold(
                                                  appBar: AppBar(backgroundColor: Colors.white,title: Text("Choose Country",style: TextStyle(color: Colors.black),),
                                                    iconTheme: IconThemeData(
                                                        color: Colors.black
                                                    ),),
                                                  body: ListView.builder(
                                                    itemCount:
                                                    widget.chooseLocationObject == null ? 0 : widget.chooseLocationObject.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return new InkWell(
                                                          onTap: () {

                                                            this.setState(() {
                                                              widget.selectedCoutry=index;
                                                              widget.selectedCity=-1;
                                                              widget.selectedHospital=-1;
                                                              Navigator.pop(context);
                                                            });
                                                            },
                                                          child: Card(
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(0.0),
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets.all(0),
                                                              child: ListTile(
                                                                // trailing: Icon(Icons.done,color: widget.selectedCoutry==index?Colors.green:Colors.white,),
                                                                trailing:  widget.selectedCoutry==index? Icon(Icons.done,color:Colors.green):Icon(Icons.done,color:Colors.white),

                                                                title: new Text(widget.chooseLocationObject[index]["country"],
                                                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                                                                ),

                                                              ),
                                                            ),
                                                          ));
                                                    },
                                                  ),
                                                ),
                                              );
                                            });
                                      },

                                      child: Card(
                                        elevation: 5,
                                        color: Color.fromARGB(255,248, 248, 248),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(03.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    Text(widget.selectedCoutry!=-1?widget.chooseLocationObject[widget.selectedCoutry]["country"]:"Choose", style: TextStyle(fontWeight: FontWeight.bold)),
                                                    Padding(
                                                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                      child: Icon(Icons.arrow_drop_down),
                                                    )
                                                  ],
                                                ),
                                              ), Align(
                                                alignment: Alignment.centerRight,
                                                child: Text("Country"),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          widget.chooseLocationObject =jsonDecode( widget.locationData);   // showThisToast("location object size "+widget.chooseLocationObject.length.toString());

                                          // showThisToast("location object size "+widget.chooseLocationObject.length.toString());
                                        });
                                        if(widget.selectedCoutry!=-1){
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (ctx) {
                                                return Container(
                                                  height: MediaQuery.of(context).size.height  * 1,
                                                  child: Scaffold(
                                                    appBar: AppBar(backgroundColor: Colors.white,title: Text("Choose City",style: TextStyle(color: Colors.black),),
                                                      iconTheme: IconThemeData(
                                                          color: Colors.black
                                                      ),),
                                                    body: ListView.builder(
                                                      itemCount:
                                                      widget.chooseLocationObject[widget.selectedCoutry]["levels"] == null ? 0 : widget.chooseLocationObject[widget.selectedCoutry]["levels"].length,
                                                      itemBuilder: (BuildContext context, int index) {
                                                        return new InkWell(
                                                            onTap: () {

                                                              this.setState(() {
                                                                widget.selectedCity=index;
                                                                widget.selectedHospital=-1;
                                                                Navigator.pop(context);
                                                              });
                                                            },
                                                            child: Card(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(0.0),
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets.all(0),
                                                                child: ListTile(
                                                                  // trailing: Icon(Icons.done,color: widget.selectedCoutry==index?Colors.green:Colors.white,),
                                                                  trailing:  widget.selectedCity==index? Icon(Icons.done,color:Colors.green):Icon(Icons.done,color:Colors.white),

                                                                  title: new Text(widget.chooseLocationObject[widget.selectedCoutry]["levels"][index]["name"],
                                                                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                                                                  ),

                                                                ),
                                                              ),
                                                            ));
                                                      },
                                                    ),
                                                  ),
                                                );
                                              });
                                        }else {
                                          showThisToast("Select Country First");
                                        }

                                      },
                                      child: Card(
                                        elevation: 5,
                                        color: Color.fromARGB(255,248, 248, 248),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(03.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    Text(widget.selectedCity!=-1?widget.chooseLocationObject[widget.selectedCoutry]["levels"][widget.selectedCity]["name"]:"Choose", style: TextStyle(fontWeight: FontWeight.bold)),
                                                    Padding(
                                                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                      child: Icon(Icons.arrow_drop_down),
                                                    )
                                                  ],
                                                ),
                                              ), Align(
                                                alignment: Alignment.centerRight,
                                                child: Text("City"),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          widget.chooseLocationObject =jsonDecode( widget.locationData);   // showThisToast("location object size "+widget.chooseLocationObject.length.toString());

                                          // showThisToast("location object size "+widget.chooseLocationObject.length.toString());
                                        });
                                        if(widget.selectedCity!=-1){
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (ctx) {
                                                return Container(
                                                  height: MediaQuery.of(context).size.height  * 1,
                                                  child: Scaffold(
                                                    appBar: AppBar(backgroundColor: Colors.white,title: Text("Choose Hospital",style: TextStyle(color: Colors.black),),
                                                      iconTheme: IconThemeData(
                                                          color: Colors.black
                                                      ),),
                                                    body: ListView.builder(
                                                      itemCount:
                                                      widget.chooseLocationObject[widget.selectedCoutry]["levels"][widget.selectedCity]["levels"] == null ? 0 : widget.chooseLocationObject[widget.selectedCoutry]["levels"][widget.selectedCity]["levels"] .length,
                                                      itemBuilder: (BuildContext context, int index) {
                                                        return new InkWell(
                                                            onTap: () {

                                                              this.setState(() {
                                                                widget.selectedHospital=index;
                                                                Navigator.pop(context);
                                                              });
                                                            },
                                                            child: Card(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(0.0),
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets.all(0),
                                                                child: ListTile(
                                                                  // trailing: Icon(Icons.done,color: widget.selectedCoutry==index?Colors.green:Colors.white,),
                                                                  trailing:  widget.selectedHospital==index? Icon(Icons.done,color:Colors.green):Icon(Icons.done,color:Colors.white),

                                                                  title: new Text(widget.chooseLocationObject[widget.selectedCoutry]["levels"][widget.selectedCity]["levels"][index],
                                                                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                                                                  ),

                                                                ),
                                                              ),
                                                            ));
                                                      },
                                                    ),
                                                  ),
                                                );
                                              });
                                        }else {
                                          showThisToast("Select City First");
                                        }

                                      },
                                      child: Card(
                                        elevation: 5,
                                        color: Color.fromARGB(255,248, 248, 248),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(03.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    Text(widget.selectedHospital!=-1?widget.chooseLocationObject[widget.selectedCoutry]["levels"][widget.selectedCity]["levels"][widget.selectedHospital]:"Choose", style: TextStyle(fontWeight: FontWeight.bold)),
                                                    Padding(
                                                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                      child: Icon(Icons.arrow_drop_down),
                                                    )
                                                  ],
                                                ),
                                              ), Align(
                                                alignment: Alignment.centerRight,
                                                child: Text("Hospital"),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChooseDoctorOnline(
                                    (widget.deptList[widget.selectedPosition]["id"]).toString())));
                      },
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Wrap(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Text(
                                  "FIND DOCTOR",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Icon(
                                Icons.arrow_right_alt,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            widget.typeSelectedPosition==1?Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text("Commonly Searched Specialities",
                      style: TextStyle(fontSize: 14)),
                  trailing: Text(
                    "More Specialities",
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: FutureBuilder(
                      future: getDeptListData(),
                      builder: (context, projectSnap) {
                        return widget.deptList!=null? GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _crossAxisCount,
                              childAspectRatio: _aspectRatio),
                          shrinkWrap: true,
                          itemCount:
                          widget.deptList == null ? 0 : widget.deptList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Padding(
                              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                              child: Card(
                                color: widget.selectedPosition == index
                                    ? Colors.green
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      widget.selectedPosition = index;
                                    });

                                    /*
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChooseDoctorOnline(
                                          (widget.deptList[index]["id"])
                                              .toString())));

                               */
                                  },
                                  child: Container(
                                    height: 25,
                                    child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(0),
                                          child: new Text(
                                            widget.deptList[index]["name"],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: widget.selectedPosition == index
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            );
                          },
                        ):Center(child: CircularProgressIndicator());
                      }),
                )
              ],
            ):Container(
              height: 1,
            ),

          ],
        ),
      ),
    );
  }
}
