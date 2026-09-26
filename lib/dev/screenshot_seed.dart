import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../core/providers/app_providers.dart';
import '../features/import/parsing/line_txt_parser.dart';

/// Set with `--dart-define=SCREENSHOT=true` when capturing App Store and Play
/// Store shots. It also hides the ad banner (see `banner_ad_widget.dart`).
const bool kScreenshotMode = bool.fromEnvironment('SCREENSHOT');

/// Fills an empty install with realistic chats so the store screenshots show
/// the app doing its job, rather than the one-chat, mostly-blank list the
/// previous set was shot from.
///
/// Everything below is unreachable in a normal build — [kScreenshotMode] is a
/// compile-time constant, so the sample text is tree-shaken out and never
/// ships to users.
Future<void> seedScreenshotSamplesIfNeeded(ProviderContainer container) async {
  if (!kScreenshotMode) return;

  final chats = await container.read(chatRepositoryProvider).watchAllChats().first;
  final existingTitles = chats.map((chat) => chat.title).toSet();

  final dir = await getApplicationDocumentsDirectory();
  final parser = LineTxtParser();
  final importRepository = container.read(importRepositoryProvider);

  for (final sample in _samples) {
    final result = parser.parse(sample.content);
    // Skipping by title keeps this safe to re-run: adding a sample later tops
    // the simulator up instead of duplicating the chats already in it, and
    // nothing has to be wiped to pick the new one up.
    if (existingTitles.contains(result.chatTitle)) continue;

    final file = File('${dir.path}/screenshot_${sample.fileName}');
    await file.writeAsString(sample.content);
    await importRepository.importParsedChat(
      result: result,
      sourceFileName: sample.fileName,
      rawTxtPath: file.path,
    );
  }
}

class _Sample {
  const _Sample(this.fileName, this.content);

  final String fileName;
  final String content;
}

const _samples = <_Sample>[
  _Sample('tennis_circle.txt', _tennisCircle),
  _Sample('family.txt', _family),
  _Sample('sato.txt', _sato),
  _Sample('minami.txt', _minami),
  _Sample('hanako.txt', _hanako),
  _Sample('yuka.txt', _yuka),
  _Sample('kenta.txt', _kenta),
  _Sample('mama.txt', _mama),
  _Sample('work.txt', _work),
];

const _tennisCircle = '''
[LINE] テニスサークルとのトーク履歴
保存日時：2026/09/14 20:30

2026/07/05(日)
09:12\t小林\tおはようございます!今日のコート、9番に変更になりました
09:15\t渡辺\t了解です。少し遅れます
09:20\t小林\t大丈夫ですよ、ゆっくりどうぞ
09:41\t高橋\tラケット持ってきました。誰か貸してほしい人いますか
09:45\t渡辺\t助かります!忘れてきました
10:02\t小林\t今日は8人集まりそうですね
10:05\t高橋\tいい感じ。ダブルス2面回せますね

2026/07/26(日)
18:30\t小林\t来月の合宿、人数確定したいので今週中に返事ください
18:33\t高橋\t参加します
18:40\t渡辺\t行きます!宿ってどこですか
18:44\t小林\t山中湖のいつものところです
18:45\t渡辺\t懐かしい、去年も楽しかったですね
19:02\t中村\t参加で!車出せます
19:03\t小林\t助かります、ありがとうございます

2026/08/16(土)
07:50\t小林\t合宿1日目、現地に着きました。天気最高です
07:55\t高橋\tいいなあ、午後から合流します
12:10\t渡辺\tお昼のカレーが想像の3倍おいしい
12:15\t中村\tおかわりしました
20:30\t小林\t今日の集合写真あげておきます
20:35\t高橋\tみんないい顔してる

2026/09/13(日)
19:10\t小林\t今シーズンお疲れさまでした!来月から冬のコートに移ります
19:15\t渡辺\tありがとうございました
19:22\t高橋\t来シーズンもよろしくお願いします
19:40\t中村\t打ち上げやりましょう
''';

const _family = '''
[LINE] 家族グループとのトーク履歴
保存日時：2026/09/20 21:15

2026/06/14(日)
08:10\tお母さん\t今日は何時に帰る?
08:22\t自分\t19時くらいになりそう
08:23\tお母さん\tわかった、ごはん用意しておくね
08:25\t自分\tありがとう、助かる
12:40\tお父さん\t駅前の道路工事、来週から始まるらしいぞ
12:48\tお母さん\t買い物どうしよう
12:55\t自分\t車出すよ、土曜なら空いてる

2026/07/19(日)
10:05\tお母さん\tおばあちゃんの誕生日、来月だけどどうする?
10:12\t自分\tみんなで集まれたらいいね
10:15\tお父さん\t店は予約しておく
10:30\tお母さん\tケーキは私が焼くよ
10:33\t自分\t楽しみにしてる

2026/08/23(土)
17:02\tお母さん\tおばあちゃん、すごく喜んでた
17:10\t自分\t写真いっぱい撮ったから後で送るね
17:15\tお父さん\t良い一日だった
17:40\tお母さん\tまたみんなで集まろうね

2026/09/20(日)
09:30\tお母さん\t台風、そっちは大丈夫?
09:35\t自分\tこっちは風が強いくらい。平気だよ
09:37\tお母さん\t無理しないでね
09:40\tお父さん\t停電に備えて充電しておけよ
09:42\t自分\tありがとう、気をつける
''';

const _sato = '''
[LINE] 佐藤健とのトーク履歴
保存日時：2026/09/18 23:40

2026/07/01(水)
21:10\t佐藤健\t今度の飲み会っていつだっけ?
21:12\t自分\t来週の金曜、19時からだよ
21:13\t佐藤健\tありがとう、カレンダーに入れとく
21:20\t佐藤健\t場所は前と同じところ?
21:22\t自分\t今回は駅の反対側の店。地図送るね
21:25\t佐藤健\t助かる

2026/07/10(金)
23:05\t佐藤健\t今日は楽しかった!
23:08\t自分\tこちらこそ。久しぶりに話せてよかった
23:10\t佐藤健\tまたやろう
23:12\t自分\t next は秋くらいかな
23:15\t佐藤健\tいいね、涼しくなったら

2026/08/28(木)
12:30\t佐藤健\t例の資料、目を通してもらえた?
12:45\t自分\t読んだよ。3ページ目のグラフだけ気になった
12:50\t佐藤健\tどのあたり?
12:55\t自分\t軸のラベルが去年のままになってる
13:02\t佐藤健\tほんとだ、助かった。直しておく
13:05\t自分\tそれ以外はすごく分かりやすかった

2026/09/18(金)
20:15\t佐藤健\t異動の件、決まったよ
20:18\t自分\tおめでとう!どこに?
20:20\t佐藤健\t大阪。来月から
20:25\t自分\t寂しくなるな。送別会やろう
20:28\t佐藤健\tぜひ。落ち着いたら連絡する
''';

const _minami = '''
[LINE] みなみとのトーク履歴
保存日時：2026/09/22 22:05

2026/06/20(土)
11:20\tみなみ\t来週の水族館、何時集合にする?
11:25\t自分\t10時に駅でどう?
11:26\tみなみ\tいいね!お弁当作っていこうか
11:30\t自分\t本当に?うれしい
11:32\tみなみ\t楽しみにしてて
11:45\t自分\t前から行きたかったところだから、すごく楽しみ

2026/06/27(土)
19:40\tみなみ\t today は楽しかったね
19:42\t自分\tクラゲの水槽、ずっと見ていられた
19:45\tみなみ\t写真あとで送るね
19:50\t自分\tありがとう。お弁当もおいしかった
19:52\tみなみ\tまた作るよ

2026/08/08(土)
21:10\tみなみ\t花火、見えた?
21:12\t自分\tばっちり。ここからよく見える
21:15\tみなみ\t来年は一緒に行きたいな
21:18\t自分\tそうしよう。約束

2026/09/22(火)
22:00\tみなみ\t3年目、おめでとう
22:02\t自分\tこちらこそありがとう
22:05\tみなみ\tこれからもよろしくね
22:07\t自分\tずっと大事にするよ
''';

const _hanako = '''
[LINE] 山田花子とのトーク履歴
保存日時：2026/09/25 08:50

2026/07/12(日)
09:12\t山田花子\tおはよう!今日晴れてよかったね
09:15\t自分\tほんとだ、洗濯物がよく乾きそう
09:20\t山田花子\t午後からカフェ行かない?
09:22\t自分\t行く!14時くらいでどう
09:24\t山田花子\tオッケー、いつものところで
15:40\t山田花子\t新しいケーキおいしかった
15:45\t自分\tまた来よう

2026/08/02(土)
20:10\t山田花子\t旅行の候補、3つに絞ったよ
20:12\t自分\tどこどこ
20:15\t山田花子\t金沢、松本、尾道
20:20\t自分\t全部いいな。迷う
20:25\t山田花子\t写真送るね
20:40\t自分\t尾道の坂道、すごくきれい
20:42\t山田花子\tじゃあ尾道にしよう

2026/09/06(日)
18:30\t山田花子\t宿予約できた!海が見える部屋だって
18:33\t自分\tやった、ありがとう
18:35\t山田花子\t11月が待ち遠しい

2026/09/25(木)
08:40\t山田花子\tおはよう。今日から寒くなるみたいだよ
08:45\t自分\t上着出しておこう
08:48\t山田花子\t風邪ひかないようにね
08:50\t自分\tありがとう、そっちもね
''';

const _yuka = '''
[LINE] 田中優香とのトーク履歴
保存日時：2026/09/19 21:00

2026/07/08(水)
12:30\t田中優香\tランチ、新しくできたお店行ってみない?
12:35\t自分\t行きたい!明日はどう
12:36\t田中優香\t大丈夫!12時に下で待ち合わせしよう
12:40\t自分\t了解

2026/08/15(土)
16:20\t田中優香\t夏休みどこか行った?
16:25\t自分\t実家に帰ってた。そっちは
16:30\t田中優香\t沖縄!海がきれいすぎた
16:35\t自分\tいいなあ、写真見たい
16:40\t田中優香\t送るね

2026/09/19(金)
20:50\t田中優香\t来週の勉強会、資料持っていくね
20:55\t自分\t助かる、ありがとう
''';

const _kenta = '''
[LINE] 鈴木健太とのトーク履歴
保存日時：2026/09/11 19:30

2026/06/22(日)
14:10\t鈴木健太\t引っ越し手伝ってくれてありがとう
14:15\t自分\tいえいえ、無事終わってよかった
14:20\t鈴木健太\t落ち着いたら家に遊びに来てよ
14:22\t自分\tぜひ行きたい

2026/08/09(日)
11:05\t鈴木健太\t新居のリビング、やっと片付いた
11:10\t自分\t早いね
11:15\t鈴木健太\tソファ買ったら一気にそれっぽくなった
11:20\t自分\t写真ちょうだい

2026/09/11(金)
19:00\t鈴木健太\t来月の連休、空いてる?
19:05\t自分\t空いてるよ
19:10\t鈴木健太\tキャンプ行こう
''';

const _mama = '''
[LINE] ママ友グループとのトーク履歴
保存日時：2026/09/17 12:00

2026/07/03(金)
08:05\t佐々木\tおはようございます。今日の遠足、集合は8時半で合ってますか
08:10\t井上\tはい、正門前です
08:15\t佐々木\tありがとうございます
08:30\t中川\t間に合いました!

2026/08/21(金)
19:20\t井上\t夏祭りの写真、共有しますね
19:25\t中川\tありがとうございます、どれもかわいい
19:30\t佐々木\t来年も楽しみです

2026/09/17(木)
11:40\t井上\t運動会のお弁当、何持っていきますか
11:45\t中川\t唐揚げは確定です
11:50\t佐々木\tうちはおにぎり作ります
''';

const _work = '''
[LINE] 開発チームとのトーク履歴
保存日時：2026/09/24 18:00

2026/07/15(火)
09:30\t部長\tおはようございます。今日の定例は15時からです
09:35\t自分\t承知しました
09:40\t吉田\t資料を共有フォルダに置きました
09:45\t自分\t確認します

2026/08/27(木)
13:10\t吉田\tリリース、無事完了しました
13:15\t自分\tお疲れさまでした
13:20\t部長\tありがとう、助かりました

2026/09/24(木)
17:30\t部長\t来期の体制について、明日少し話しましょう
17:35\t自分\t了解しました
17:40\t吉田\t私も同席します
''';
