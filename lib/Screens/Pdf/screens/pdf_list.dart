import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/Pdf/controller/pdf_controller.dart';
import 'package:pgmp4u/Screens/Pdf/model/pdf_list_model.dart';

import 'package:pgmp4u/Screens/Pdf/screens/pdfViewer.dart';
import 'package:pgmp4u/utils/app_color.dart';
import 'package:provider/provider.dart';

class PdfList extends StatefulWidget {
  const PdfList({Key key}) : super(key: key);

  @override
  State<PdfList> createState() => _PdfListState();
}

class _PdfListState extends State<PdfList> {
  @override
  void initState() {
    super.initState();

    context.read<PdfProvider>().getPdfList();
  }

  @override
  Widget build(BuildContext context) {
    List<PdfModel> pdfList = context.watch<PdfProvider>().pdfList;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 254, 254, 254),
      body: Column(
        children: [
          _appBar(),
          context.watch<PdfProvider>().isPdfListLoading
              ? Expanded(child: Center(child: CircularProgressIndicator.adaptive()))
              : pdfList.length == 0
                  ? Expanded(child: Center(child: Text('No Data Found')))
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: pdfList.length,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) {
                        return _pdfListTile(pdfList[index], index);
                      }),
        ],
      ),
    );
  }

  Widget _pdfListTile(PdfModel pdfModel, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfViewer(pdfModel: pdfModel),
                ));
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            decoration: BoxDecoration(
              // color: Color.fromARGB(255, 233, 230, 230),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    // color: index % 2 == 0 ? AppColor.purpule : AppColor.green,
                    gradient: index % 2 == 0 ? AppColor.purpleGradient : AppColor.greenGradient,
                    // gradient: LinearGradient(
                    //     begin: Alignment.topLeft,
                    //     end: Alignment.bottomRight,
                    //     colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                  ),
                  child: Center(
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white,
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  pdfModel.title ?? "",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Container _appBar() {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(16.0), bottomLeft: Radius.circular(16.0)),
        gradient: LinearGradient(
            colors: [
              Color(0xff4B5BE2),
              Color(0xff2135D9),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Text(
                "Pdfs",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontFamily: 'Roboto Medium', color: Colors.white),
              ),
            ),
            SizedBox(width: 34),
          ],
        ),
      ),
    );
  }
}
