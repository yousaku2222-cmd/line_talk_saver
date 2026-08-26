import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../data/db/app_database.dart';
import '../../../l10n/app_localizations.dart';

/// Builds a PDF (chat-bubble-style layout, Japanese font embedded) for the
/// given chat and returns the temp file it was written to.
Future<File> buildPdfFile({
  required AppLocalizations l10n,
  required String chatTitle,
  required List<Message> messages,
  required Map<int, String> senderNames,
}) async {
  final fontData = await rootBundle.load('assets/fonts/NotoSansJP-Regular.ttf');
  final font = pw.Font.ttf(fontData);
  final doc = pw.Document(theme: pw.ThemeData.withFont(base: font, bold: font));

  // The PDF embeds only a Japanese font (NotoSansJP), which also covers
  // Latin text fine but has no Thai or Hangul glyphs. Chinese text renders
  // via Han unification (same/similar glyphs to Japanese kanji), so it's
  // left localized; Thai and Korean fall back to English here so they don't
  // render as tofu boxes in the generated PDF specifically (the in-app UI
  // itself is still fully in Thai/Korean).
  final noGlyphCoverage =
      l10n.localeName.startsWith('th') || l10n.localeName.startsWith('ko');
  final unknownSender = noGlyphCoverage ? 'Unknown' : l10n.unknownSender;

  final dateTimeFormat = DateFormat('yyyy/MM/dd HH:mm');

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      header: (context) => pw.Text(
        chatTitle,
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
      build: (context) => [
        for (final m in messages)
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (m.isSystemMessage)
                  pw.Center(
                    child: pw.Text(
                      m.rawText,
                      style: const pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.grey600,
                      ),
                    ),
                  )
                else ...[
                  pw.Row(
                    children: [
                      pw.Text(
                        (m.senderId != null ? senderNames[m.senderId] : null) ??
                            unknownSender,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.green800,
                        ),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Text(
                        dateTimeFormat.format(m.timestamp),
                        style: const pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.grey600,
                        ),
                      ),
                    ],
                  ),
                  pw.Container(
                    margin: const pw.EdgeInsets.only(top: 2),
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey200,
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Text(m.rawText, style: const pw.TextStyle(fontSize: 11)),
                  ),
                ],
              ],
            ),
          ),
      ],
    ),
  );

  final dir = await getTemporaryDirectory();
  final safeTitle = chatTitle.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
  final file = File('${dir.path}${Platform.pathSeparator}$safeTitle.pdf');
  await file.writeAsBytes(await doc.save());
  return file;
}
