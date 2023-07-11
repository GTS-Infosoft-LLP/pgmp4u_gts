import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:pgmp4u/Screens/Pdf/controller/pdf_controller.dart';
import 'package:pgmp4u/Screens/Pdf/model/pdf_list_model.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatefulWidget {
  PdfViewer({Key key, this.pdfModel}) : super(key: key);
  PdfModel pdfModel;

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  PdfViewerController pdfViewerController;

  @override
  void initState() {
    super.initState();
    pdfViewerController = PdfViewerController();
    context.read<PdfProvider>().getPdfDetails(context, widget.pdfModel.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _appBar(widget.pdfModel.title),
          context.watch<PdfProvider>().isDetailsLoading
              ? Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : Expanded(
                  child: SfPdfViewer.network(
                    context.read<PdfProvider>().pdf.ppt ?? '',
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
                ),
        ],
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
