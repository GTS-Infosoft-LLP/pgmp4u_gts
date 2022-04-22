import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '../../tool/CardPageClipper.dart';

class FlashCardsPage extends StatefulWidget {
  @override
  _FlashCardsPageState createState() => _FlashCardsPageState();
}

class _FlashCardsPageState extends State<FlashCardsPage> {
  int _selectedIndex = 0;
  int _cardCount = 0;
  int _totalCard = 5;
  Color _darkText = Color(0xff424b53);
  Color _lightText = Color(0xff989d9e);

  @override
  Widget build(BuildContext context) {
    List<Widget> titles = [
      FlashCard(
          title: "This is title",
          desc:
              '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin ut leo non arcu porttitor molestie in quis nulla. Vivamus nunc sem, ultrices sit amet commodo eu, fringilla in nunc. Vivamus sed velit volutpat, convallis erat nec, efficitur sem. Duis facilisis.'''),
      FlashCard(
          title: "This is title",
          desc:
              '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas id odio velit. Fusce cursus, leo vitae interdum mollis, mi libero consequat turpis, in tempus leo nisi eget lorem. Sed vitae sodales augue. Vestibulum sed tempus eros. Suspendisse potenti. Maecenas et dapibus lorem, vel tincidunt justo. Nullam consequat dapibus leo, id scelerisque ante tincidunt in. Duis viverra lectus eget eros porta, ut placerat velit pretium. Proin at nibh ex. Nullam non.'''),
      FlashCard(
          title: "This is title",
          desc:
              '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus a ipsum sed purus pretium viverra. Nulla facilisi. Donec mauris ipsum, pellentesque ut sem in, accumsan elementum elit. Nunc mollis lacus.'''),
      FlashCard(
          title: "This is title",
          desc:
              '''Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, '''),
      FlashCard(
          title: "This is title",
          desc:
              '''Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy.''')
    ];
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ClipPath(
                      clipper: CardPageClipper(),
                      child: Container(
                        height: 740,
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
                            "Program Life Cycle",
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.bold),
                          )),
                        ],
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Swiper(
                          layout: SwiperLayout.TINDER,
                          itemWidth: MediaQuery.of(context).size.width,
                          itemHeight: 600,
                          viewportFraction: 0.9,
                          itemBuilder: (BuildContext context, int index) {
                            return titles[index];
                          },
                          itemCount: _totalCard,
                          pagination: new SwiperPagination(
                              margin: EdgeInsets.only(top: 600)),
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
                      style: TextStyle(
                          color: _darkText,
                          fontFamily: "NunitoSans",
                          fontSize: 18)),
                ),
              ],
            )));
  }
}
