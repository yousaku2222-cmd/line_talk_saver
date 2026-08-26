import 'dart:io';

import 'package:excel/excel.dart' as xls;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../../data/db/app_database.dart';
import '../../../l10n/app_localizations.dart';

/// Builds an .xlsx file (date/time/sender/message columns, one row per
/// message) for the given chat and returns the temp file it was written to.
Future<File> buildExcelFile({
  required AppLocalizations l10n,
  required String chatTitle,
  required List<Message> messages,
  required Map<int, String> senderNames,
}) async {
  final workbook = xls.Excel.createExcel();
  final sheetName = l10n.excelSheetName;
  final sheet = workbook[sheetName];
  final defaultSheet = workbook.getDefaultSheet();
  if (defaultSheet != null && defaultSheet != sheetName) {
    workbook.delete(defaultSheet);
  }

  sheet.appendRow([
    xls.TextCellValue(l10n.columnDate),
    xls.TextCellValue(l10n.columnTime),
    xls.TextCellValue(l10n.columnSender),
    xls.TextCellValue(l10n.columnBody),
  ]);

  final dateFormat = DateFormat('yyyy/MM/dd');
  final timeFormat = DateFormat('HH:mm');
  for (final m in messages) {
    final name = m.isSystemMessage
        ? l10n.systemSender
        : (m.senderId != null ? senderNames[m.senderId] : null) ?? l10n.unknownSender;
    sheet.appendRow([
      xls.TextCellValue(dateFormat.format(m.timestamp)),
      xls.TextCellValue(timeFormat.format(m.timestamp)),
      xls.TextCellValue(name),
      xls.TextCellValue(m.rawText),
    ]);
  }

  final bytes = workbook.encode();
  if (bytes == null) {
    throw StateError(l10n.excelGenerationFailed);
  }

  final dir = await getTemporaryDirectory();
  final safeTitle = chatTitle.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
  final file = File('${dir.path}${Platform.pathSeparator}$safeTitle.xlsx');
  await file.writeAsBytes(bytes);
  return file;
}
