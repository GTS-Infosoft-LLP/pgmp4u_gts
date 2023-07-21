import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/courseProvider.dart';
import '../provider/profileProvider.dart';
import '../subscriptionModel.dart';
import '../tool/ShapeClipper.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  @override
  void initState() {
    ProfileProvider pp = Provider.of(context, listen: false);
    pp.setSelectedContainer(3);
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
          child: Container(
            width: MediaQuery.of(context).size.width * .9,
            height: 50,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 87, 101, 222),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Center(
                child: Text(
              "Subscribe Now",
              style: TextStyle(color: Colors.white, fontFamily: 'Roboto Bold', fontSize: 20),
            )),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: <Widget>[
            ClipPath(
              clipper: ShapeClipper(),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                ),
              ),
            ),
            Consumer<CourseProvider>(builder: (context, cp, child) {
              return Container(
                padding: EdgeInsets.fromLTRB(40, 50, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(color: Colors.white, width: 1)),
                        child: Center(
                            child: IconButton(
                                icon: Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () {
                                  Navigator.pop(context);
                                }))),
                    SizedBox(width: 20),
                    Center(
                        child: Container(
                      width: MediaQuery.of(context).size.width * .65,
                      child: Text(
                        "Subscription",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontFamily: "Roboto Regular",
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                  ],
                ),
              );
            }),
          ]),
          SizedBox(
            height: 15,
          ),
          Consumer<ProfileProvider>(builder: (context, pp, child) {
            return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 20),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(permiumbutton.length, (i) {
                          return Expanded(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: InkWell(
                              onTap: () {
                                print("index val===$i");

                                pp.setSelectedContainer(i);
                              },
                              child: Container(
                                height: 175,
                                width: MediaQuery.of(context).size.width * .40,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(2, 2),
                                      // blurRadius: 12,
                                      color: Colors.grey.shade600,
                                      // blurRadius: 15.0,
                                      blurRadius: pp.selectedSubsBox == i ? 4.0 : 0.0,
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Color.fromARGB(255, 108, 120, 225),
                                    width: 4,
                                  ),
                                  color: pp.selectedSubsBox == i ? Color.fromARGB(255, 108, 120, 225) : Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      permiumbutton[i].name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Roboto Bold',
                                          fontSize: 22,
                                          color: pp.selectedSubsBox == i
                                              ? Colors.white
                                              : Color.fromARGB(255, 87, 101, 222),
                                          letterSpacing: 0.3),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '5 books',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Roboto Bold',
                                          fontSize: 18,
                                          color: pp.selectedSubsBox == i
                                              ? Colors.white
                                              : Color.fromARGB(255, 87, 101, 222),
                                          letterSpacing: 0.3),
                                    ),
                                    new Spacer(),
                                    Text(
                                      permiumbutton[i].amount,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Roboto Bold',
                                          fontSize: 18,
                                          color: pp.selectedSubsBox == i
                                              ? Colors.white
                                              : Color.fromARGB(255, 87, 101, 222),
                                          letterSpacing: 0.3),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ));
                        }))
                  ],
                ));
          })
        ])));
  }
}
