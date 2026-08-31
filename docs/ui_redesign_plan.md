# トーク保存 — UIリニューアル 実装計画

作成日: 2026-08-30 / 対象アプリ: `com.yousaku.line_talk_saver`（表示名「トーク保存」/ "Talk Saver"）

## 0. 背景と狙い

現状のUIは `ColorScheme.fromSeed(0xFF06C755)`（LINE緑）+ Material 3 デフォルトのまま。
機能は揃っているが、次の4点が弱い。

1. **見た目の刷新** — 素のM3テーマで、余白・タイポ・階層に意図が感じられない
2. **使いやすさ** — トーク一覧の行が操作アイコンで詰まっている / 詳細画面のAppBarにアイコン5個 / 取り込み・書き出しシートが素っ気ない
3. **ブランド確立** — LINE緑を主役に使っており、商標的にもアイデンティティ的にも借り物。アプリ名「トーク保存」に合うロゴ・配色・トーンがない
4. **ストア映え** — スクリーンショットにしたときの「作り込み感」が出ない

このリニューアルは **デザインシステムの土台づくり → 画面ごとの適用** の順で行う。
機能・データモデル・ルーティングは原則変更しない（UIレイヤのみ）。

### デザイン原則

- **「記録を残す道具」** としての落ち着き。チャットUIの模倣ではなく、読み返し・書き出しに向いた"トランスクリプト"の見やすさを優先する（現状の左寄せ一列レイアウトは維持）
- 情報の主役はトーク本文。操作は控えめに、必要なときだけ前に出す
- 1画面1主要アクション。副次アクションはオーバーフローメニュー/シートへ
- ライト/ダーク両対応。日本語（主）+ 6言語の可変長テキストで崩れない
- 端末内完結・広告ありという事実をUIで隠さない（バナー枠は残す前提で設計）
- **ビジュアルトーン: Anniv 風（記念日アプリ Anniv / TheDayBefore 系）**。大きめの数字表示、写真ヘッダー（暗めグラデーションのオーバーレイ）、淡いパステル配色、たっぷりの余白、角丸の強いカード。「大事なやり取りを、思い出として残す」という情緒に寄せる

---

## 1. デザインシステム基盤（Phase 1）

### 1.1 デザイントークン `lib/core/theme/`

新規 `tokens.dart` に定数化。

| 種別 | トークン | 値（案） |
|---|---|---|
| 角丸 | `radiusSm / Md / Lg / Xl / Pill` | 12 / 16 / 20 / 26 / 999 |
| 余白 | `space1..6` | 4 / 8 / 12 / 16 / 24 / 32 |
| 画面パディング | `screenPadding` | 20（横。Anniv 風の余白を広めに） |
| 影 | `shadowCard` | `0 8px 24px rgba(43,39,48,.08)`（浮いたカードのみ。基本は 1px `line` + 極薄影） |
| アニメ | `motionFast / Base` | 150ms / 250ms, `Curves.easeOutCubic` |

### 1.2 カラー

LINE緑（`#06C755`）は主役から外す。Anniv 風の **淡いパステル**を基調に、アクセントは
くすんだコーラル1色。写真ヘッダーの上に白文字を載せる前提で、地色は温かみのあるアイボリー。

**デフォルトテーマ「ペーパー」（ライト）**:

| ロール | 値 | 用途 |
|---|---|---|
| `accent` | `#E5988A`（ダスティコーラル） | 主要ボタン、選択状態、送信者名、数字強調 |
| `accentSoft` | `#F7E5DF`（ペールピーチ） | チップ、バッジ、アイコン面、自分の吹き出し |
| `accent2` | `#B9A7D6`（ソフトラベンダー） | 副アクセント（2人目の送信者色・テーマ差し色） |
| `paper` | `#F5F1EA`（アイボリー） | 画面地 |
| `card` | `#FFFFFF` | カード、シート |
| `surfaceMuted` | `#F1EEE9` | 相手の吹き出し、淡い面 |
| `line` | `#EAE3DA` | 区切り線、枠 |
| `ink / inkSoft` | `#2B2730` / `#8A8390` | 本文 / 補助 |
| `danger` | `#B3564A`（コーラル寄りに調整） | 削除、ロック中表示 |
| 写真オーバーレイ | `linear-gradient(to top, rgba(24,18,24,.72), rgba(24,18,24,.05))` | 写真ヘッダーの可読性確保 |

- `ColorScheme.fromSeed(seedColor: accent)` を基点に上記を `copyWith`
- ダーク（テーマ「ナイト」）は `paper #1B1820` / `card #262029` / `ink #F2ECEF`、`accent` は明度を上げた `#EBA99B`
- 配色は**着せ替え（§2.10）で差し替え可能**にする。上記はビルトインテーマの1つ「ペーパー」として定義し、
  他テーマも同じ ロール名でトークンセットを持つ（`AppThemePalette` を Riverpod で供給）
- **移行**: `AppTheme.seedColor` 参照箇所はトークン参照に置換

### 1.3 タイポグラフィ

- バンドル済み `assets/fonts/NotoSansJP-Regular.ttf` を **アプリ全体の既定フォント**に。
  `ThemeData(fontFamily: 'NotoSansJP')` + pubspec の `fonts:` セクションで family 登録
  （現状 asset 参照のみで family 未登録 → 追加）。Bold 用に `NotoSansJP-Bold.ttf` を追加同梱
- Noto Sans JP は w300/400/500/700 を同梱（Anniv 風の大きな数字・見出しに w300 を使う）
- タイプスケール（M3 の `textTheme` を `copyWith`）:
  - `displaySmall` 44/w300 / letter-spacing -0.02em（一覧の件数、着せ替えプレビューの日数など大きな数字）
  - `titleLarge` 22/w700（画面タイトル）
  - `titleMedium` 16/w700（セクション見出し、シート見出し）
  - `bodyLarge` 15/w400（メッセージ本文）
  - `bodyMedium` 14/w400（一覧サブタイトル、説明文）
  - `labelLarge` 13/w700（ボタン、送信者名）
  - `labelSmall` 11/w500 / letter-spacing .04em（タイムスタンプ、バッジ、セクションラベル）

### 1.4 共通コンポーネント `lib/core/ui/`

| Widget | 用途 | 置き換え対象 |
|---|---|---|
| `AppScaffold` | AppBar スタイル統一 + 下部バナー枠を1箇所に集約 | 各画面の `Scaffold` + `DismissibleBannerAd` の重複 |
| `SectionHeader` | 設定・ヘルプ・シートの見出し | 直書き `Text` |
| `AppListCard` | 角丸・境界線つきカード行（一覧、設定グループ） | 生 `ListTile` + `Divider` |
| `EmptyState` | アイコン/イラスト + 見出し + 説明 + CTA | `_EmptyState`（一覧）, `_IdleView`（取り込み） |
| `SheetShell` | ドラッグハンドル + 見出し + 本体パディングの共通枠 | 各 `showModalBottomSheet` の中身 |
| `PrimaryButton / SecondaryButton` | 高さ・角丸・タイポ統一 | `FilledButton` / `OutlinedButton` 直書き |
| `BrandLogo` | ワードマーク（テキストロゴ）。空状態・設定フッターで使用 | なし（新規） |

### 1.5 ブランド資産

- **ワードマーク**: 「トーク保存」を NotoSansJP Bold + 吹き出しグリフの簡易ロゴ。SVG or `CustomPainter`
- **アプリアイコン刷新**: 吹き出し＋"保存/しおり"のモチーフ、地色は `brandPrimary`〜ミントのグラデ。
  `flutter_launcher_icons` 設定（`assets/icon/icon.png`, `icon_foreground.png`, `adaptive_icon_background`）を更新
- **プレースホルダーイラスト**: 空状態・取り込み idle 用に線画イラスト2点（`assets/illustrations/`）

---

## 2. 画面別リデザイン（Phase 2）

### 2.1 トーク一覧 `chat_list_screen.dart`

**問題**: 行末に IconButton 2個（ロック/リネーム）で常時ごちゃつく。サブタイトルが「取込日時」のみで情報価値が低い。空状態が地味。

**変更**:
- 行を `AppListCard` 化（角丸12・境界線・行間 `space3`、`Divider` 廃止）
- leading: アイコンアバターは維持。手動フォトルームのバッジは右下ドット→**leadingの下に小ラベル**か、アバター色を変える方式に
- title: トーク名（+ ロック中は先頭に `lock` 小アイコン、色 `danger`）
- subtitle: **「◯件・YYYY/MM/DD〜MM/DD」**（メッセージ数と期間）に変更。取込日時は詳細/情報シートへ
- trailing: IconButton 2個を廃止 → 行の **オーバーフロー `⋮`** に「名前を変更」「ロック」「削除」を集約。スワイプ削除は維持
- 上部に **検索バー**（一覧内フィルタ: トーク名の絞り込み）。将来「全トーク横断検索」への足がかり
- FAB: `FloatingActionButton.extended`「トークを取り込む」は維持、配色をブランド化。新規ルーム作成（現 AppBar の `add_comment`）は FAB のロングプレス or 一覧末尾の「+ フォトルームを作る」行へ移動しても良い（要検討）
- 空状態: `EmptyState`（イラスト + 「まだトークがありません」+ 「LINEのトークを取り込む」主ボタン + 「使い方を見る」副リンク）

### 2.2 トーク詳細 / タイムライン `chat_detail_screen.dart` + `message_bubble.dart`

**問題**: AppBar にアクション5個（写真/フィルタ/全コピー/書き出し + 選択モードで別2個）。バブルの区切りが弱く日付の境界が分からない。メディア添付のタップ領域が地味。

**変更（レイアウトの骨格は維持: 左寄せ一列トランスクリプト）**:
- AppBar アクションを整理:
  - 常時表示: **フィルタ**（`filter_list` + 有効時ドット）、**書き出し**（`ios_share`）
  - `⋮` オーバーフロー: 「写真ギャラリー」「すべてコピー」
- **日付セパレータ**を追加: 日付が変わる位置に中央チップ（`surfaceContainer` / `labelSmall`）。`ListView.builder` の itemBuilder で前メッセージと日付比較して挿入
- メッセージ行:
  - 送信者名 `labelLarge`・色は **送信者ごとに固定パレット**（`brandPrimary` を基準に2〜4色をハッシュ割当）。「自分」は固定色
  - タイムスタンプ `labelSmall` / `textSecondary`
  - 本文バブル: 角丸 `radiusMd`、地 `surfaceContainer`、行間ゆとり。連続発言（同一送信者・5分以内）は**名前・時刻を省略しバブルだけ**にして密度を下げる
  - システムメッセージ: 中央 `labelSmall` + 上下 `space3`、必要なら細い区切り線
- メディアプレースホルダー（未添付）: 破線枠 + アイコン + 「タップで写真を追加」。添付済みはサムネの角丸統一（`radiusMd`）
- 選択モード: AppBar を選択カウント表示に切替（`3件を選択`）、下部に操作バー（コピー / 添付解除 / 解除）を出す方式に。行頭チェックは維持
- 保留写真バナー: `surfaceContainerHigh` のまま、`SheetShell` 風の角丸カードに

### 2.3 取り込み `import_screen.dart`

**変更**:
- idle: `EmptyState` ベースに。イラスト + 3ステップの簡易手順（1. LINEでトークを開く → 2. 「トーク履歴をテキストで送信」→ 3. 「トーク保存」を選ぶ）を番号付きで表示。主ボタン「LINEを開く」、副ボタン「ファイルを選ぶ」
- working: スピナー + 「読み込み中…」テキスト
- preview: **カード**内に filename / タイトル / 件数 / 参加者 を並べ、下に **本文の先頭数行プレビュー**（読めることの安心感）。`debugInfo` の生ダンプは畳んで「詳細」トグルの中へ
- error: `EmptyState` の danger バリアント + 「もう一度選ぶ」

### 2.4 書き出しシート `export_options_sheet.dart`

**変更**:
- `SheetShell`（ハンドル + 見出し「形式を選んで書き出す」）
- 3項目を **説明つきカード**に:
  - Excel（.xlsx）— 「表計算アプリで集計・編集」
  - PDF — 「レイアウト固定でそのまま提出・共有」
  - Word（.docx）— 「文書として体裁を整える」
- 生成中はシート内にプログレス（現状は別ダイアログ）→ シートを維持したままボタンをローディングに

### 2.5 検索・絞り込みシート `search_filter_sheet.dart`

**変更**:
- `SheetShell`（ハンドル + 見出し「絞り込み」）
- キーワード入力を最上部・大きめ。`OutlineInputBorder` を `radiusMd` に
- 送信者: `FilterChip` は維持、`brandPrimaryContainer` の選択色
- 期間: ボタン → 選択済みは「期間: 2024/06/08 – 06/10 ×」のチップ表示（クリアしやすく）
- フッター: 「クリア」「適用」。適用時に**絞り込み結果件数**をボタンに出す（`23件を表示`）と親切（任意）

### 2.6 設定 `settings_screen.dart`

**変更**:
- `ListView` を **セクション分け**（`SectionHeader` + `AppListCard` グループ）:
  - 表示 … 着せ替え（テーマ）→ §2.10 / 言語
  - セキュリティ … 起動ロック / アプリ内PIN
  - 購入 … 広告を非表示 / 購入を復元（購入済みなら1行に）
  - データ … バックアップを作成 / バックアップから復元
  - サポート … 取扱説明書 / フィードバック・不具合報告
  - フッター … `BrandLogo` + バージョン（現「アプリのバージョン」タイルを小さくフッターへ）
- 下部バナーは `AppScaffold` 経由に一本化

### 2.7 ヘルプ `help_screen.dart`

**変更**:
- 先頭に短いイントロ + `BrandLogo`
- セクションを**アコーディオン**（`ExpansionTile`）に。初期は「トークを取り込む」だけ開いた状態
- 各セクションにアイコンを付与（取り込み=upload, 一覧=list, 詳細=forum, 添付=image, ロック=lock, バックアップ=backup, データ=shield）
- 末尾に「フィードバックを送る」ボタン（設定と同じ導線）

### 2.8 ロック画面 `app_lock/ui/app_lock_gate.dart` / `pin_entry_dialog.dart`

**変更**:
- ゲート画面: 地色 `brandPrimary` 系、中央に `BrandLogo` + 「ロックを解除」ボタン。現状の素っ気ない表示を刷新
- PIN入力: 大きめのドット表示 + カスタムテンキー（OS キーボード依存をやめる）を検討（任意、後回し可）

### 2.9 アイコン選択シート `pick_chat_icon_sheet.dart` + `chat_icon_options.dart`

**変更**:
- `SheetShell` 化。グリッドの間隔・タップ領域を広げる（`crossAxisCount` 5、セル 56px）
- ロック中アイコンの「🔒」を右下小バッジに戻し、中央被せをやめる（アイコン自体の視認性を上げる）
- リワード広告の説明文をシート上部に常設
- **カテゴリタブ**を追加（よく使う / 人・関係 / 生活 / 趣味 / 季節・記念日 / 記号）。多数になるのでスクロール＋見出し

#### アイコンを 16 → 66 種に拡張し、2色（デュオトーン）イラスト風にする

現状は Material の単色アウトライン 16 個（`chat_icon_options.dart`）。これを **66 個**に増やす。
`Map<String, IconData>` のキー文字列は引き続き永続化（DB 互換のため **追記のみ**。既存 16 キーは温存）。

デュオトーンは段階的に:
- **フェーズ A（実装済み）**: Material の `IconData` のまま、**タイル（`accentSoft` 角丸）＋グリフ（`accentText`）** の
  2 トーン枠で表示（`_ChatCard` / アイコン選択シート）。カテゴリタブ（`chatIconCategories`）付き。
- **フェーズ B（今後）**: 「面＋細い差し色」の本格デュオトーンにするなら `chatIconOptions` の値を
  アイコンビルダー（`Widget Function(Color base, Color detail, double size)`）へ変更し、各キーに
  専用 `CustomPainter` / インライン SVG を用意する。

追加する 50 個を含めた全 66 キー（カテゴリ順）:

- **よく使う(8)**: `chat` `people` `person` `family` `heart` `star` `home` `bookmark`
- **人・関係(12)**: `couple` `friends` `parent_child` `baby` `grandparent` `coworker` `team` `club`
  `partner` `pet_dog` `pet_cat` `group_ring`
- **生活(14)**: `house2` `key` `car` `bicycle` `train` `money` `shopping` `cooking` `medical`
  `study` `work_bag` `phone` `mail` `calendar`
- **趣味(14)**: `camera` `music` `movie` `game` `book` `art` `run` `soccer` `baseball` `mountain`
  `camp` `fishing` `guitar` `travel_bag`
- **季節・記念日(12)**: `sakura` `sun_summer` `maple` `snow` `birthday_cake` `gift` `ring`
  `champagne` `fireworks` `christmas_tree` `new_year` `graduation`
- **記号(6)**: `circle` `square` `triangle` `check` `flag` `sparkle`

（ロック解除は現行仕様どおり: `chat` 以外はリワード広告 1 回で恒久解除。既存キー
`forum→chat` などは移行マップで読み替え、保存済みデータを壊さない）

### 2.10 着せ替え（テーマ）`features/theming/`（新規）

アプリ全体の配色・吹き出し・写真ヘッダーの雰囲気を **テーマ**で差し替える機能。Anniv 風の
「自分好みに飾る」楽しさを持たせる。設定 → 「着せ替え」から専用画面へ。

**画面構成（`ThemePickerScreen`）**:
- 上部に **ライブプレビュー**（選択中テーマでレンダリングしたトーク一覧 or タイムラインのミニチュア）
- その下に **テーマのグリッド**（2〜3列、角丸カード。各カードは配色スウォッチ＋名前、選択中はチェック）
- 下部固定の「適用する」ボタン（無料テーマは即適用、プレミアムテーマは §2.10 課金参照）

**ビルトインテーマ（8）**: `paper`（既定・アイボリー×コーラル）/ `night`（ダーク）/
`sakura`（桜ピンク）/ `mint`（ミント）/ `lavender`（ラベンダー）/ `mono`（モノクロ）/
`ocean`（ブルー）/ `sunset`（夕焼けグラデ）

**実装方針**:
- `AppThemePalette`（`accent` `accentSoft` `paper` `card` `ink` … のロール名で 1 セット）を
  `enum AppThemeId` ごとに定義
- 選択は `shared_preferences`（`app_lock_prefs.dart` 等と同じ流儀）に保存し、Riverpod `themeIdProvider` で供給
- `AppTheme.light()/dark()` を `AppTheme.of(AppThemeId)` に一般化し、`MaterialApp.theme` に反映
- `night` 選択時は `ThemeMode.dark` 相当に。「端末設定に従う」も選択肢として残す
- 収益化: 既定＋2〜3個は無料、残りは「広告を非表示」購入者向け特典 or 個別リワード解除
  （`monetization-agent` と相談。ここでは UI 枠のみ用意）

---

## 3. 実装順序（PR分割）

| PR | 内容 | 目安 |
|---|---|---|
| 1 | Phase 1: `tokens.dart` / `AppTheme` 刷新 / フォント登録 / `textTheme` | 基盤・見た目が一気に変わる |
| 2 | 共通コンポーネント `lib/core/ui/`（`AppScaffold` `SheetShell` `SectionHeader` `EmptyState` `PrimaryButton` 等） | |
| 3 | トーク一覧 リデザイン | |
| 4 | タイムライン + メッセージバブル（日付セパレータ / 連続発言まとめ / 送信者色 / AppBar整理） | 一番作業量が多い |
| 5 | 取り込み画面（idle/preview/error） | |
| 6 | 書き出しシート + 絞り込みシート | |
| 7 | 設定 + ヘルプ | |
| 8 | **デュオトーン・アイコン基盤 + 66 種**（`chatIconOptions` をビルダー化、移行マップ、カテゴリタブ付き選択シート §2.9） | 資産作成量が多い |
| 9 | **着せ替え（テーマ）§2.10**（`AppThemePalette` / `themeIdProvider` / `ThemePickerScreen` / 設定導線） | |
| 10 | ロック画面 + ブランド資産（ワードマーク・イラスト） | |
| 11 | アプリアイコン刷新 + `flutter_launcher_icons` 再生成 | |
| 12 | スクリーンショット撮り直し（下記4章） | ストア用 |

各PRで `flutter analyze` 0件 / `flutter test` 全通過を維持。既存ウィジェットテスト（`widget_test.dart` の「空一覧起動」）が壊れないこと。

---

## 4. スクリーンショット撮り直し（ストア用）

リニューアル完了後に実施。手順は `store_listing/closed_test_checklist.md` の 6章と連動。

- エミュレータ `line_talk_saver_avd`（1080×2400 / density 420）で撮影
- ロケール ja-JP、サンプルは `store_listing/sample_data/` を3件取り込み（山田花子 / チーム開発グループ / 開発チーム）
- **広告バナーの写り込み対策**: テスト広告プレースホルダは見栄えが悪い。撮影時のみ
  `AdService` をビルドフラグ（`--dart-define=SCREENSHOT=true`）で無効化する隠しスイッチを用意するか、
  撮影後に 1080×2160（2:1）へ下部クロップ
- 撮る画面: ①一覧（写真ヘッダー入り・3件）②タイムライン（日付セパレータが見える位置）③着せ替え画面 ④アイコン選択（デュオトーン多数）⑤書き出しシート ⑥取り込み idle（手順表示）
- 保存先 `store_listing/screenshots/00..05_*.png`、`play_store_listing.md` の枚数要件（2〜8枚）を満たす

---

## 5. 非対象（今回やらないこと）

- データモデル / DB スキーマ / パーサ / ルーティングの変更（着せ替え・アイコン選択の保存は `shared_preferences` で完結）
- 収益化ロジック（広告・課金）の仕様変更 — プレミアムテーマ / アイコンの課金設計は `monetization-agent` に委譲、ここでは UI 枠のみ
- 新機能追加（横断検索の"実装"、タグ付け等）— 検索バーは一覧内フィルタに留める
- iOS 固有のデザイン最適化（Cupertino 化）は別途
- 写真ヘッダーの「写真」は当面ユーザーが任意設定（未設定時はテーマ色のグラデーション）。自動取得はしない
