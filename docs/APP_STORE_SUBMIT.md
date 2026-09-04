# App Store 提出手順（トーク保存 / line_talk_saver）

Bundle ID: **`com.yousaku.lineTalkSaver`** / Share Extension: `com.yousaku.lineTalkSaver.ShareExtension`
Apple ID: yousaku2222@gmail.com（有料 Apple Developer Program）

コード側は提出可能な状態。以下はアカウント作業＋Xcode 作業。

---

## 0. 事前チェック（コードは対応済み）

- [x] アプリアイコン（`ios/Runner/Assets.xcassets/AppIcon.appiconset/`）
- [x] `NSUserTrackingUsageDescription`（ATT 文言）
- [x] `GADApplicationIdentifier` = `ca-app-pub-3818461038959537~5614922743`
- [x] `SKAdNetworkItems`（40件）
- [x] `ITSAppUsesNonExemptEncryption = false`（毎回の輸出コンプライアンス質問を省略）
- [x] `NSPhotoLibraryUsageDescription` / `NSPhotoLibraryAddUsageDescription`
- [x] iOS Deployment Target 15.0
- [x] プライバシーポリシー: https://sites.google.com/view/line-talk-saver-privacy/ホーム

## 1. Apple Developer Portal

1. https://developer.apple.com/account → **Certificates, Identifiers & Profiles**
2. **Identifiers** に App ID を2つ登録（未登録なら）
   - `com.yousaku.lineTalkSaver`（App）— Capabilities: **App Groups**, **In-App Purchase**
   - `com.yousaku.lineTalkSaver.ShareExtension`（App Extension）— Capabilities: **App Groups**
3. **App Groups** に `AppGroupId`（`ios/Runner/Info.plist` / `ios/ShareExtension/Info.plist` の
   `$(CUSTOM_GROUP_ID)` に対応するグループ）を作成し、上記2つの App ID に紐付け
4. 署名は Xcode の **Automatically manage signing** に任せてよい（Distribution 証明書・
   Provisioning Profile を自動生成）

## 2. App Store Connect でアプリ作成

1. https://appstoreconnect.apple.com → マイ App → **＋ → 新規 App**
   - プラットフォーム: iOS
   - 名前: **Talk Saver**（表示名。ストア掲載名は「トーク保存」で統一）
   - プライマリ言語: 日本語
   - バンドル ID: `com.yousaku.lineTalkSaver`
   - SKU: `line_talk_saver` など任意
   - ユーザーアクセス: フルアクセス
2. **App 情報**
   - サブタイトル: `トーク履歴を保存・検索・書き出し`
   - カテゴリ: プライマリ **仕事効率化**（または **ツール**。セカンダリ任意）
   - コンテンツ配信権: 該当なし
3. **価格および配信状況**: 無料 / 全地域（または日本のみ）

> ⚠ ストアのタイトル・簡単な説明には他社サービス名（LINE 等）を入れない。詳しい説明は
> 「取り込めるファイルの説明」としての事実記載のみに留め、特定 SNS 事業者とは無関係の
> 非公式アプリである旨を明記する（`store_listing/play_store_listing.md` の注記を踏襲）。

## 3. アプリ内課金（買い切り2種）

**App 内課金 → ＋ → 非消耗型** を2件作成。製品 ID はコード側 `ProductIds`
（`lib/features/monetization/purchase/purchase_service.dart`）と完全一致させること。

- `remove_ads` — 広告を非表示にする
  - 表示名（日本語）: `広告を非表示`
  - 説明: `バナー広告を非表示にします。着せ替えテーマ・チャットアイコンも全解放されます。`
- `backup_unlock` — バックアップ機能（作成・復元）の解放
  - 表示名（日本語）: `バックアップ機能`
  - 説明: `トークデータのバックアップの作成・復元ができるようになります。`

いずれも価格は Play Console 側の設定に合わせる。審査用スクリーンショットは設定画面の
「データ」グループ（未購入時の🔒表示）を添付。ステータス: **提出準備完了**（アプリ本体の
バージョンと一緒に審査へ）。

## 4. バージョン情報

- **スクリーンショット**: `store_listing/screenshots/` を iOS 用サイズ（6.9インチ =
  1320×2868 等）に作り直して使用。既存は Android 用。
  `--dart-define=SCREENSHOT=true` で広告バナーを隠して撮影可能
- **プロモーションテキスト / 概要 / キーワード**: `store_listing/play_store_listing.md` を
  ベースに文字数制限（App Store は概要4000字・キーワード100字）に合わせて調整
- **サポート URL**: 連絡先メール `yousaku2222@gmail.com`（専用ページがあれば差し替え）
- **マーケティング URL**: 任意
- **著作権**: `2026 Yusaku Mizogami`
- **バージョン**: `pubspec.yaml` の `version:`（`1.1.0+5` 以降を想定。次回提出前に
  ビルド番号を上げてビルドし直すこと）

## 5. App のプライバシー（Nutrition Label）

「データの収集」→ **はい**（AdMob が収集）。以下を申告：

| データ種別 | 収集 | 目的 | ユーザーにリンク | トラッキング |
|---|---|---|---|---|
| **識別子 → デバイス ID** | はい | サードパーティ広告 | いいえ | **はい** |
| **位置情報 → おおよその位置情報** | はい | サードパーティ広告 | いいえ | はい |
| **使用状況データ → 製品操作** | はい | 分析 / サードパーティ広告 | いいえ | はい |
| **購入 → 購入履歴** | いいえ（IAP は Apple 課金経由、開発者は取得しない） | — | — | — |

- 「トラッキングに使用」= はい（ATT プロンプトを表示）
- 取り込んだトーク内容・写真・バックアップは**端末内のみ**。開発者は取得しないので申告不要。

## 6. Xcode でアーカイブ＆アップロード

> ⚠ `flutter build ipa --release` は初回は **CodeSign failed** で失敗しうる。
> 手元に "Apple **Development**" 証明書しかない場合、App Store 配布には
> "Apple **Distribution**" 証明書＋App Store プロビジョニングプロファイルが要る。
> これらは **Xcode の Archive フロー**が（アカウントにサインインしていれば）
> 自動生成するので、下記の GUI 手順で行う。

事前: **Xcode ▸ Settings ▸ Accounts** に Apple ID（yousaku2222@gmail.com）を追加。

1. `open ios/Runner.xcworkspace`
2. TARGETS ▸ Runner / ShareExtension の Signing & Capabilities で
   **Automatically manage signing** ✔ / Team = 自分のチーム
3. スキーム **Runner** / 宛先 **Any iOS Device (arm64)**（シミュレータ不可）
4. **Product ▸ Archive**
   - 初回は「Apple Distribution 証明書を作成しますか？」に許可 → 自動作成
5. Organizer が開く → 対象アーカイブを選択 ▸ **Distribute App**
   ▸ **App Store Connect** ▸ **Upload**
   - ShareExtension も自動で同梱・署名される
   - 「Upload your app's symbols」「Manage Version and Build Number」はデフォルトでOK
6. アップロード完了後、App Store Connect の「TestFlight」/「App Store ▸ ビルド」に
   反映（処理に数分〜30分、完了メールが来る）

（CLI で通したい場合は、上記 Archive を一度 GUI で通して Distribution 証明書と
プロファイルを作った後、`flutter build ipa --export-method app-store` が使える）

## 7. 審査へ提出

- バージョン画面でビルドを選択
- **App Review に関する情報**: 連絡先、`サインイン不要`（アカウント無し）
- **備考**: 9章の「Notes欄テンプレート」を使う（2026-09-01の Guideline 2.1 差し戻しを受けて拡充）
- **年齢制限**: コンテンツに応じて（暴力等なし → 4+ 相当。IARC は不要、Apple 独自質問に
  「なし」で回答）
- 「**手動でリリース**」推奨（審査通過後に自分のタイミングで公開）

## 8. TestFlight（任意・推奨）

審査前に内部テスターへ配布して実機確認できる。ビルドアップロード後、
TestFlight タブ → 内部テスターグループに追加 → 各自の TestFlight アプリで取得。

## 9. 却下対応: Guideline 2.1 - Information Needed（2026-09-01）

提出ID `a4f3a50f-ba92-4a5a-ab1a-d1694d0751e7`（1.1.0(5)）が「情報不足」で差し戻された。
バグではなく、App Review Information に記載すべき情報が足りないという指摘。
対応は **画面録画1本の用意** と **Notes欄テキストの提出**、それを
App Store Connect の当該メッセージ「App Reviewに返信」から送る。

### 9-1. 画面録画（実機・最新OS）

iPhone実機の画面収録機能で撮影し、そのまま添付するか動画リンク（Google Drive等）を返信に貼る。
1本の録画に、次の流れを続けて収める:

1. アプリ起動
2. .txt トーク履歴ファイルを共有シート/ファイル選択から取り込み、保存・一覧表示・検索を一通り操作
3. ATT（トラッキング許可）ダイアログの表示（許可/拒否いずれでも可、表示自体を映す）
4. 設定画面の「広告を非表示」「バックアップ機能」の購入ボタンをタップ →
   Apple の購入確認シート（Sandboxアカウントでの実購入 or サンドボックステスト）→
   購入完了後にロックが解除される様子
5. 設定画面の「購入を復元」をタップし、正常に動作する様子（Guideline 3.1.1 対応の裏付け）

※ アカウント登録・ログイン・ユーザー生成コンテンツの通報/ブロックはこのアプリに存在しないため録画不要。
※ 写真ライブラリへのアクセス許可ダイアログは、写真選択に PHPickerViewController（Appleのプライバシー配慮ピッカー）を
  使っているため原理的に表示されない。Notes欄でその旨を説明する（9-2参照）。

### 9-2. Notes欄テンプレート（返信本文にそのまま貼る）

```
Note: this build (1.1.0(6)) also includes a fix so the App Tracking Transparency
prompt is correctly requested on first launch, in addition to the information
below addressing the previous Information Needed request.

This app does not require account registration, sign-in, or any login credentials.
All imported chat data and backups are stored locally on the device only; nothing is
sent to a server. A screen recording is attached showing app launch, importing a
.txt chat export, browsing/searching saved talks, the App Tracking Transparency
prompt, and the in-app purchase flow for both products (including restoring
purchases). Photo/video selection uses iOS's native PHPickerViewController, which by
Apple's own privacy design does not show a system permission prompt -- the app never
gains broad photo library access, so no such prompt appears in the recording.

1. Devices/OS tested for this submission: iPhone 16 Pro Max (iOS 26.6.1)

2. App function & target audience: 「トーク保存」lets users import a chat history
   .txt file exported from a messaging app's own "send chat as text" feature, then
   save, search, and re-export it in a readable format. Target users are people who
   want to keep a personal, searchable archive of their own chat exports before the
   original conversation is deleted or the app is uninstalled.

3. Setup / accessing main features: No login or account is required. From the home
   screen, tap the import button (or share a .txt file into the app via the iOS
   share sheet) to add a chat log; saved talks appear in the list and can be opened,
   searched, or exported. No credentials or sample files are needed to review any
   feature.

4. External services/tools used: Google AdMob (banner and rewarded ads only,
   ca-app-pub-3818461038959537). Apple's own In-App Purchase system processes the
   two non-consumable products. No backend server, no third-party authentication,
   no AI service, and no other external data provider is used; all user data stays
   on-device.

5. Regional differences: None. All features function identically in every region;
   no content varies by locale.

6. Regulated industry / protected third-party material: Not applicable. This is an
   independent, unofficial utility app for viewing text files the user already
   exported from their own chat app. It is not affiliated with, and does not
   automate, control, or scrape any messaging service.

7. In-App Purchase summary: Two non-consumable (one-time) purchases, both
   accessible from the in-app Settings screen:
   - remove_ads: removes all banner ads and unlocks all optional theme skins and
     chat icons that were otherwise earned via rewarded ads.
   - backup_unlock: unlocks the backup feature (create and restore a local backup
     of saved talks).
   Neither is a subscription; there is no recurring billing.
   Note: in the recorded Sandbox test session, StoreKit occasionally completed the
   purchase without displaying the payment confirmation sheet (a known Sandbox
   testing behavior, not something the app controls); the purchase and subsequent
   unlock still complete correctly, as shown in the recording.
```

### 9-3. 返信手順

1. App Store Connect → 対象アプリ → 配信 → 該当バージョン → メッセージの
   「App Reviewに返信」を開く
2. 9-2 のテキストを貼り、機種/OSの実値に書き換え
3. 9-1 の録画ファイル（または共有リンク）を添付
4. 送信後、ビルド自体は「編集」から必要なら再アップロードし、**App Reviewに再提出**
5. 今後の提出でも同様の指摘を避けるため、以後は本セクションの内容を毎回
   App Review Information の Notes欄に事前記載しておく

## 10. 2回目の却下対応: Guideline 2.1.0 Performance: App Completeness（2026-09-03）

9章の返信後、同じSubmission ID (`a4f3a50f-...`) で再度却下。審査担当が添付した
スクリーンショットは、アプリの「Import a chat」アイドル画面そのもの
（Open LINE / Choose a file の待機状態）。審査対象ビルドは(5)のままだった
（返信テキストだけでは新ビルドは審査に反映されないと判明）。

原因は2つ複合していた（[[reference_testflight_review_recording_gotchas]]に詳細）:

1. LINE**iOS版**の書き出しは時刻が「午前9:00」のような12時間表記（Android版は24時間表記）で、
   パーサーが対応しておらず0件パースになっていた → `line_txt_parser.dart`修正（build 7）
2. LINEの共有シートから直接渡すルート（ShareExtension経由）が、Runnerターゲットの
   App Groups設定が誤って別アプリ（`group.com.annivapp.anniv`）を指していたため、
   共有ファイルがアプリ本体に渡っていなかった → Xcode Signing & Capabilitiesで
   正しいApp Group (`group.com.yousaku.line_talk_saver`) にチェックを直し、
   配布用プロビジョニングプロファイルを再生成（build 9）

build 1.1.0(9)で両方とも実機・TestFlight経由で動作確認済み。

### 10-1. 返信テキスト（2回目）

```
Thank you for the detailed feedback and for including a screenshot -- it was very
helpful. We were able to reproduce the exact issue and have fixed it in this build
(1.1.0 (9)).

Two distinct bugs combined to cause the import failure your reviewer encountered:

1. LINE's iOS "Send Chat as Text" export uses a 12-hour time format with a Japanese
   AM/PM prefix (e.g. "午後3:15"), while our parser only recognized the 24-hour
   format used by LINE's Android export. This caused zero messages to be parsed
   from an iOS-exported chat file.

2. When a chat .txt file is shared directly from LINE's share sheet (rather than
   picked manually inside the app), our Share Extension hands the file to the main
   app via an iOS App Group. Our main app target's App Group entitlement was
   misconfigured, so the shared file never reached the app -- the share sheet
   silently returned to the empty "Import a chat" screen, which matches the
   screenshot you attached.

Both issues are fixed in build 1.1.0 (9), which is now attached to this
submission. We verified on a physical device that chat history imports correctly
both via LINE's share sheet and via manual file selection inside the app.
```

### 10-2. 返信手順（差分のみ）

1. 配信ページの却下バージョンで、ビルドを最新のもの（このときは(9)）に差し替えてから返信する
   （返信だけでは審査対象ビルドは変わらないので必ず先にビルド差し替え）
2. 10-1 のテキストを貼って送信 → 再提出
