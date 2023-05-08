// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
 import 'package:qr_flutter/qr_flutter.dart';

class QRCode extends StatelessWidget {
  const QRCode({
    Key? key,
    this.width,
    this.height,
    this.qrSize,
    required this.qrData,
    this.gapLess,
    this.qrVersion,
    this.qrPadding,
    this.qrBorderRadius,
    this.semanticsLabel,
    this.qrBackgroundColor,
    this.qrForegroundColor,
  }) : super(key: key);

  final double? width;
  final double? height;
  final double? qrSize;
  final String qrData;
  final bool? gapLess;
  final int? qrVersion;
  final double? qrPadding;
  final double? qrBorderRadius;
  final String? semanticsLabel;
  final Color? qrBackgroundColor;
  final Color? qrForegroundColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(qrBorderRadius ?? 0),
      child: QrImage(
        size: qrSize,
        data: qrData,
        gapless: gapLess ?? true,
        version: qrVersion ?? QrVersions.auto,
        padding: EdgeInsets.all(qrPadding ?? 10),
        semanticsLabel: semanticsLabel ?? '',
        backgroundColor: qrBackgroundColor ?? Colors.transparent,
        foregroundColor:
            qrForegroundColor ?? Color.fromARGB(255, 253, 251, 251),
      ),
    );
  }
}
