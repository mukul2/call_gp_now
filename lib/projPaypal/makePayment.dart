import 'package:call_gp_now/networking/ApiProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'PaypalPayment.dart';

class makePayment extends StatefulWidget {

  @override
  _makePaymentState createState() => _makePaymentState();
}

class _makePaymentState extends State<makePayment> {

  TextStyle style = TextStyle(fontFamily: 'Open Sans', fontSize: 15.0);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
          backgroundColor: Colors.transparent,
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(45.0),
            child: new AppBar(
              backgroundColor: Colors.white,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Paypal Payment Example',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.red[900],
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Open Sans'),
                  ),
                ],
              ),
            ),
          ),
          body:Container(
              width: MediaQuery.of(context).size.width,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: (){

                        // make PayPal payment
                        fun(ss){

                        }

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => PaypalPayment("","","",

                             fun,
                            ),
                          ),
                        );


                      },
                      child: Text('Pay with Paypal', textAlign: TextAlign.center,),
                    ),

                  ],
                ),
              )
          ),
        )
    );
  }

}