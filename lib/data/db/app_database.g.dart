// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ChatsTable extends Chats with TableInfo<$ChatsTable, Chat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<DateTime> importedAt = GeneratedColumn<DateTime>(
    'imported_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceFileNameMeta = const VerificationMeta(
    'sourceFileName',
  );
  @override
  late final GeneratedColumn<String> sourceFileName = GeneratedColumn<String>(
    'source_file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawTxtPathMeta = const VerificationMeta(
    'rawTxtPath',
  );
  @override
  late final GeneratedColumn<String> rawTxtPath = GeneratedColumn<String>(
    'raw_txt_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isLockedMeta = const VerificationMeta(
    'isLocked',
  );
  @override
  late final GeneratedColumn<bool> isLocked = GeneratedColumn<bool>(
    'is_locked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_locked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    importedAt,
    sourceFileName,
    rawTxtPath,
    iconKey,
    isLocked,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chats';
  @override
  VerificationContext validateIntegrity(
    Insertable<Chat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_importedAtMeta);
    }
    if (data.containsKey('source_file_name')) {
      context.handle(
        _sourceFileNameMeta,
        sourceFileName.isAcceptableOrUnknown(
          data['source_file_name']!,
          _sourceFileNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceFileNameMeta);
    }
    if (data.containsKey('raw_txt_path')) {
      context.handle(
        _rawTxtPathMeta,
        rawTxtPath.isAcceptableOrUnknown(
          data['raw_txt_path']!,
          _rawTxtPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rawTxtPathMeta);
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    }
    if (data.containsKey('is_locked')) {
      context.handle(
        _isLockedMeta,
        isLocked.isAcceptableOrUnknown(data['is_locked']!, _isLockedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chat(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}imported_at'],
      )!,
      sourceFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_file_name'],
      )!,
      rawTxtPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_txt_path'],
      )!,
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      ),
      isLocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_locked'],
      )!,
    );
  }

  @override
  $ChatsTable createAlias(String alias) {
    return $ChatsTable(attachedDatabase, alias);
  }
}

class Chat extends DataClass implements Insertable<Chat> {
  final int id;
  final String title;
  final DateTime importedAt;
  final String sourceFileName;
  final String rawTxtPath;

  /// Key into `chatIconOptions` (see chat_icon_options.dart) for the icon
  /// shown in the chat list; null falls back to the default icon.
  final String? iconKey;

  /// When true, opening this chat requires device authentication
  /// (see AppLockService), independent of the app-wide lock setting.
  final bool isLocked;
  const Chat({
    required this.id,
    required this.title,
    required this.importedAt,
    required this.sourceFileName,
    required this.rawTxtPath,
    this.iconKey,
    required this.isLocked,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['imported_at'] = Variable<DateTime>(importedAt);
    map['source_file_name'] = Variable<String>(sourceFileName);
    map['raw_txt_path'] = Variable<String>(rawTxtPath);
    if (!nullToAbsent || iconKey != null) {
      map['icon_key'] = Variable<String>(iconKey);
    }
    map['is_locked'] = Variable<bool>(isLocked);
    return map;
  }

  ChatsCompanion toCompanion(bool nullToAbsent) {
    return ChatsCompanion(
      id: Value(id),
      title: Value(title),
      importedAt: Value(importedAt),
      sourceFileName: Value(sourceFileName),
      rawTxtPath: Value(rawTxtPath),
      iconKey: iconKey == null && nullToAbsent
          ? const Value.absent()
          : Value(iconKey),
      isLocked: Value(isLocked),
    );
  }

  factory Chat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chat(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      importedAt: serializer.fromJson<DateTime>(json['importedAt']),
      sourceFileName: serializer.fromJson<String>(json['sourceFileName']),
      rawTxtPath: serializer.fromJson<String>(json['rawTxtPath']),
      iconKey: serializer.fromJson<String?>(json['iconKey']),
      isLocked: serializer.fromJson<bool>(json['isLocked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'importedAt': serializer.toJson<DateTime>(importedAt),
      'sourceFileName': serializer.toJson<String>(sourceFileName),
      'rawTxtPath': serializer.toJson<String>(rawTxtPath),
      'iconKey': serializer.toJson<String?>(iconKey),
      'isLocked': serializer.toJson<bool>(isLocked),
    };
  }

  Chat copyWith({
    int? id,
    String? title,
    DateTime? importedAt,
    String? sourceFileName,
    String? rawTxtPath,
    Value<String?> iconKey = const Value.absent(),
    bool? isLocked,
  }) => Chat(
    id: id ?? this.id,
    title: title ?? this.title,
    importedAt: importedAt ?? this.importedAt,
    sourceFileName: sourceFileName ?? this.sourceFileName,
    rawTxtPath: rawTxtPath ?? this.rawTxtPath,
    iconKey: iconKey.present ? iconKey.value : this.iconKey,
    isLocked: isLocked ?? this.isLocked,
  );
  Chat copyWithCompanion(ChatsCompanion data) {
    return Chat(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
      sourceFileName: data.sourceFileName.present
          ? data.sourceFileName.value
          : this.sourceFileName,
      rawTxtPath: data.rawTxtPath.present
          ? data.rawTxtPath.value
          : this.rawTxtPath,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      isLocked: data.isLocked.present ? data.isLocked.value : this.isLocked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chat(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('importedAt: $importedAt, ')
          ..write('sourceFileName: $sourceFileName, ')
          ..write('rawTxtPath: $rawTxtPath, ')
          ..write('iconKey: $iconKey, ')
          ..write('isLocked: $isLocked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    importedAt,
    sourceFileName,
    rawTxtPath,
    iconKey,
    isLocked,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chat &&
          other.id == this.id &&
          other.title == this.title &&
          other.importedAt == this.importedAt &&
          other.sourceFileName == this.sourceFileName &&
          other.rawTxtPath == this.rawTxtPath &&
          other.iconKey == this.iconKey &&
          other.isLocked == this.isLocked);
}

class ChatsCompanion extends UpdateCompanion<Chat> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> importedAt;
  final Value<String> sourceFileName;
  final Value<String> rawTxtPath;
  final Value<String?> iconKey;
  final Value<bool> isLocked;
  const ChatsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.sourceFileName = const Value.absent(),
    this.rawTxtPath = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.isLocked = const Value.absent(),
  });
  ChatsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required DateTime importedAt,
    required String sourceFileName,
    required String rawTxtPath,
    this.iconKey = const Value.absent(),
    this.isLocked = const Value.absent(),
  }) : title = Value(title),
       importedAt = Value(importedAt),
       sourceFileName = Value(sourceFileName),
       rawTxtPath = Value(rawTxtPath);
  static Insertable<Chat> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<DateTime>? importedAt,
    Expression<String>? sourceFileName,
    Expression<String>? rawTxtPath,
    Expression<String>? iconKey,
    Expression<bool>? isLocked,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (importedAt != null) 'imported_at': importedAt,
      if (sourceFileName != null) 'source_file_name': sourceFileName,
      if (rawTxtPath != null) 'raw_txt_path': rawTxtPath,
      if (iconKey != null) 'icon_key': iconKey,
      if (isLocked != null) 'is_locked': isLocked,
    });
  }

  ChatsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<DateTime>? importedAt,
    Value<String>? sourceFileName,
    Value<String>? rawTxtPath,
    Value<String?>? iconKey,
    Value<bool>? isLocked,
  }) {
    return ChatsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      importedAt: importedAt ?? this.importedAt,
      sourceFileName: sourceFileName ?? this.sourceFileName,
      rawTxtPath: rawTxtPath ?? this.rawTxtPath,
      iconKey: iconKey ?? this.iconKey,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<DateTime>(importedAt.value);
    }
    if (sourceFileName.present) {
      map['source_file_name'] = Variable<String>(sourceFileName.value);
    }
    if (rawTxtPath.present) {
      map['raw_txt_path'] = Variable<String>(rawTxtPath.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (isLocked.present) {
      map['is_locked'] = Variable<bool>(isLocked.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('importedAt: $importedAt, ')
          ..write('sourceFileName: $sourceFileName, ')
          ..write('rawTxtPath: $rawTxtPath, ')
          ..write('iconKey: $iconKey, ')
          ..write('isLocked: $isLocked')
          ..write(')'))
        .toString();
  }
}

class $SendersTable extends Senders with TableInfo<$SendersTable, Sender> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SendersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<int> chatId = GeneratedColumn<int>(
    'chat_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chats (id)',
    ),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, chatId, displayName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'senders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Sender> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chat_id')) {
      context.handle(
        _chatIdMeta,
        chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sender map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sender(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      chatId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chat_id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
    );
  }

  @override
  $SendersTable createAlias(String alias) {
    return $SendersTable(attachedDatabase, alias);
  }
}

class Sender extends DataClass implements Insertable<Sender> {
  final int id;
  final int chatId;
  final String displayName;
  const Sender({
    required this.id,
    required this.chatId,
    required this.displayName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['chat_id'] = Variable<int>(chatId);
    map['display_name'] = Variable<String>(displayName);
    return map;
  }

  SendersCompanion toCompanion(bool nullToAbsent) {
    return SendersCompanion(
      id: Value(id),
      chatId: Value(chatId),
      displayName: Value(displayName),
    );
  }

  factory Sender.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sender(
      id: serializer.fromJson<int>(json['id']),
      chatId: serializer.fromJson<int>(json['chatId']),
      displayName: serializer.fromJson<String>(json['displayName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'chatId': serializer.toJson<int>(chatId),
      'displayName': serializer.toJson<String>(displayName),
    };
  }

  Sender copyWith({int? id, int? chatId, String? displayName}) => Sender(
    id: id ?? this.id,
    chatId: chatId ?? this.chatId,
    displayName: displayName ?? this.displayName,
  );
  Sender copyWithCompanion(SendersCompanion data) {
    return Sender(
      id: data.id.present ? data.id.value : this.id,
      chatId: data.chatId.present ? data.chatId.value : this.chatId,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sender(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('displayName: $displayName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, chatId, displayName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sender &&
          other.id == this.id &&
          other.chatId == this.chatId &&
          other.displayName == this.displayName);
}

class SendersCompanion extends UpdateCompanion<Sender> {
  final Value<int> id;
  final Value<int> chatId;
  final Value<String> displayName;
  const SendersCompanion({
    this.id = const Value.absent(),
    this.chatId = const Value.absent(),
    this.displayName = const Value.absent(),
  });
  SendersCompanion.insert({
    this.id = const Value.absent(),
    required int chatId,
    required String displayName,
  }) : chatId = Value(chatId),
       displayName = Value(displayName);
  static Insertable<Sender> custom({
    Expression<int>? id,
    Expression<int>? chatId,
    Expression<String>? displayName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chatId != null) 'chat_id': chatId,
      if (displayName != null) 'display_name': displayName,
    });
  }

  SendersCompanion copyWith({
    Value<int>? id,
    Value<int>? chatId,
    Value<String>? displayName,
  }) {
    return SendersCompanion(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (chatId.present) {
      map['chat_id'] = Variable<int>(chatId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SendersCompanion(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('displayName: $displayName')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages with TableInfo<$MessagesTable, Message> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<int> chatId = GeneratedColumn<int>(
    'chat_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chats (id)',
    ),
  );
  static const VerificationMeta _senderIdMeta = const VerificationMeta(
    'senderId',
  );
  @override
  late final GeneratedColumn<int> senderId = GeneratedColumn<int>(
    'sender_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES senders (id)',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawTextMeta = const VerificationMeta(
    'rawText',
  );
  @override
  late final GeneratedColumn<String> rawText = GeneratedColumn<String>(
    'raw_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSystemMessageMeta = const VerificationMeta(
    'isSystemMessage',
  );
  @override
  late final GeneratedColumn<bool> isSystemMessage = GeneratedColumn<bool>(
    'is_system_message',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system_message" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _mediaPlaceholderTypeMeta =
      const VerificationMeta('mediaPlaceholderType');
  @override
  late final GeneratedColumn<String> mediaPlaceholderType =
      GeneratedColumn<String>(
        'media_placeholder_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sortIndexMeta = const VerificationMeta(
    'sortIndex',
  );
  @override
  late final GeneratedColumn<int> sortIndex = GeneratedColumn<int>(
    'sort_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    chatId,
    senderId,
    timestamp,
    rawText,
    isSystemMessage,
    mediaPlaceholderType,
    sortIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<Message> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chat_id')) {
      context.handle(
        _chatIdMeta,
        chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(
        _senderIdMeta,
        senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('raw_text')) {
      context.handle(
        _rawTextMeta,
        rawText.isAcceptableOrUnknown(data['raw_text']!, _rawTextMeta),
      );
    } else if (isInserting) {
      context.missing(_rawTextMeta);
    }
    if (data.containsKey('is_system_message')) {
      context.handle(
        _isSystemMessageMeta,
        isSystemMessage.isAcceptableOrUnknown(
          data['is_system_message']!,
          _isSystemMessageMeta,
        ),
      );
    }
    if (data.containsKey('media_placeholder_type')) {
      context.handle(
        _mediaPlaceholderTypeMeta,
        mediaPlaceholderType.isAcceptableOrUnknown(
          data['media_placeholder_type']!,
          _mediaPlaceholderTypeMeta,
        ),
      );
    }
    if (data.containsKey('sort_index')) {
      context.handle(
        _sortIndexMeta,
        sortIndex.isAcceptableOrUnknown(data['sort_index']!, _sortIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_sortIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Message map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Message(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      chatId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chat_id'],
      )!,
      senderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sender_id'],
      ),
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      rawText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_text'],
      )!,
      isSystemMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system_message'],
      )!,
      mediaPlaceholderType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_placeholder_type'],
      ),
      sortIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_index'],
      )!,
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class Message extends DataClass implements Insertable<Message> {
  final int id;
  final int chatId;
  final int? senderId;
  final DateTime timestamp;
  final String rawText;
  final bool isSystemMessage;
  final String? mediaPlaceholderType;
  final int sortIndex;
  const Message({
    required this.id,
    required this.chatId,
    this.senderId,
    required this.timestamp,
    required this.rawText,
    required this.isSystemMessage,
    this.mediaPlaceholderType,
    required this.sortIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['chat_id'] = Variable<int>(chatId);
    if (!nullToAbsent || senderId != null) {
      map['sender_id'] = Variable<int>(senderId);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['raw_text'] = Variable<String>(rawText);
    map['is_system_message'] = Variable<bool>(isSystemMessage);
    if (!nullToAbsent || mediaPlaceholderType != null) {
      map['media_placeholder_type'] = Variable<String>(mediaPlaceholderType);
    }
    map['sort_index'] = Variable<int>(sortIndex);
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      chatId: Value(chatId),
      senderId: senderId == null && nullToAbsent
          ? const Value.absent()
          : Value(senderId),
      timestamp: Value(timestamp),
      rawText: Value(rawText),
      isSystemMessage: Value(isSystemMessage),
      mediaPlaceholderType: mediaPlaceholderType == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaPlaceholderType),
      sortIndex: Value(sortIndex),
    );
  }

  factory Message.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Message(
      id: serializer.fromJson<int>(json['id']),
      chatId: serializer.fromJson<int>(json['chatId']),
      senderId: serializer.fromJson<int?>(json['senderId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      rawText: serializer.fromJson<String>(json['rawText']),
      isSystemMessage: serializer.fromJson<bool>(json['isSystemMessage']),
      mediaPlaceholderType: serializer.fromJson<String?>(
        json['mediaPlaceholderType'],
      ),
      sortIndex: serializer.fromJson<int>(json['sortIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'chatId': serializer.toJson<int>(chatId),
      'senderId': serializer.toJson<int?>(senderId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'rawText': serializer.toJson<String>(rawText),
      'isSystemMessage': serializer.toJson<bool>(isSystemMessage),
      'mediaPlaceholderType': serializer.toJson<String?>(mediaPlaceholderType),
      'sortIndex': serializer.toJson<int>(sortIndex),
    };
  }

  Message copyWith({
    int? id,
    int? chatId,
    Value<int?> senderId = const Value.absent(),
    DateTime? timestamp,
    String? rawText,
    bool? isSystemMessage,
    Value<String?> mediaPlaceholderType = const Value.absent(),
    int? sortIndex,
  }) => Message(
    id: id ?? this.id,
    chatId: chatId ?? this.chatId,
    senderId: senderId.present ? senderId.value : this.senderId,
    timestamp: timestamp ?? this.timestamp,
    rawText: rawText ?? this.rawText,
    isSystemMessage: isSystemMessage ?? this.isSystemMessage,
    mediaPlaceholderType: mediaPlaceholderType.present
        ? mediaPlaceholderType.value
        : this.mediaPlaceholderType,
    sortIndex: sortIndex ?? this.sortIndex,
  );
  Message copyWithCompanion(MessagesCompanion data) {
    return Message(
      id: data.id.present ? data.id.value : this.id,
      chatId: data.chatId.present ? data.chatId.value : this.chatId,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      rawText: data.rawText.present ? data.rawText.value : this.rawText,
      isSystemMessage: data.isSystemMessage.present
          ? data.isSystemMessage.value
          : this.isSystemMessage,
      mediaPlaceholderType: data.mediaPlaceholderType.present
          ? data.mediaPlaceholderType.value
          : this.mediaPlaceholderType,
      sortIndex: data.sortIndex.present ? data.sortIndex.value : this.sortIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Message(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('senderId: $senderId, ')
          ..write('timestamp: $timestamp, ')
          ..write('rawText: $rawText, ')
          ..write('isSystemMessage: $isSystemMessage, ')
          ..write('mediaPlaceholderType: $mediaPlaceholderType, ')
          ..write('sortIndex: $sortIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    chatId,
    senderId,
    timestamp,
    rawText,
    isSystemMessage,
    mediaPlaceholderType,
    sortIndex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          other.id == this.id &&
          other.chatId == this.chatId &&
          other.senderId == this.senderId &&
          other.timestamp == this.timestamp &&
          other.rawText == this.rawText &&
          other.isSystemMessage == this.isSystemMessage &&
          other.mediaPlaceholderType == this.mediaPlaceholderType &&
          other.sortIndex == this.sortIndex);
}

class MessagesCompanion extends UpdateCompanion<Message> {
  final Value<int> id;
  final Value<int> chatId;
  final Value<int?> senderId;
  final Value<DateTime> timestamp;
  final Value<String> rawText;
  final Value<bool> isSystemMessage;
  final Value<String?> mediaPlaceholderType;
  final Value<int> sortIndex;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.chatId = const Value.absent(),
    this.senderId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rawText = const Value.absent(),
    this.isSystemMessage = const Value.absent(),
    this.mediaPlaceholderType = const Value.absent(),
    this.sortIndex = const Value.absent(),
  });
  MessagesCompanion.insert({
    this.id = const Value.absent(),
    required int chatId,
    this.senderId = const Value.absent(),
    required DateTime timestamp,
    required String rawText,
    this.isSystemMessage = const Value.absent(),
    this.mediaPlaceholderType = const Value.absent(),
    required int sortIndex,
  }) : chatId = Value(chatId),
       timestamp = Value(timestamp),
       rawText = Value(rawText),
       sortIndex = Value(sortIndex);
  static Insertable<Message> custom({
    Expression<int>? id,
    Expression<int>? chatId,
    Expression<int>? senderId,
    Expression<DateTime>? timestamp,
    Expression<String>? rawText,
    Expression<bool>? isSystemMessage,
    Expression<String>? mediaPlaceholderType,
    Expression<int>? sortIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chatId != null) 'chat_id': chatId,
      if (senderId != null) 'sender_id': senderId,
      if (timestamp != null) 'timestamp': timestamp,
      if (rawText != null) 'raw_text': rawText,
      if (isSystemMessage != null) 'is_system_message': isSystemMessage,
      if (mediaPlaceholderType != null)
        'media_placeholder_type': mediaPlaceholderType,
      if (sortIndex != null) 'sort_index': sortIndex,
    });
  }

  MessagesCompanion copyWith({
    Value<int>? id,
    Value<int>? chatId,
    Value<int?>? senderId,
    Value<DateTime>? timestamp,
    Value<String>? rawText,
    Value<bool>? isSystemMessage,
    Value<String?>? mediaPlaceholderType,
    Value<int>? sortIndex,
  }) {
    return MessagesCompanion(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      timestamp: timestamp ?? this.timestamp,
      rawText: rawText ?? this.rawText,
      isSystemMessage: isSystemMessage ?? this.isSystemMessage,
      mediaPlaceholderType: mediaPlaceholderType ?? this.mediaPlaceholderType,
      sortIndex: sortIndex ?? this.sortIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (chatId.present) {
      map['chat_id'] = Variable<int>(chatId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<int>(senderId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rawText.present) {
      map['raw_text'] = Variable<String>(rawText.value);
    }
    if (isSystemMessage.present) {
      map['is_system_message'] = Variable<bool>(isSystemMessage.value);
    }
    if (mediaPlaceholderType.present) {
      map['media_placeholder_type'] = Variable<String>(
        mediaPlaceholderType.value,
      );
    }
    if (sortIndex.present) {
      map['sort_index'] = Variable<int>(sortIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('senderId: $senderId, ')
          ..write('timestamp: $timestamp, ')
          ..write('rawText: $rawText, ')
          ..write('isSystemMessage: $isSystemMessage, ')
          ..write('mediaPlaceholderType: $mediaPlaceholderType, ')
          ..write('sortIndex: $sortIndex')
          ..write(')'))
        .toString();
  }
}

class $ImageAttachmentsTable extends ImageAttachments
    with TableInfo<$ImageAttachmentsTable, ImageAttachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImageAttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<int> chatId = GeneratedColumn<int>(
    'chat_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chats (id)',
    ),
  );
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<int> messageId = GeneratedColumn<int>(
    'message_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES messages (id)',
    ),
  );
  static const VerificationMeta _localFilePathMeta = const VerificationMeta(
    'localFilePath',
  );
  @override
  late final GeneratedColumn<String> localFilePath = GeneratedColumn<String>(
    'local_file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    chatId,
    messageId,
    localFilePath,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'image_attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImageAttachment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chat_id')) {
      context.handle(
        _chatIdMeta,
        chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    }
    if (data.containsKey('local_file_path')) {
      context.handle(
        _localFilePathMeta,
        localFilePath.isAcceptableOrUnknown(
          data['local_file_path']!,
          _localFilePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localFilePathMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImageAttachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImageAttachment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      chatId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chat_id'],
      )!,
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}message_id'],
      ),
      localFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_file_path'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $ImageAttachmentsTable createAlias(String alias) {
    return $ImageAttachmentsTable(attachedDatabase, alias);
  }
}

class ImageAttachment extends DataClass implements Insertable<ImageAttachment> {
  final int id;
  final int chatId;
  final int? messageId;
  final String localFilePath;
  final DateTime addedAt;
  const ImageAttachment({
    required this.id,
    required this.chatId,
    this.messageId,
    required this.localFilePath,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['chat_id'] = Variable<int>(chatId);
    if (!nullToAbsent || messageId != null) {
      map['message_id'] = Variable<int>(messageId);
    }
    map['local_file_path'] = Variable<String>(localFilePath);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  ImageAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return ImageAttachmentsCompanion(
      id: Value(id),
      chatId: Value(chatId),
      messageId: messageId == null && nullToAbsent
          ? const Value.absent()
          : Value(messageId),
      localFilePath: Value(localFilePath),
      addedAt: Value(addedAt),
    );
  }

  factory ImageAttachment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImageAttachment(
      id: serializer.fromJson<int>(json['id']),
      chatId: serializer.fromJson<int>(json['chatId']),
      messageId: serializer.fromJson<int?>(json['messageId']),
      localFilePath: serializer.fromJson<String>(json['localFilePath']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'chatId': serializer.toJson<int>(chatId),
      'messageId': serializer.toJson<int?>(messageId),
      'localFilePath': serializer.toJson<String>(localFilePath),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  ImageAttachment copyWith({
    int? id,
    int? chatId,
    Value<int?> messageId = const Value.absent(),
    String? localFilePath,
    DateTime? addedAt,
  }) => ImageAttachment(
    id: id ?? this.id,
    chatId: chatId ?? this.chatId,
    messageId: messageId.present ? messageId.value : this.messageId,
    localFilePath: localFilePath ?? this.localFilePath,
    addedAt: addedAt ?? this.addedAt,
  );
  ImageAttachment copyWithCompanion(ImageAttachmentsCompanion data) {
    return ImageAttachment(
      id: data.id.present ? data.id.value : this.id,
      chatId: data.chatId.present ? data.chatId.value : this.chatId,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      localFilePath: data.localFilePath.present
          ? data.localFilePath.value
          : this.localFilePath,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImageAttachment(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('messageId: $messageId, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, chatId, messageId, localFilePath, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImageAttachment &&
          other.id == this.id &&
          other.chatId == this.chatId &&
          other.messageId == this.messageId &&
          other.localFilePath == this.localFilePath &&
          other.addedAt == this.addedAt);
}

class ImageAttachmentsCompanion extends UpdateCompanion<ImageAttachment> {
  final Value<int> id;
  final Value<int> chatId;
  final Value<int?> messageId;
  final Value<String> localFilePath;
  final Value<DateTime> addedAt;
  const ImageAttachmentsCompanion({
    this.id = const Value.absent(),
    this.chatId = const Value.absent(),
    this.messageId = const Value.absent(),
    this.localFilePath = const Value.absent(),
    this.addedAt = const Value.absent(),
  });
  ImageAttachmentsCompanion.insert({
    this.id = const Value.absent(),
    required int chatId,
    this.messageId = const Value.absent(),
    required String localFilePath,
    required DateTime addedAt,
  }) : chatId = Value(chatId),
       localFilePath = Value(localFilePath),
       addedAt = Value(addedAt);
  static Insertable<ImageAttachment> custom({
    Expression<int>? id,
    Expression<int>? chatId,
    Expression<int>? messageId,
    Expression<String>? localFilePath,
    Expression<DateTime>? addedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chatId != null) 'chat_id': chatId,
      if (messageId != null) 'message_id': messageId,
      if (localFilePath != null) 'local_file_path': localFilePath,
      if (addedAt != null) 'added_at': addedAt,
    });
  }

  ImageAttachmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? chatId,
    Value<int?>? messageId,
    Value<String>? localFilePath,
    Value<DateTime>? addedAt,
  }) {
    return ImageAttachmentsCompanion(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      messageId: messageId ?? this.messageId,
      localFilePath: localFilePath ?? this.localFilePath,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (chatId.present) {
      map['chat_id'] = Variable<int>(chatId.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<int>(messageId.value);
    }
    if (localFilePath.present) {
      map['local_file_path'] = Variable<String>(localFilePath.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImageAttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('messageId: $messageId, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ChatsTable chats = $ChatsTable(this);
  late final $SendersTable senders = $SendersTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $ImageAttachmentsTable imageAttachments = $ImageAttachmentsTable(
    this,
  );
  late final ChatDao chatDao = ChatDao(this as AppDatabase);
  late final MessageDao messageDao = MessageDao(this as AppDatabase);
  late final ImageAttachmentDao imageAttachmentDao = ImageAttachmentDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    chats,
    senders,
    messages,
    imageAttachments,
  ];
}

typedef $$ChatsTableCreateCompanionBuilder = ChatsCompanion Function({
  Value<int> id,
  required String title,
  required DateTime importedAt,
  required String sourceFileName,
  required String rawTxtPath,
  Value<String?> iconKey,
  Value<bool> isLocked,
});
typedef $$ChatsTableUpdateCompanionBuilder = ChatsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<DateTime> importedAt,
  Value<String> sourceFileName,
  Value<String> rawTxtPath,
  Value<String?> iconKey,
  Value<bool> isLocked,
});

final class $$ChatsTableReferences
    extends BaseReferences<_$AppDatabase, $ChatsTable, Chat> {
  $$ChatsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SendersTable, List<Sender>> _sendersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.senders,
    aliasName: 'chats__id__senders__chat_id',
  );

  $$SendersTableProcessedTableManager get sendersRefs {
    final manager = $$SendersTableTableManager(
      $_db,
      $_db.senders,
    ).filter((f) => f.chatId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sendersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MessagesTable, List<Message>> _messagesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.messages,
    aliasName: 'chats__id__messages__chat_id',
  );

  $$MessagesTableProcessedTableManager get messagesRefs {
    final manager = $$MessagesTableTableManager(
      $_db,
      $_db.messages,
    ).filter((f) => f.chatId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_messagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ImageAttachmentsTable, List<ImageAttachment>>
  _imageAttachmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.imageAttachments,
    aliasName: 'chats__id__image_attachments__chat_id',
  );

  $$ImageAttachmentsTableProcessedTableManager get imageAttachmentsRefs {
    final manager = $$ImageAttachmentsTableTableManager(
      $_db,
      $_db.imageAttachments,
    ).filter((f) => f.chatId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _imageAttachmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChatsTableFilterComposer extends Composer<_$AppDatabase, $ChatsTable> {
  $$ChatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceFileName => $composableBuilder(
    column: $table.sourceFileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawTxtPath => $composableBuilder(
    column: $table.rawTxtPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLocked => $composableBuilder(
    column: $table.isLocked,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sendersRefs(
    Expression<bool> Function($$SendersTableFilterComposer f) f,
  ) {
    final $$SendersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.senders,
      getReferencedColumn: (t) => t.chatId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SendersTableFilterComposer(
            $db: $db,
            $table: $db.senders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> messagesRefs(
    Expression<bool> Function($$MessagesTableFilterComposer f) f,
  ) {
    final $$MessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.chatId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableFilterComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> imageAttachmentsRefs(
    Expression<bool> Function($$ImageAttachmentsTableFilterComposer f) f,
  ) {
    final $$ImageAttachmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.imageAttachments,
      getReferencedColumn: (t) => t.chatId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImageAttachmentsTableFilterComposer(
            $db: $db,
            $table: $db.imageAttachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChatsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatsTable> {
  $$ChatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceFileName => $composableBuilder(
    column: $table.sourceFileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawTxtPath => $composableBuilder(
    column: $table.rawTxtPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLocked => $composableBuilder(
    column: $table.isLocked,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatsTable> {
  $$ChatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceFileName => $composableBuilder(
    column: $table.sourceFileName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawTxtPath => $composableBuilder(
    column: $table.rawTxtPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<bool> get isLocked =>
      $composableBuilder(column: $table.isLocked, builder: (column) => column);

  Expression<T> sendersRefs<T extends Object>(
    Expression<T> Function($$SendersTableAnnotationComposer a) f,
  ) {
    final $$SendersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.senders,
      getReferencedColumn: (t) => t.chatId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SendersTableAnnotationComposer(
            $db: $db,
            $table: $db.senders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> messagesRefs<T extends Object>(
    Expression<T> Function($$MessagesTableAnnotationComposer a) f,
  ) {
    final $$MessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.chatId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> imageAttachmentsRefs<T extends Object>(
    Expression<T> Function($$ImageAttachmentsTableAnnotationComposer a) f,
  ) {
    final $$ImageAttachmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.imageAttachments,
      getReferencedColumn: (t) => t.chatId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImageAttachmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.imageAttachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatsTable,
          Chat,
          $$ChatsTableFilterComposer,
          $$ChatsTableOrderingComposer,
          $$ChatsTableAnnotationComposer,
          $$ChatsTableCreateCompanionBuilder,
          $$ChatsTableUpdateCompanionBuilder,
          (Chat, $$ChatsTableReferences),
          Chat,
          PrefetchHooks Function({
            bool sendersRefs,
            bool messagesRefs,
            bool imageAttachmentsRefs,
          })
        > {
  $$ChatsTableTableManager(_$AppDatabase db, $ChatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> importedAt = const Value.absent(),
                Value<String> sourceFileName = const Value.absent(),
                Value<String> rawTxtPath = const Value.absent(),
                Value<String?> iconKey = const Value.absent(),
                Value<bool> isLocked = const Value.absent(),
              }) => ChatsCompanion(
                id: id,
                title: title,
                importedAt: importedAt,
                sourceFileName: sourceFileName,
                rawTxtPath: rawTxtPath,
                iconKey: iconKey,
                isLocked: isLocked,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required DateTime importedAt,
                required String sourceFileName,
                required String rawTxtPath,
                Value<String?> iconKey = const Value.absent(),
                Value<bool> isLocked = const Value.absent(),
              }) => ChatsCompanion.insert(
                id: id,
                title: title,
                importedAt: importedAt,
                sourceFileName: sourceFileName,
                rawTxtPath: rawTxtPath,
                iconKey: iconKey,
                isLocked: isLocked,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ChatsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sendersRefs = false,
                messagesRefs = false,
                imageAttachmentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sendersRefs) db.senders,
                    if (messagesRefs) db.messages,
                    if (imageAttachmentsRefs) db.imageAttachments,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sendersRefs)
                        await $_getPrefetchedData<Chat, $ChatsTable, Sender>(
                          currentTable: table,
                          referencedTable: $$ChatsTableReferences
                              ._sendersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChatsTableReferences(db, table, p0).sendersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chatId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (messagesRefs)
                        await $_getPrefetchedData<Chat, $ChatsTable, Message>(
                          currentTable: table,
                          referencedTable: $$ChatsTableReferences
                              ._messagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChatsTableReferences(
                                db,
                                table,
                                p0,
                              ).messagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chatId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (imageAttachmentsRefs)
                        await $_getPrefetchedData<
                          Chat,
                          $ChatsTable,
                          ImageAttachment
                        >(
                          currentTable: table,
                          referencedTable: $$ChatsTableReferences
                              ._imageAttachmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChatsTableReferences(
                                db,
                                table,
                                p0,
                              ).imageAttachmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chatId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ChatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatsTable,
      Chat,
      $$ChatsTableFilterComposer,
      $$ChatsTableOrderingComposer,
      $$ChatsTableAnnotationComposer,
      $$ChatsTableCreateCompanionBuilder,
      $$ChatsTableUpdateCompanionBuilder,
      (Chat, $$ChatsTableReferences),
      Chat,
      PrefetchHooks Function({
        bool sendersRefs,
        bool messagesRefs,
        bool imageAttachmentsRefs,
      })
    >;
typedef $$SendersTableCreateCompanionBuilder = SendersCompanion Function({
  Value<int> id,
  required int chatId,
  required String displayName,
});
typedef $$SendersTableUpdateCompanionBuilder = SendersCompanion Function({
  Value<int> id,
  Value<int> chatId,
  Value<String> displayName,
});

final class $$SendersTableReferences
    extends BaseReferences<_$AppDatabase, $SendersTable, Sender> {
  $$SendersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChatsTable _chatIdTable(_$AppDatabase db) =>
      db.chats.createAlias('senders__chat_id__chats__id');

  $$ChatsTableProcessedTableManager get chatId {
    final $_column = $_itemColumn<int>('chat_id')!;

    final manager = $$ChatsTableTableManager(
      $_db,
      $_db.chats,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chatIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MessagesTable, List<Message>> _messagesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.messages,
    aliasName: 'senders__id__messages__sender_id',
  );

  $$MessagesTableProcessedTableManager get messagesRefs {
    final manager = $$MessagesTableTableManager(
      $_db,
      $_db.messages,
    ).filter((f) => f.senderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_messagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SendersTableFilterComposer
    extends Composer<_$AppDatabase, $SendersTable> {
  $$SendersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  $$ChatsTableFilterComposer get chatId {
    final $$ChatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableFilterComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> messagesRefs(
    Expression<bool> Function($$MessagesTableFilterComposer f) f,
  ) {
    final $$MessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.senderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableFilterComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SendersTableOrderingComposer
    extends Composer<_$AppDatabase, $SendersTable> {
  $$SendersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChatsTableOrderingComposer get chatId {
    final $$ChatsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableOrderingComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SendersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SendersTable> {
  $$SendersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  $$ChatsTableAnnotationComposer get chatId {
    final $$ChatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableAnnotationComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> messagesRefs<T extends Object>(
    Expression<T> Function($$MessagesTableAnnotationComposer a) f,
  ) {
    final $$MessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.senderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SendersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SendersTable,
          Sender,
          $$SendersTableFilterComposer,
          $$SendersTableOrderingComposer,
          $$SendersTableAnnotationComposer,
          $$SendersTableCreateCompanionBuilder,
          $$SendersTableUpdateCompanionBuilder,
          (Sender, $$SendersTableReferences),
          Sender,
          PrefetchHooks Function({bool chatId, bool messagesRefs})
        > {
  $$SendersTableTableManager(_$AppDatabase db, $SendersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SendersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SendersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SendersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> chatId = const Value.absent(),
                Value<String> displayName = const Value.absent(),
              }) => SendersCompanion(
                id: id,
                chatId: chatId,
                displayName: displayName,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int chatId,
                required String displayName,
              }) => SendersCompanion.insert(
                id: id,
                chatId: chatId,
                displayName: displayName,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SendersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chatId = false, messagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (messagesRefs) db.messages],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (chatId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.chatId,
                        referencedTable: $$SendersTableReferences._chatIdTable(
                          db,
                        ),
                        referencedColumn: $$SendersTableReferences
                            ._chatIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (messagesRefs)
                    await $_getPrefetchedData<Sender, $SendersTable, Message>(
                      currentTable: table,
                      referencedTable: $$SendersTableReferences
                          ._messagesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SendersTableReferences(db, table, p0).messagesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.senderId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SendersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SendersTable,
      Sender,
      $$SendersTableFilterComposer,
      $$SendersTableOrderingComposer,
      $$SendersTableAnnotationComposer,
      $$SendersTableCreateCompanionBuilder,
      $$SendersTableUpdateCompanionBuilder,
      (Sender, $$SendersTableReferences),
      Sender,
      PrefetchHooks Function({bool chatId, bool messagesRefs})
    >;
typedef $$MessagesTableCreateCompanionBuilder = MessagesCompanion Function({
  Value<int> id,
  required int chatId,
  Value<int?> senderId,
  required DateTime timestamp,
  required String rawText,
  Value<bool> isSystemMessage,
  Value<String?> mediaPlaceholderType,
  required int sortIndex,
});
typedef $$MessagesTableUpdateCompanionBuilder = MessagesCompanion Function({
  Value<int> id,
  Value<int> chatId,
  Value<int?> senderId,
  Value<DateTime> timestamp,
  Value<String> rawText,
  Value<bool> isSystemMessage,
  Value<String?> mediaPlaceholderType,
  Value<int> sortIndex,
});

final class $$MessagesTableReferences
    extends BaseReferences<_$AppDatabase, $MessagesTable, Message> {
  $$MessagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChatsTable _chatIdTable(_$AppDatabase db) =>
      db.chats.createAlias('messages__chat_id__chats__id');

  $$ChatsTableProcessedTableManager get chatId {
    final $_column = $_itemColumn<int>('chat_id')!;

    final manager = $$ChatsTableTableManager(
      $_db,
      $_db.chats,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chatIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SendersTable _senderIdTable(_$AppDatabase db) =>
      db.senders.createAlias('messages__sender_id__senders__id');

  $$SendersTableProcessedTableManager? get senderId {
    final $_column = $_itemColumn<int>('sender_id');
    if ($_column == null) return null;
    final manager = $$SendersTableTableManager(
      $_db,
      $_db.senders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_senderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ImageAttachmentsTable, List<ImageAttachment>>
  _imageAttachmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.imageAttachments,
    aliasName: 'messages__id__image_attachments__message_id',
  );

  $$ImageAttachmentsTableProcessedTableManager get imageAttachmentsRefs {
    final manager = $$ImageAttachmentsTableTableManager(
      $_db,
      $_db.imageAttachments,
    ).filter((f) => f.messageId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _imageAttachmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MessagesTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawText => $composableBuilder(
    column: $table.rawText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystemMessage => $composableBuilder(
    column: $table.isSystemMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaPlaceholderType => $composableBuilder(
    column: $table.mediaPlaceholderType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$ChatsTableFilterComposer get chatId {
    final $$ChatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableFilterComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SendersTableFilterComposer get senderId {
    final $$SendersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.senderId,
      referencedTable: $db.senders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SendersTableFilterComposer(
            $db: $db,
            $table: $db.senders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> imageAttachmentsRefs(
    Expression<bool> Function($$ImageAttachmentsTableFilterComposer f) f,
  ) {
    final $$ImageAttachmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.imageAttachments,
      getReferencedColumn: (t) => t.messageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImageAttachmentsTableFilterComposer(
            $db: $db,
            $table: $db.imageAttachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawText => $composableBuilder(
    column: $table.rawText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystemMessage => $composableBuilder(
    column: $table.isSystemMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaPlaceholderType => $composableBuilder(
    column: $table.mediaPlaceholderType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChatsTableOrderingComposer get chatId {
    final $$ChatsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableOrderingComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SendersTableOrderingComposer get senderId {
    final $$SendersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.senderId,
      referencedTable: $db.senders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SendersTableOrderingComposer(
            $db: $db,
            $table: $db.senders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get rawText =>
      $composableBuilder(column: $table.rawText, builder: (column) => column);

  GeneratedColumn<bool> get isSystemMessage => $composableBuilder(
    column: $table.isSystemMessage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mediaPlaceholderType => $composableBuilder(
    column: $table.mediaPlaceholderType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortIndex =>
      $composableBuilder(column: $table.sortIndex, builder: (column) => column);

  $$ChatsTableAnnotationComposer get chatId {
    final $$ChatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableAnnotationComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SendersTableAnnotationComposer get senderId {
    final $$SendersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.senderId,
      referencedTable: $db.senders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SendersTableAnnotationComposer(
            $db: $db,
            $table: $db.senders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> imageAttachmentsRefs<T extends Object>(
    Expression<T> Function($$ImageAttachmentsTableAnnotationComposer a) f,
  ) {
    final $$ImageAttachmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.imageAttachments,
      getReferencedColumn: (t) => t.messageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImageAttachmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.imageAttachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessagesTable,
          Message,
          $$MessagesTableFilterComposer,
          $$MessagesTableOrderingComposer,
          $$MessagesTableAnnotationComposer,
          $$MessagesTableCreateCompanionBuilder,
          $$MessagesTableUpdateCompanionBuilder,
          (Message, $$MessagesTableReferences),
          Message,
          PrefetchHooks Function({
            bool chatId,
            bool senderId,
            bool imageAttachmentsRefs,
          })
        > {
  $$MessagesTableTableManager(_$AppDatabase db, $MessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> chatId = const Value.absent(),
                Value<int?> senderId = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> rawText = const Value.absent(),
                Value<bool> isSystemMessage = const Value.absent(),
                Value<String?> mediaPlaceholderType = const Value.absent(),
                Value<int> sortIndex = const Value.absent(),
              }) => MessagesCompanion(
                id: id,
                chatId: chatId,
                senderId: senderId,
                timestamp: timestamp,
                rawText: rawText,
                isSystemMessage: isSystemMessage,
                mediaPlaceholderType: mediaPlaceholderType,
                sortIndex: sortIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int chatId,
                Value<int?> senderId = const Value.absent(),
                required DateTime timestamp,
                required String rawText,
                Value<bool> isSystemMessage = const Value.absent(),
                Value<String?> mediaPlaceholderType = const Value.absent(),
                required int sortIndex,
              }) => MessagesCompanion.insert(
                id: id,
                chatId: chatId,
                senderId: senderId,
                timestamp: timestamp,
                rawText: rawText,
                isSystemMessage: isSystemMessage,
                mediaPlaceholderType: mediaPlaceholderType,
                sortIndex: sortIndex,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                chatId = false,
                senderId = false,
                imageAttachmentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (imageAttachmentsRefs) db.imageAttachments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (chatId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.chatId,
                            referencedTable: $$MessagesTableReferences
                                ._chatIdTable(db),
                            referencedColumn: $$MessagesTableReferences
                                ._chatIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (senderId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.senderId,
                            referencedTable: $$MessagesTableReferences
                                ._senderIdTable(db),
                            referencedColumn: $$MessagesTableReferences
                                ._senderIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (imageAttachmentsRefs)
                        await $_getPrefetchedData<
                          Message,
                          $MessagesTable,
                          ImageAttachment
                        >(
                          currentTable: table,
                          referencedTable: $$MessagesTableReferences
                              ._imageAttachmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MessagesTableReferences(
                                db,
                                table,
                                p0,
                              ).imageAttachmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.messageId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessagesTable,
      Message,
      $$MessagesTableFilterComposer,
      $$MessagesTableOrderingComposer,
      $$MessagesTableAnnotationComposer,
      $$MessagesTableCreateCompanionBuilder,
      $$MessagesTableUpdateCompanionBuilder,
      (Message, $$MessagesTableReferences),
      Message,
      PrefetchHooks Function({
        bool chatId,
        bool senderId,
        bool imageAttachmentsRefs,
      })
    >;
typedef $$ImageAttachmentsTableCreateCompanionBuilder =
    ImageAttachmentsCompanion Function({
      Value<int> id,
      required int chatId,
      Value<int?> messageId,
      required String localFilePath,
      required DateTime addedAt,
    });
typedef $$ImageAttachmentsTableUpdateCompanionBuilder =
    ImageAttachmentsCompanion Function({
      Value<int> id,
      Value<int> chatId,
      Value<int?> messageId,
      Value<String> localFilePath,
      Value<DateTime> addedAt,
    });

final class $$ImageAttachmentsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ImageAttachmentsTable, ImageAttachment> {
  $$ImageAttachmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ChatsTable _chatIdTable(_$AppDatabase db) =>
      db.chats.createAlias('image_attachments__chat_id__chats__id');

  $$ChatsTableProcessedTableManager get chatId {
    final $_column = $_itemColumn<int>('chat_id')!;

    final manager = $$ChatsTableTableManager(
      $_db,
      $_db.chats,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chatIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MessagesTable _messageIdTable(_$AppDatabase db) =>
      db.messages.createAlias('image_attachments__message_id__messages__id');

  $$MessagesTableProcessedTableManager? get messageId {
    final $_column = $_itemColumn<int>('message_id');
    if ($_column == null) return null;
    final manager = $$MessagesTableTableManager(
      $_db,
      $_db.messages,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_messageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ImageAttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $ImageAttachmentsTable> {
  $$ImageAttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ChatsTableFilterComposer get chatId {
    final $$ChatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableFilterComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MessagesTableFilterComposer get messageId {
    final $$MessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableFilterComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImageAttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ImageAttachmentsTable> {
  $$ImageAttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChatsTableOrderingComposer get chatId {
    final $$ChatsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableOrderingComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MessagesTableOrderingComposer get messageId {
    final $$MessagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableOrderingComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImageAttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImageAttachmentsTable> {
  $$ImageAttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  $$ChatsTableAnnotationComposer get chatId {
    final $$ChatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableAnnotationComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MessagesTableAnnotationComposer get messageId {
    final $$MessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImageAttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImageAttachmentsTable,
          ImageAttachment,
          $$ImageAttachmentsTableFilterComposer,
          $$ImageAttachmentsTableOrderingComposer,
          $$ImageAttachmentsTableAnnotationComposer,
          $$ImageAttachmentsTableCreateCompanionBuilder,
          $$ImageAttachmentsTableUpdateCompanionBuilder,
          (ImageAttachment, $$ImageAttachmentsTableReferences),
          ImageAttachment,
          PrefetchHooks Function({bool chatId, bool messageId})
        > {
  $$ImageAttachmentsTableTableManager(
    _$AppDatabase db,
    $ImageAttachmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImageAttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImageAttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImageAttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> chatId = const Value.absent(),
                Value<int?> messageId = const Value.absent(),
                Value<String> localFilePath = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
              }) => ImageAttachmentsCompanion(
                id: id,
                chatId: chatId,
                messageId: messageId,
                localFilePath: localFilePath,
                addedAt: addedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int chatId,
                Value<int?> messageId = const Value.absent(),
                required String localFilePath,
                required DateTime addedAt,
              }) => ImageAttachmentsCompanion.insert(
                id: id,
                chatId: chatId,
                messageId: messageId,
                localFilePath: localFilePath,
                addedAt: addedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ImageAttachmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chatId = false, messageId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (chatId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.chatId,
                        referencedTable: $$ImageAttachmentsTableReferences
                            ._chatIdTable(db),
                        referencedColumn: $$ImageAttachmentsTableReferences
                            ._chatIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (messageId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.messageId,
                        referencedTable: $$ImageAttachmentsTableReferences
                            ._messageIdTable(db),
                        referencedColumn: $$ImageAttachmentsTableReferences
                            ._messageIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ImageAttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImageAttachmentsTable,
      ImageAttachment,
      $$ImageAttachmentsTableFilterComposer,
      $$ImageAttachmentsTableOrderingComposer,
      $$ImageAttachmentsTableAnnotationComposer,
      $$ImageAttachmentsTableCreateCompanionBuilder,
      $$ImageAttachmentsTableUpdateCompanionBuilder,
      (ImageAttachment, $$ImageAttachmentsTableReferences),
      ImageAttachment,
      PrefetchHooks Function({bool chatId, bool messageId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ChatsTableTableManager get chats =>
      $$ChatsTableTableManager(_db, _db.chats);
  $$SendersTableTableManager get senders =>
      $$SendersTableTableManager(_db, _db.senders);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
  $$ImageAttachmentsTableTableManager get imageAttachments =>
      $$ImageAttachmentsTableTableManager(_db, _db.imageAttachments);
}
