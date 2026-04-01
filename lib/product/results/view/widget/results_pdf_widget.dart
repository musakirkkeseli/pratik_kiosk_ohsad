import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ResultsPdfWidget extends StatelessWidget {
  const ResultsPdfWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sonuçlar PDF Görüntüleyici")),
      body: SfPdfViewer.network(
        "http://213.74.160.54:8080/webservices/elab/pdf/5B5BCD67-5FE8-4682-8959-F1A31B52040B.pdf",
        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
          // setState(() {
          //   totalPages = details.pagesCount;
          //   if (totalPages == 1) {
          //     // If there's only one page, allow the button to be active.
          //     isAtBottom = true;
          //   }
          // });
        },
        onPageChanged: (PdfPageChangedDetails details) {
          // setState(() {
          //   currentPage = details.newPageNumber - 1;
          //   if (totalPages != null) {
          //     // Check if we're at the bottom of the document.
          //     isAtBottom = (currentPage ?? 0) >= (totalPages ?? 0) - 1;
          //   }
          // });
        },
      ),
    );
  }
}
