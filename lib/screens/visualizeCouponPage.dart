import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
import 'package:login_flow/utils/utils.dart';
import 'package:random_string/random_string.dart';

class VisualizeCouponScreen extends StatefulWidget {
  const VisualizeCouponScreen({Key? key, required this.day, required this.month}) : super(key: key);
  
  static const route = '/visualizeCoupon';
  final int day;
  final int month;

  @override
  _VisualizeCouponScreenState createState() => _VisualizeCouponScreenState();
}

class _VisualizeCouponScreenState extends State<VisualizeCouponScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FlutterTicketWidget(
          width: 350.0,
          height: 500.0,
          isCornerRounded: true,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                    'Your Ticket',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                
                 Column(
                    children: <Widget>[
                      ticketDetailsWidget(
                          'Week', '${widget.day}/${widget.month}/${DateTime.now().year}', '', '${computeEndOfWeek(widget.day, widget.month).day}/${computeEndOfWeek(widget.day, widget.month).month}/${DateTime.now().year}'),
    
                    ],
                  ),
                
                SizedBox(
                        height: 150,
                        width: 150,
                        child: Image.asset('assets/images/pomodoro_felice.png',
                            fit: BoxFit.cover, scale: 10),
                      ),
                
                SizedBox(
                        height: 100,
                        width: 300,
                        child: Image.asset('assets/images/barcode.png',
                            fit: BoxFit.cover, scale: 10),
                      ),
                
                  Text('Code: ${randomAlphaNumeric(8)}', style: TextStyle(
                              //color: Colors.green,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                              fontSize: 20
                              )),
                
                
                ElevatedButton(onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
              
                     },
                     style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.green),
                                    ),
                     child: Icon(Icons.done))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ticketDetailsWidget(String firstTitle, String firstDesc,
      String secondTitle, String secondDesc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                firstTitle,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  firstDesc,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                secondTitle,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  secondDesc,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}