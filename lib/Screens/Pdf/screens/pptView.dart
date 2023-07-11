// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pgmp4u/Screens/Profile/ppt_view.dart';

// import 'dart:io';

// import 'package:power_file_view/power_file_view.dart';
// import 'package:permission_handler/permission_handler.dart';

// class PPTViewer extends StatefulWidget {
//   const PPTViewer({Key key}) : super(key: key);

//   @override
//   State<PPTViewer> createState() => _PPTViewerState();
// }

// const List<String> files = [
//   "https://google-developer-training.github.io/android-developer-fundamentals-course-concepts/en/android-developer-fundamentals-course-concepts-en.pdf",
//   "http://www.cztouch.com/upfiles/soft/testpdf.pdf",
//   "http://blog.java1234.com/cizhi20211008.docx",
//   "http://blog.java1234.com/moban20211008.xls",
//   "https://docs.google.com/presentation/d/1oLSY7UwSo76CTPhhwoFd1CFH_R_eE9We/edit?usp=drive_link&ouid=101703514595655467401&rtpof=true&sd=true"
// ];

// class _PPTViewerState extends State<PPTViewer> {
//   List<String> urls = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Syncfusion Flutter PDF Viewer'),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(
//               Icons.bookmark,
//               color: Colors.white,
//               semanticLabel: 'Bookmark',
//             ),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       // body: PowerFileViewWidget(
//       //   downloadUrl: widget.downloadUrl,
//       //   filePath: widget.downloadPath,
//       // ),
//       body: ListView.builder(
//           itemCount: files.length,
//           itemBuilder: (context, index) {
//             String filePath = files[index];
//             final fileName = FileUtil.getFileName(filePath);
//             final fileType = FileUtil.getFileType(filePath);
//             return Container(
//               margin: const EdgeInsets.only(top: 10.0),
//               padding: const EdgeInsets.symmetric(horizontal: 15.0),
//               child: ElevatedButton(
//                 onPressed: () async {
//                   String savePath = await getFilePath(fileType, fileName);
//                   onTap(context, filePath, savePath);
//                 },
//                 child: Text(fileName),
//               ),
//             );
//           }),
//     );
//   }

//   Future onTap(BuildContext context, String downloadUrl, String downloadPath) async {
//     bool isGranted = await PermissionUtil.check();
//     if (isGranted) {
//       Navigator.of(context).push(
//         MaterialPageRoute(builder: (ctx) {
//           return PowerFileViewPage(
//             downloadUrl: downloadUrl,
//             downloadPath: downloadPath,
//           );
//         }),
//       );
//     } else {
//       debugPrint('no permission');
//     }
//   }

//   Future getFilePath(String type, String assetPath) async {
//     final _directory = await getTemporaryDirectory();
//     return "${_directory.path}/fileview/${base64.encode(utf8.encode(assetPath))}.$type";
//   }
// }

// class PermissionUtil {
//   static Future<bool> check() async {
//     if (Platform.isAndroid) {
//       PermissionStatus status = await Permission.storage.status;
//       if (status.isGranted) {
//         return true;
//       } else if (status.isPermanentlyDenied) {
//         return false;
//       } else {
//         PermissionStatus requestStatus = await Permission.storage.request();
//         if (requestStatus.isGranted) {
//           return true;
//         } else {
//           return false;
//         }
//       }
//     } else {
//       return true;
//     }
//   }
// }
