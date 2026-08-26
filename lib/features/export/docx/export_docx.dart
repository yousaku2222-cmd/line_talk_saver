import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../../data/db/app_database.dart';
import '../../../l10n/app_localizations.dart';
import 'ooxml/ooxml_parts.dart';

/// Builds a minimal text-only .docx (自前OOXML — no off-the-shelf pure-Dart
/// writer exists for this) and returns the temp file it was written to.
Future<File> buildDocxFile({
  required AppLocalizations l10n,
  required String chatTitle,
  required List<Message> messages,
  required Map<int, String> senderNames,
}) async {
  final dateTimeFormat = DateFormat('yyyy/MM/dd HH:mm');
  final buffer = StringBuffer();

  buffer.writeln(
    '<w:p><w:pPr><w:jc w:val="center"/></w:pPr>'
    '<w:r><w:rPr><w:b/><w:sz w:val="32"/></w:rPr>'
    '<w:t>${escapeXmlText(chatTitle)}</w:t></w:r></w:p>',
  );

  for (final m in messages) {
    if (m.isSystemMessage) {
      buffer.writeln(
        '<w:p><w:pPr><w:jc w:val="center"/></w:pPr>'
        '<w:r><w:rPr><w:color w:val="808080"/><w:sz w:val="18"/></w:rPr>'
        '<w:t>${escapeXmlText(m.rawText)}</w:t></w:r></w:p>',
      );
      continue;
    }

    final name = (m.senderId != null ? senderNames[m.senderId] : null) ?? l10n.unknownSender;
    buffer.writeln(
      '<w:p>'
      '<w:r><w:rPr><w:b/></w:rPr><w:t xml:space="preserve">'
      '${escapeXmlText(name)}　</w:t></w:r>'
      '<w:r><w:rPr><w:color w:val="808080"/><w:sz w:val="18"/></w:rPr>'
      '<w:t>${escapeXmlText(dateTimeFormat.format(m.timestamp))}</w:t></w:r>'
      '</w:p>',
    );

    final lines = m.rawText.split('\n');
    buffer.write('<w:p>');
    for (var i = 0; i < lines.length; i++) {
      if (i > 0) buffer.write('<w:r><w:br/></w:r>');
      buffer.write(
        '<w:r><w:t xml:space="preserve">${escapeXmlText(lines[i])}</w:t></w:r>',
      );
    }
    buffer.writeln('</w:p>');
  }

  final archive = Archive();
  void addPart(String path, String content) {
    final bytes = utf8.encode(content);
    archive.addFile(ArchiveFile(path, bytes.length, bytes));
  }

  addPart('[Content_Types].xml', contentTypesXml);
  addPart('_rels/.rels', packageRelsXml);
  addPart('word/_rels/document.xml.rels', documentRelsXml);
  addPart('word/styles.xml', stylesXml);
  addPart('word/document.xml', documentXml(buffer.toString()));

  final zipBytes = ZipEncoder().encode(archive);
  if (zipBytes == null) {
    throw StateError(l10n.docxGenerationFailed);
  }

  final dir = await getTemporaryDirectory();
  final safeTitle = chatTitle.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
  final file = File('${dir.path}${Platform.pathSeparator}$safeTitle.docx');
  await file.writeAsBytes(zipBytes);
  return file;
}
