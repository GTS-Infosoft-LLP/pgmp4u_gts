import 'package:flutter/material.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:pgmp4u/provider/response_provider.dart';
import 'package:provider/provider.dart';
import '../../tool/ShapeClipper.dart';

class FlashCardsPage extends StatefulWidget {
  String heding;
  FlashCardsPage({Key key, this.heding}) : super(key: key);
  @override
  _FlashCardsPageState createState() => _FlashCardsPageState();
}

class _FlashCardsPageState extends State<FlashCardsPage> {
  ResponseProvider responseProvider;
  int _selectedIndex = 0;
  int _cardCount = 0;
  int _totalCard = 5;
  Color _darkText = Color(0xff424b53);
  Color _lightText = Color(0xff989d9e);

  LinearGradient liGrdint;

  @override
  void initState() {
    print(" call init");
    print("this is the heading=====${widget.heding}");

    responseProvider = Provider.of(context, listen: false);
    CourseProvider courseProvider = Provider.of(context, listen: false);

    print("length of flash list ==>> ${courseProvider.FlashCards.length}");

    callCardDetailsApi();
    super.initState();
  }

  callCardDetailsApi() async {
    await responseProvider.getCardDetails();
  }

  @override
  Widget build(BuildContext context) {
    // List<Widget> titles = [

    //   FlashCard(
    //       title: "This is title",
    //       desc:
    //           '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas id odio velit. Fusce cursus, leo vitae interdum mollis, mi libero consequat turpis, in tempus leo nisi eget lorem. Sed vitae sodales augue. Vestibulum sed tempus eros. Suspendisse potenti. Maecenas et dapibus lorem, vel tincidunt justo. Nullam consequat dapibus leo, id scelerisque ante tincidunt in. Duis viverra lectus eget eros porta, ut placerat velit pretium. Proin at nibh ex. Nullam non.'''),
    //   FlashCard(
    //       title: "This is title",
    //       desc:
    //           '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus a ipsum sed purus pretium viverra. Nulla facilisi. Donec mauris ipsum, pellentesque ut sem in, accumsan elementum elit. Nunc mollis lacus.'''),
    //   FlashCard(
    //       title: "This is title",
    //       desc:
    //           '''Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, '''),
    //   FlashCard(
    //       title: "This is title",
    //       desc:
    //           '''Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy.''')
    // ];
    return Scaffold(
      // backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            color: Colors.grey[200],
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ClipPath(
                      clipper: ShapeClipper(),
                      // CardPageClipper(),
                      child: Container(
                        // height: MediaQuery.of(context).size.height*.25,
                        height: 150,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                        ),
                      ),
                    ),
                    Container(
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
                                  border: Border.all(
                                      color: Colors.white, width: 1)),
                              child: Center(
                                  child: IconButton(
                                      icon: Icon(Icons.arrow_back,
                                          color: Colors.white),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }))),
                          SizedBox(width: 20),
                          Center(
                              child: Text(
                            widget.heding,
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.bold),
                          )),
                        ],
                      ),
                    ),

                    // Center(
                    //   child: Container(
                    //     height: 350,
                    //     child: Swiper(

                    //                         layout: SwiperLayout.TINDER,

                    //                         itemWidth:
                    //                             MediaQuery.of(context).size.width,
                    //                         itemHeight: 600,
                    //                         viewportFraction: 0.9,
                    //                         itemCount: 3,
                    //                         itemBuilder: (context, index) {
                    //                           return Center(
                    //                             child: FlashCard(
                    //                                 title: "Hello",
                    //                                 desc: "Flutter"),
                    //                           );
                    //                         },

                    //     ),

                    //   ),
                    // )

                    // Consumer<ResponseProvider>(
                    //   builder: (context, resoponseProvider, child) {
                    //     return Container(
                    //       child: Padding(
                    //           padding: EdgeInsets.only(top: 100),
                    //           child: responseProvider.apiStatus
                    //               ? Container(
                    //                   margin: EdgeInsets.only(
                    //                       top: MediaQuery.of(context)
                    //                               .size
                    //                               .height *
                    //                           0.2),
                    //                   child: Center(
                    //                     child: CircularProgressIndicator
                    //                         .adaptive(),
                    //                   ),
                    //                 )
                    //               : responseProvider.cardDetails != null
                    //                   ? Swiper(
                    //                       layout: SwiperLayout.TINDER,
                    //                       itemWidth:
                    //                           MediaQuery.of(context).size.width,
                    //                       itemHeight: 600,
                    //                       viewportFraction: 0.9,
                    //                       itemBuilder: (BuildContext context,
                    //                           int index) {
                    //                         return FlashCard(
                    //                             title: responseProvider
                    //                                 .cardDetails
                    //                                 .cardDetailsList[index]
                    //                                 .title,
                    //                             desc: responseProvider
                    //                                 .cardDetails
                    //                                 .cardDetailsList[index]
                    //                                 .description);
                    //                       },
                    //                       itemCount: responseProvider
                    //                           .cardDetails
                    //                           .cardDetailsList
                    //                           .length,
                    //                       pagination: new SwiperPagination(
                    //                           margin:
                    //                               EdgeInsets.only(top: 600)),
                    //                     )
                    //                   : Center(
                    //                       child: Padding(
                    //                       padding:
                    //                           const EdgeInsets.only(top: 250),
                    //                       child: Text("No Data Found",
                    //                           style: TextStyle(fontWeight: FontWeight.bold,
                    //                               color: Colors.black,
                    //                               fontSize: 18)),
                    //                     ))),
                    //     );
                    //   },
                    // ),
                  ],
                ),

                Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Consumer<CourseProvider>(
                        builder: (context, CourseProvider, child) {
                      return CourseProvider.FlashCards.isNotEmpty
                          ? Center(
                              child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 8.0, top: 10),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * .75,
                                child: PageView.builder(
                                    itemCount: CourseProvider.FlashCards.length,
                                    itemBuilder: (context, index) {
                                      if (index % 4 == 0) {
                                        liGrdint = LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xffF3924D),
                                              Color(0xffECAB8E)
                                            ]);
                                      } else if (index % 3 == 0) {
                                        liGrdint = LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xff5082BC),
                                              Color(0xff8AA1C9)
                                            ]);
                                      } else if (index % 2 == 0) {
                                        liGrdint = LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xff8E8BE6),
                                              Color(0xffA8B1FC)
                                            ]);
                                      } else {
                                        liGrdint = LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xff4195B7),
                                              Color(0xff76ACC2)
                                            ]);
                                      }

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: liGrdint,

                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 5.0,
                                              ),
                                            ],

                                            // ,color: index % 2 == 0
                                            //     ? Color(0xff76ACC2)
                                            //     : Color(0xffA8B1FC),
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          height: 50,

                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Text(
                                                CourseProvider
                                                    .FlashCards[index].title,
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontFamily: "Roboto",
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12.0),
                                                child: Text(
                                                  CourseProvider
                                                      .FlashCards[index]
                                                      .description,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      fontFamily: "NunitoSans",
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // color: Colors.cyan,
                                        ),
                                      );
                                    }),
                              ),
                            ))
                          : Container(
                              height: MediaQuery.of(context).size.height * .85,
                              // color: Colors.grey[300],
                              child: Center(
                                  child: Text("No Data Found",
                                      style: TextStyle(
                                          color: _darkText,
                                          fontFamily: "NunitoSans",
                                          fontSize: 18))));
                    }),
                  ],
                )

                // Container(
                //   // height: 350,
                //   child: Swiper(

                //                       layout: SwiperLayout.TINDER,

                //                       itemWidth:
                //                           MediaQuery.of(context).size.width,
                //                       itemHeight: 600,
                //                       viewportFraction: 0.9,
                //                       itemCount: 3,
                //                       itemBuilder: (context, index) {
                //                         return Center(
                //                           child: FlashCard(
                //                               title: "Hello",
                //                               desc: "Flutter"),
                //                         );
                //                       },

                //   ),

                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FlashCard extends StatelessWidget {
  FlashCard({@required this.title, @required this.desc});

  final String title;
  final String desc;
  Color _darkText = Color(0xff424b53);
  Color _lightText = Color(0xff989d9e);
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.all(40),
        child: Container(
            height: 800,
            // width: 300,
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  )),
                  decoration: BoxDecoration(
                    color: Color(0xff72a258),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(desc,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: _darkText,
                          fontFamily: "NunitoSans",
                          fontSize: 18)),
                ),
              ],
            )));
  }
}
