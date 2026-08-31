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
- **備考**:
  ```
  ・チャットアプリの「トーク履歴をテキストで送信」機能で書き出した.txtファイルを取り込み、
    見返しやすい形で保存・検索・書き出しできるアプリです。特定のSNS事業者とは
    関係のない非公式アプリで、チャットアプリ本体の操作・画面の自動操作は一切行いません。
  ・アカウント登録は不要で、データはすべて端末内にのみ保存されます。
  ・広告は Google AdMob（バナー＋リワード）。リワード広告は着せ替えテーマ／
    チャットアイコンの解放で任意に視聴します。
  ・買い切り課金は2種類: remove_ads（広告非表示）、backup_unlock（バックアップ機能）。
  ```
- **年齢制限**: コンテンツに応じて（暴力等なし → 4+ 相当。IARC は不要、Apple 独自質問に
  「なし」で回答）
- 「**手動でリリース**」推奨（審査通過後に自分のタイミングで公開）

## 8. TestFlight（任意・推奨）

審査前に内部テスターへ配布して実機確認できる。ビルドアップロード後、
TestFlight タブ → 内部テスターグループに追加 → 各自の TestFlight アプリで取得。
