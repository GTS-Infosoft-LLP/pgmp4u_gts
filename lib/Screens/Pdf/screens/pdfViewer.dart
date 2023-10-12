import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../../Models/pptDetailsModel.dart';

class PdfViewer extends StatefulWidget {
  PdfViewer({Key key, this.pdfModel,this.pdfName}) : super(key: key);
  PPTDataDetails pdfModel;
  String pdfName;

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  PdfViewerController pdfViewerController;

  @override
  void initState() {
    super.initState();
    _setOrientation([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    pdfViewerController = PdfViewerController();
    // context.read<PdfProvider>().getPdfDetails(context, widget.pdfModel.id);
  }

  _setOrientation(List<DeviceOrientation> orientations) {
    SystemChrome.setPreferredOrientations(orientations);
  }

  @override
  void dispose() {
    super.dispose();
    _setOrientation([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.landscape ? _landscape() : _potrait();
        },
      ),
    );
  }

  _landscape() {
    return _pdfView();
  }

  Widget _potrait() {
    return Column(
      children: [
        _appBar(widget.pdfModel.title),
        Expanded(
          child: _pdfView(),
        ),
      ],
    );
  }

  SfPdfViewerTheme _pdfView() {
    return SfPdfViewerTheme(
      data: SfPdfViewerThemeData(
        backgroundColor: Colors.white,
      ),
      child: SfPdfViewer.network(
        widget.pdfModel.filename ?? widget.pdfName,
        key: _pdfViewerKey,
        controller: pdfViewerController,
        scrollDirection: PdfScrollDirection.horizontal,
        onDocumentLoadFailed: (details) {
          return GFToast.showToast(
            details.description,
            context,
            toastPosition: GFToastPosition.BOTTOM,
          );
        },
      ),
    );
  }


  

  Container _appBar(String title) {
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
                title,
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
