# iOS Share Extension — Xcode側の配線手順

このフォルダの `Info.plist` / `ShareViewController.swift` / `ShareExtension.entitlements` /
`Base.lproj/MainInterface.storyboard` はスキャフォールド（ソースコード）のみです。
`project.pbxproj` への新規ターゲット追加はXcodeのGUIでしか安全に行えないため、
Mac + Xcodeがある環境で以下の手順を実施してください（このリポジトリはWindows上で
作業しているため、ここまでしか用意できません）。

## 手順

1. `ios/Runner.xcworkspace` をXcodeで開く。
2. `flutter config --enable-swift-package-manager` を実行（`receive_sharing_intent` は
   SPM配布のみ、CocoaPods podspecなし）。
3. File → New → Target → **Share Extension** を選択し、名前を `ShareExtension` にする
   （Bundle Identifierは自動生成される `com.yousaku.line_talk_saver.ShareExtension` のままでOK）。
   Deployment TargetはRunnerと同じ値にする。
4. Xcodeが自動生成した `ShareExtension/` 配下のファイル（Info.plist, ShareViewController.swift,
   entitlements, storyboard）を、このフォルダにある同名ファイルの内容で置き換える。
5. `ShareExtension` ターゲット → Signing & Capabilities → **+ Capability** →
   **App Groups** を追加し、`group.com.yousaku.line_talk_saver` を追加。
   `Runner` ターゲットにも同様に **App Groups** を追加し、同じグループIDを追加
   （`Runner.entitlements` は既にこのグループIDで用意済み）。
6. `Runner` と `ShareExtension` 両方のターゲットの Build Settings に、
   User-Defined設定として `CUSTOM_GROUP_ID = group.com.yousaku.line_talk_saver` を追加。
7. `ShareExtension` ターゲット → General → Frameworks and Libraries → **+** →
   `receive_sharing_intent` Swiftパッケージの `receive-sharing-intent` ライブラリを追加。
8. `Runner` ターゲット → Build Phases → **Embed Foundation Extensions** を
   **Thin Binary** より上に移動する（`no such module 'receive_sharing_intent'` エラー対策）。
9. 実機ビルドし、LINEの「トークをテキストで送信」の共有シートに
   「LINEトーク保存」が表示されること、取り込みが正しく行われることを確認する
   （Share Extensionはシミュレータでは十分に検証できないため実機必須）。

## 対応済みのDart側

`lib/features/import/share_intake/share_intent_listener.dart` はAndroid/iOS共通の
`receive_sharing_intent` APIのみを使っており、iOS側の追加実装は不要。上記のネイティブ
配線が完了すれば、Android同様に自動で `/import` 画面に遷移する。

## App Group ID

`group.com.yousaku.line_talk_saver` を仮に設定しています。Apple Developer Programの
実アカウントでの登録時に、必要であれば実際のTeam IDに合わせて変更してください
（`Runner.entitlements` / `ShareExtension.entitlements` / 両ターゲットの
`CUSTOM_GROUP_ID` の3箇所を揃える）。
