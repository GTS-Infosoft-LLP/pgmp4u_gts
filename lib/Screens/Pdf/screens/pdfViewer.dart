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
      appBar: AppBar(
        title: Text(widget.pdfModel.title),
      ),
      body: context.watch<PdfProvider>().isDetailsLoading
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : SfPdfViewer.network(
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
    );
  }
}
