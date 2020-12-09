//TabBarView
import 'package:call_gp_now/view/patient/patient_view.dart';
import 'package:flutter/material.dart';
final String _baseUrl = "https://appointmentbd.com/api/";
final String _baseUrl_image = "https://appointmentbd.com/";
class SimpleDocProfileActivity extends StatefulWidget {
  dynamic profileData;

  SimpleDocProfileActivity(this.profileData);

  @override
  _SimpleDocProfileActivityState createState() =>
      _SimpleDocProfileActivityState();
}

class _SimpleDocProfileActivityState extends State<SimpleDocProfileActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        //backgroundColor: Colors.white,
        elevation: 10,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        _baseUrl_image +
                                            widget.profileData["photo"],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.profileData["name"]
                                                .toString()
                                                .trim(),
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            widget
                                                .profileData["department_info"]
                                            ["name"],
                                            style: TextStyle(),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Video Call Fees",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      // child: Text(widget.profileData["video_appointment_rate"].toString() + " £", style: TextStyle(),),
                                      child: Text(
                                        "Free",
                                        style: TextStyle(),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  "Specialization",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                                child: Text(
                                  widget.profileData["designation_title"] ==
                                      null
                                      ? "No Information"
                                      : widget.profileData["designation_title"],
                                  style: TextStyle(),
                                ),
                              )
                            ],
                          ),
                        )),
                  )
                ],
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
                        builder: (context) =>
                            ChooseConsultationDateTimeActivity(
                                widget.profileData)));
              },
              child: Card(
                color: Colors.blue,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Text(
                      "Book Appointment",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}