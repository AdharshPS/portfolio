import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:portfolio_new/models/portfolio_model.dart';
import 'package:portfolio_new/services/web_download.dart';

Future<void> downloadCV(BuildContext context, {CvInfo? cvInfo}) async {
  final url = cvInfo?.downloadUrl.trim();
  final fileName = (cvInfo != null && cvInfo.fileName.trim().isNotEmpty)
      ? cvInfo.fileName.trim()
      : 'Adharsh_PS_Flutter_Developer_Resume.pdf';

  if (url == null || url.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CV download link is currently unavailable.'),
        backgroundColor: Colors.redAccent,
      ),
    );
    return;
  }

  try {
    if (kIsWeb) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.blueAccent),
        ),
      );

      await Future.delayed(const Duration(seconds: 1));

      triggerWebDownload(url, fileName);

      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('CV download started')));
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Colors.blueAccent,
            strokeWidth: 4,
          ),
        ),
      );

      Directory dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory();
      } else {
        dir = await getDownloadsDirectory() ?? await getTemporaryDirectory();
      }

      final filePath = '${dir.path}/$fileName';
      final dio = Dio();

      await dio.download(url, filePath);

      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('CV downloaded to: $filePath')));
      debugPrint('✅ CV saved at: $filePath');
    }
  } catch (e) {
    debugPrint('❌ Error downloading CV: $e');
    if (context.mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error downloading CV: $e')));
    }
  }
}
