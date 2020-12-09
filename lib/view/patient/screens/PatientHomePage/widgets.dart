import 'dart:convert';

import 'package:call_gp_now/streams/AuthControllerStream.dart';
import 'package:call_gp_now/view/patient/patient_view.dart';
import 'package:call_gp_now/view/patient/screens/PatientHomePage/widget_appointments.dart';
import 'package:call_gp_now/view/patient/screens/PatientHomePage/widget_blog.dart';
import 'package:call_gp_now/view/patient/screens/PatientHomePage/widget_home.dart';
import 'package:call_gp_now/view/patient/screens/PatientHomePage/widget_notice.dart';
import 'package:call_gp_now/view/patient/screens/PatientHomePage/widget_profile.dart';
import 'package:call_gp_now/view/patient/screens/PatientHomePage/widget_search_only.dart';
import 'package:call_gp_now/view/patient/screens/PatientHomePage/widget_search_use_case_two.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
final String _baseUrl = "https://appointmentbd.com/api/";
final String _baseUrl_image = "https://appointmentbd.com/";
var OWN_PHOTO;
String AUTH_KEY;
String A_KEY;
String UPHOTO;
String UEMAIL;
String UID;
String UNAME;
String UPHONE;
var PARTNER_PHOTO;
PageController pageController = PageController(
  initialPage: 0,
  keepPage: true,
);

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

class HomeViewPager extends StatefulWidget {
  @override
  _HomeViewPagerState createState() => _HomeViewPagerState();
}

class _HomeViewPagerState extends State<HomeViewPager> {
  List _titles = ["Home", "Notifications", "Profile", "Appointments", "Blog"];
  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: new Icon(
            Icons.home,
            color: Colors.blue,
          ),
          title: new Text(
            'Home',
            style: TextStyle(color: Colors.blue),
          )),
      BottomNavigationBarItem(
        icon: new Icon(
          Icons.notification_important,
          color: Colors.blue,
        ),
        title: new Text(
          'Notification',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.supervised_user_circle,
            color: Colors.blue,
          ),
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.blue),
          )),
      BottomNavigationBarItem(
        icon: new Icon(
          Icons.calendar_today,
          color: Colors.blue,
        ),
        title: new Text(
          'Appointment',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.book,
            color: Colors.blue,
          ),
          title: Text(
            'Blog',
            style: TextStyle(color: Colors.blue),
          ))
    ];
  }
  int bottomSelectedIndex = 0;
  int _page = 0;
  Widget buildPageView() {




    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
        //showThisToast("changed now to " + index.toString());
      },
      children: <Widget>[
        Home(),
        Home(),
        Home(),
        Home(),
        Home(),
        //   ProjNotification(),
        //  Profile(),
        //  Appointment(),
        //  BlogActivityWithState(),
      ],
    );
  }

  void pageChanged(int index) {
    //CurvedNavigationBarState navBarState = _bottomNavigationKey.currentState;
    //navBarState.setPage(index);
    setState(() {
      bottomSelectedIndex = index;
      _page = index;
    });
    //showThisToast("changed to " + index.toString());
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: AppBar(
          title: Text(
            _titles[bottomSelectedIndex],
            style: TextStyle(color: Colors.white),
          ),
          // backgroundColor: Colors.white,
          elevation: 10,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.message,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(useThisContext,
                MaterialPageRoute(builder: (context) => ChatListActivity()));
          },
        ),
        drawer: myDrawer(),
        body: buildPageView(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: bottomTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
                icon: new Icon(
                  Icons.home,
                  color: bottomSelectedIndex == 0 ? Colors.orange : Colors.grey,
                ),
                title: new Text(
                  'Home',
                  style: TextStyle(color: Colors.blue),
                )),
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.notification_important,
                color: bottomSelectedIndex == 1 ? Colors.orange : Colors.grey,
              ),
              title: new Text(
                'Notification',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.supervised_user_circle,
                  color: bottomSelectedIndex == 2 ? Colors.orange : Colors.grey,
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(color: Colors.blue),
                )),
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.calendar_today,
                color: bottomSelectedIndex == 3 ? Colors.orange : Colors.grey,
              ),
              title: new Text(
                'Appointment',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.book,
                  color: bottomSelectedIndex == 4 ? Colors.orange : Colors.grey,
                ),
                title: Text(
                  'Blog',
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        ));
  }
}

//new

class PatientAPPNew extends StatefulWidget {
  //this is the main wid for patient ui
  int  bottomSelectedIndex =0;
  // This widget is the root of your application.
  @override
  _PatientAPPNewState createState() => _PatientAPPNewState();
}

class _PatientAPPNewState extends State<PatientAPPNew> {

 void pageChanged(int index) {
   //CurvedNavigationBarState navBarState = _bottomNavigationKey.currentState;
   //navBarState.setPage(index);
   setState(() {
    widget. bottomSelectedIndex = index;

   });
   //showThisToast("changed to " + index.toString());
 }

 void bottomTapped(int index) {
   setState(() {
     widget. bottomSelectedIndex = index;
     pageController.animateToPage(index,
         duration: Duration(milliseconds: 500), curve: Curves.ease);
   });
 }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillpop() {
      // Navigator.of(context).pop(true);
      // showThisToast("backpressed");

      return Future.value(false);
    }

    return WillPopScope(
      onWillPop: _onWillpop,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(fontFamily: 'Poppins'),
        home: Scaffold(
         drawer: Drawer(
           // Add a ListView to the drawer. This ensures the user can scroll
           // through the options in the drawer if there isn't enough vertical
           // space to fit everything.
           child: ListView(
             // Important: Remove any padding from the ListView.
             padding: EdgeInsets.zero,
             children: <Widget>[
               Container(
                 color: tColor,
                 child: Center(
                   child: Column(
                     children: <Widget>[
                       Padding(
                           padding: EdgeInsets.fromLTRB(0, 50, 0, 5),
                           child: CircleAvatar(
                             radius: 50,
                             backgroundImage: NetworkImage(_baseUrl_image + ""),
                           )),
                       showDisplayUserName(),
                     ],
                   ),
                 ),
               ),
               ListTile(
                 leading: SizedBox(
                   height: 25,
                   width: 25,
                   child: Image.asset("assets/logo2.jpeg"),
                 ),
                 title: Text('Website'),
                 onTap: () {
                   const url = "https://abettahealth.com/";

                   launch(url);
                   //Share.share("https://www.facebook.com");
                 },
               ),
               ListTile(
                 leading: SizedBox(
                   height: 25,
                   width: 25,
                   child: Image.asset("assets/facebook.png"),
                 ),
                 title: Text('Facebook'),
                 onTap: () {
                   const url =
                       "https://web.facebook.com/Betta-Health-112876333823426/";

                   launch(url);
                   //Share.share("https://www.facebook.com");
                 },
               ),
               ListTile(
                 leading: SizedBox(
                   height: 25,
                   width: 25,
                   child: Image.asset("assets/twitter.png"),
                 ),
                 title: Text('Twitter'),
                 onTap: () {
                   const url = "https://twitter.com/HealthBetta";

                   launch(url);
                   // Share.share("https://www.twitter.com");
                 },
               ),
               ListTile(
                 leading: SizedBox(
                   height: 25,
                   width: 25,
                   child: Image.asset("assets/info.png"),
                 ),
                 title: Text('Privacy Policy'),
                 onTap: () {
                   const url = "https://abettahealth.com/privacy-policy/";

                   launch(url);
                   // Share.share("https://www.twitter.com");
                 },
               ),
               ListTile(
                 leading: SizedBox(
                   height: 25,
                   width: 25,
                   child: Image.asset("assets/logout.png"),
                 ),
                 title: Text('Logout'),
                 onTap: () {
                   UserAuthStream.getInstanceNoCheck().signOut();
                   //showThisToast("me ??");
                   //setLoginStatus(false);
                   //runApp(LoginUI());
                  // UserAuthStream.getInstance().signOut();
                 },
               ),
               ListTile(
                 leading: SizedBox(
                   height: 25,
                   width: 25,
                   child: Image.asset("assets/logout.png"),
                 ),
                 title: Text('MOVE TO DOC'),
                 onTap: () {
                   //setLoginStatus(false);
                   //runApp(LoginUI());
                   UserAuthStream.getInstance().changeUserTYPE("d");
                 },
               ),
             ],
           ),
         ) ,
          appBar: AppBar(title: Text("Home"),),
          body: PageView(
            controller: pageController,
            onPageChanged: (index) {
              pageChanged(index);
              //showThisToast("changed now to " + index.toString());
            },
            children: <Widget>[
              //Home(),
              //openHomeWidget(),

              DoctorSearchActivityNew(),
              DoctorSearchActivityUseCaseTwo(),

              //NoticeListWidget(),
              //Profile(),
              Appointment(),
              //BlogActivityWithState(),
              //   ProjNotification(),
                Profile(),
              //  Appointment(),
              //  BlogActivityWithState(),
            ],
          ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex:widget. bottomSelectedIndex,
              onTap: bottomTapped,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                BottomNavigationBarItem(
                    icon: new Icon(
                      Icons.home,
                      color:widget. bottomSelectedIndex == 0 ? Colors.orange : Colors.grey,
                    ),
                    title: new Text(
                      'Home',
                      style: TextStyle(color: Colors.blue),
                    )),
                BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.notification_important,
                    color: widget.bottomSelectedIndex == 1 ? Colors.orange : Colors.grey,
                  ),
                  title: new Text(
                    'Notification',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.supervised_user_circle,
                      color: widget.bottomSelectedIndex == 2 ? Colors.orange : Colors.grey,
                    ),
                    title: Text(
                      'Profile',
                      style: TextStyle(color: Colors.blue),
                    )),
                BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.calendar_today,
                    color: widget.bottomSelectedIndex == 3 ? Colors.orange : Colors.grey,
                  ),
                  title: new Text(
                    'Appointment',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.book,
                      color: widget.bottomSelectedIndex == 4 ? Colors.orange : Colors.grey,
                    ),
                    title: Text(
                      'Blog',
                      style: TextStyle(color: Colors.blue),
                    ))
              ],
            )
        ),


      ),
    );
  }
int homeWidCount = 0 ;
 Widget openHomeWidget() {
   if(homeWidCount ==0){
     print("hitting home wid");
     homeWidCount++;
     return  Home();
   }else {
     return Center(
       child: Text("STOP"),
     );
   }

  }
}

showDisplayUserName(){
  return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 25),
      child: new Center(
        child: Text(
          "Demo Name",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      ));
}



