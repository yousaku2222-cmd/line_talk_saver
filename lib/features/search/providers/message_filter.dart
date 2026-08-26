import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The active sender/date-range/text filter for a chat's timeline.
///
/// `senderIds == null` means "all senders". `dateRange == null` means
/// "no date restriction". `textQuery == null` (or empty) means "no text
/// search".
@immutable
class MessageFilter {
  const MessageFilter({this.senderIds, this.dateRange, this.textQuery});

  final Set<int>? senderIds;
  final DateTimeRange? dateRange;
  final String? textQuery;

  bool get isActive =>
      (senderIds?.isNotEmpty ?? false) ||
      dateRange != null ||
      (textQuery?.trim().isNotEmpty ?? false);

  /// End-of-day for [dateRange]'s end date, so the filter includes every
  /// message on that calendar day rather than cutting off at midnight.
  DateTime? get inclusiveEnd {
    final end = dateRange?.end;
    if (end == null) return null;
    return DateTime(end.year, end.month, end.day, 23, 59, 59, 999);
  }

  static const empty = MessageFilter();

  @override
  bool operator ==(Object other) {
    return other is MessageFilter &&
        setEquals(senderIds, other.senderIds) &&
        dateRange == other.dateRange &&
        textQuery == other.textQuery;
  }

  @override
  int get hashCode => Object.hash(
        senderIds == null ? null : Object.hashAllUnordered(senderIds!),
        dateRange,
        textQuery,
      );
}
