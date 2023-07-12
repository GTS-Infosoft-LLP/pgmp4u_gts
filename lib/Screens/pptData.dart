import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/courseProvider.dart';
import '../tool/ShapeClipper.dart';
import '../utils/app_color.dart';
import 'Pdf/screens/pdfViewer.dart';

class PPTData extends StatefulWidget {
  final title;
  PPTData({Key key, this.title}) : super(key: key);

  @override
  State<PPTData> createState() => _PPTDataState();
}

IconData icon1;
Color _darkText = Color(0xff424b53);
Color _lightText = Color(0xff989d9e);

class _PPTDataState extends State<PPTData> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                          // color: Colors.amber,
                          width: MediaQuery.of(context).size.width * .65,
                          child: Text(
                            cp.selectedCourseName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 22, color: Colors.white, fontFamily: "Roboto", fontWeight: FontWeight.bold),
                          ),
                        )),
                      ],
                    ),
                  );
                }),
              ]),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  widget.title,
                  style: TextStyle(fontSize: 24, color: _darkText, fontWeight: FontWeight.bold),
                ),
              ),
              Consumer<CourseProvider>(builder: (context, cp, child) {
                return cp.pptDataListApiCall
                    ? Center(child: CircularProgressIndicator.adaptive())
                    : Container(
                        height: MediaQuery.of(context).size.height * .70,
                        child: ListView.builder(
                            itemCount: cp.pptDataList.length,
                            itemBuilder: (context, index) {
                              return cp.pptDataList[index].filename == null || cp.pptDataList[index].filename.isEmpty
                                  ? SizedBox()
                                  : InkWell(
                                      onTap: () async {
                                        print("cp.pptCategoryList===========${cp.pptDataList[index].filename}");
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>PdfViewer( pdfModel: cp.pptDataList[index],)));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
                                          height: 70,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 0,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 4.0),
                                                child: Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: index % 2 == 0 ? AppColor.purpule : AppColor.green,

                                                      //     colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(17.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(80),
                                                        ),
                                                        child: Center(
                                                          child: Text('${index + 1}'),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "PPT",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 0,
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * .65,
                                                    child: Text(
                                                      cp.pptDataList[index].title,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                            }),
                      );
              })
            ],
          ),
        ),
      ),
    );
  }
}
