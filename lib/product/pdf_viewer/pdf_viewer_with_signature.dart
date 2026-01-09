// import 'dart:io';
// import 'dart:typed_data';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:pdfx/pdfx.dart';
// import 'package:path_provider/path_provider.dart';
// // import 'package:http/http.dart' as http;

// import '../../features/utility/const/constant_color.dart';
// import '../../features/utility/const/constant_string.dart';
// import '../../features/utility/extension/text_theme_extension.dart';
// import 'view/widget/signature_view.dart';

// class PdfViewerWithSignature extends StatefulWidget {
//   final String pdfUrl;

//   const PdfViewerWithSignature({super.key, required this.pdfUrl});

//   @override
//   State<PdfViewerWithSignature> createState() => _PdfViewerWithSignatureState();
// }

// class _PdfViewerWithSignatureState extends State<PdfViewerWithSignature> {
//   PdfControllerPinch? pdfController;
//   bool isLoading = true;
//   bool hasError = false;
//   String? errorMessage;
//   Uint8List? signatureBytes;
//   int currentPage = 1;
//   int totalPages = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadPdf();
//   }

//   Future<void> _loadPdf() async {
//     try {
//       final dir = await getTemporaryDirectory();
//       final tempFile = File('${dir.path}/temp_document.pdf');
//       if (await tempFile.exists()) {
//         await tempFile.delete();
//       }

//       // PDF'i indir
//       final response = await Dio().get(widget.pdfUrl);

//       // HTTP hata kontrolü
//       if (response.statusCode != 200) {
//         throw Exception(
//           'PDF indirilemedi. HTTP Durum Kodu: ${response.statusCode}',
//         );
//       }

//       final bytes = response.data as Uint8List;

//       // Boş dosya kontrolü
//       if (bytes.isEmpty) {
//         throw Exception('PDF dosyası boş');
//       }

//       final file = File('${dir.path}/temp_document.pdf');
//       await file.writeAsBytes(bytes);

//       // PDF dokümanını aç ve doğrula
//       final document = await PdfDocument.openFile(file.path);

//       if (document.pagesCount == 0) {
//         throw Exception('PDF dosyası geçersiz veya sayfa içermiyor');
//       }

//       setState(() {
//         pdfController = PdfControllerPinch(
//           document: PdfDocument.openFile(file.path),
//         );
//         totalPages = document.pagesCount;
//         isLoading = false;
//         hasError = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         hasError = true;
//         errorMessage = e.toString();
//       });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('PDF yüklenirken hata oluştu: $e'),
//             backgroundColor: ConstColor.red,
//             duration: const Duration(seconds: 5),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _getSignature() async {
//     final signature = await showSignaturePopup(context);
//     if (signature != null) {
//       setState(() {
//         signatureBytes = signature;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     pdfController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('PDF Görüntüleyici'),
//         actions: [
//           if (pdfController != null && !hasError)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton.icon(
//                 onPressed: _getSignature,
//                 icon: const Icon(Icons.edit, color: ConstColor.white),
//                 label: Text(
//                   'İmza Al',
//                   style: context.whiteButtonText,
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Theme.of(context).primaryColor,
//                 ),
//               ),
//             ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : hasError
//           ? Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.error_outline,
//                       size: 80,
//                       color: ConstColor.red400,
//                     ),
//                     const SizedBox(height: 24),
//                     Text(
//                       ConstantString().errorOccurred,
//                       style: context.errorText.copyWith(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'PDF dosyası yüklenemedi veya geçersiz',
//                       style: context.dialogContentSecondary,
//                       textAlign: TextAlign.center,
//                     ),
//                     if (errorMessage != null) ...[
//                       const SizedBox(height: 12),
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: ConstColor.red50,
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: ConstColor.red200),
//                         ),
//                         child: Text(
//                           errorMessage!,
//                           style: context.errorText.copyWith(
//                             fontSize: 14,
//                             color: ConstColor.red900,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ],
//                     const SizedBox(height: 32),
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         setState(() {
//                           isLoading = true;
//                           hasError = false;
//                           errorMessage = null;
//                         });
//                         _loadPdf();
//                       },
//                       icon: const Icon(Icons.refresh),
//                       label: const Text('Tekrar Dene'),
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 32,
//                           vertical: 16,
//                         ),
//                         backgroundColor: Theme.of(context).primaryColor,
//                         foregroundColor: ConstColor.white,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     OutlinedButton.icon(
//                       onPressed: () => Navigator.of(context).pop(),
//                       icon: const Icon(Icons.arrow_back),
//                       label: const Text('Geri Dön'),
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 32,
//                           vertical: 16,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           : pdfController == null
//               ? Center(
//                   child: Text(
//                     ConstantString().errorOccurred,
//                     style: context.regularText18,
//                   ),
//                 )
//               : Stack(
//               children: [
//                 PdfViewPinch(
//                   controller: pdfController!,
//                   onPageChanged: (page) {
//                     setState(() {
//                       currentPage = page;
//                     });
//                   },
//                 ),
//                 if (signatureBytes != null && currentPage == totalPages)
//                   Positioned(
//                     bottom: 40,
//                     right: 40,
//                     child: Container(
//                       width: 120,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         color: ConstColor.white,
//                         border: Border.all(color: ConstColor.grey, width: 1),
//                         borderRadius: BorderRadius.circular(8),
//                         boxShadow: [
//                           BoxShadow(
//                             color: ConstColor.black.withOpacity(0.2),
//                             blurRadius: 8,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.memory(
//                           signatureBytes!,
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                     ),
//                   ),
//                 Positioned(
//                   bottom: 16,
//                   left: 16,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       color: ConstColor.black.withOpacity(0.6),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       '$currentPage / $totalPages',
//                       style: context.whiteButtonText.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
