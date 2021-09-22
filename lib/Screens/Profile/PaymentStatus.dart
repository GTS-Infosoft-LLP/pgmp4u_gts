import 'package:flutter/material.dart';

class PaymentStatus extends StatefulWidget {
  final status;

  PaymentStatus({this.status});

  @override
  _PaymentStatusState createState() => _PaymentStatusState(
        statusNew: this.status,
      );
}

class _PaymentStatusState extends State<PaymentStatus> {
  final statusNew;
  _PaymentStatusState({this.statusNew});
  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 25),
                child: statusNew == "success"
                    ? Image.asset('assets/succs.png')
                    : Image.asset('assets/succ.png')),
            Text(
              statusNew == "success" ? 'Payment Successful' : 'Payment Fail',
              style: TextStyle(
                fontFamily: 'Roboto Bold',
                fontSize: width * (32 / 420),
                color: _colorfromhex("#04AE0B"),
              ),
            ),
            Container(
              height: 2,
            ),
            Text(
              statusNew == "success"
                  ? 'You have unlocked unlimited access to mock test.'
                  : "Something went wrong!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto Regular',
                fontSize: width * (22 / 420),
                color: _colorfromhex("#ABAFD1"),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.only(left: 15, right: 15),
                height: 50,
                // alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: _colorfromhex("#3A47AD"),
                    borderRadius: BorderRadius.circular(30.0)),
                child: OutlinedButton(
                  onPressed: () => {
                    if (statusNew == "success")
                      {Navigator.of(context).pushNamed('/mock-test')}
                    else
                      {
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName('/payment'))
                      }
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                  ),
                  child: Text(
                    statusNew == "success" ? 'Access Mock Test' : "Try Again",
                    style: TextStyle(
                        fontFamily: 'Roboto Medium',
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: 0.3),
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
