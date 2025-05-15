import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:project/features/silver_app_bar_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String? _ccepTimetablePath;
  String? _ccepFinalTablePath;

  @override
  void initState() {
    super.initState();
    _loadPdfFiles();
  }

  Future<void> _loadPdfFiles() async {
    final timetablePath =
        await _getPdfFileFromAssets('assets/pdfs/ccep_timetable.pdf');
    final finalTablePath =
        await _getPdfFileFromAssets('assets/pdfs/ccep_final_table.pdf');
    setState(() {
      _ccepTimetablePath = timetablePath;
      _ccepFinalTablePath = finalTablePath;
    });
  }

  Future<String?> _getPdfFileFromAssets(String assetPath) async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Storage permission denied")),
      );
      return null;
    }

    final downloadsDir = Directory('/storage/emulated/0/Download');
    final fileName = assetPath.split('/').last;
    final file = File('${downloadsDir.path}/$fileName');

    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer.asUint8List());
    }

    return file.path;
  }

  Future<void> _openPdf(String filePath) async {
    final result = await OpenFilex.open(filePath);
    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open PDF: ${result.message}')),
      );
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SilverAppBarWidget(
                appBarText: "Schedules",
                onBackPressed: () => Navigator.of(context).pop(),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.06,
                    vertical: size.height * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        title: 'CCEP Timetable',
                        filePath: _ccepTimetablePath,
                        onTap: () => _openPdf(_ccepTimetablePath!),
                        size: size,
                        message: 'Tap to view CCEP Timetable',
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      _buildSection(
                        title: 'Final Table',
                        filePath: _ccepFinalTablePath,
                        onTap: () => _openPdf(_ccepFinalTablePath!),
                        size: size,
                        message: 'Tap to view Final Table',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String? filePath,
    required VoidCallback onTap,
    required Size size,
    required String message,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: filePath == null ? null : onTap,
          child: Container(
            height: size.height * 0.4,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF626262)),
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 230, 228, 228),
            ),
            child: Center(
              child: filePath == null
                  ? CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.picture_as_pdf,
                          size: size.width * 0.1,
                          color: Color.fromARGB(255, 235, 55, 52),
                        ),
                        SizedBox(height: 15),
                        Text(
                          message,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Inter',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
