import 'package:flutter/material.dart';
import 'package:pgmp4u/provider/response_provider.dart';
import 'package:provider/provider.dart';

import '../../tool/ShapeClipper.dart';
import '../../utils/app_color.dart';
import '../../utils/app_textstyle.dart';

class FlashCardItem extends StatefulWidget {
  const FlashCardItem({Key key}) : super(key: key);

  @override
  State<FlashCardItem> createState() => _FlashCardItemState();
}

class _FlashCardItemState extends State<FlashCardItem> {
  Color _darkText = Color(0xff424b53);
  Color _lightText = Color(0xff989d9e);
  ResponseProvider responseProvider;

  @override
  void initState() {
    print(" init ");
    callCategoryApi();
    super.initState();
  }

  Future callCategoryApi() async {
    print(" api calling");
    responseProvider = Provider.of(context, listen: false);
    responseProvider.getcategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                              "Flash Card",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.bold),
                            )),
                          ],
                        ),
                      ),
                    ]),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "FlashCards4U",
                        style: TextStyle(
                            fontSize: 24,
                            color: _darkText,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.symmetric(
                                vertical: 0.5,
                              ),
                              child: Container(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: ListTile(
                                      leading: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: index % 2 == 0
                                                ? AppColor.purpule
                                                : AppColor.green,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Image.network(
                                                "http://18.119.55.81:3003/thumbnails/123456.png",
                                                color: Colors.white),
                                          )),
                                      title: Text(
                                        "Flash Card",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      subtitle: Text(
                                        "Data",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyle.titleTile,
                                      ))),
                            );
                          }),
                    )
                  ])))),
    );
  }
}
