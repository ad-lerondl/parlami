// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Parlami';

  @override
  String get navLearn => '学ぶ';

  @override
  String get navTrain => '練習';

  @override
  String get navEvaluate => 'テスト';

  @override
  String get navResults => '結果';

  @override
  String get navProfile => 'プロフィール';

  @override
  String get learnConjugation => '動詞の活用';

  @override
  String get learnConjugationDescription => '動詞の活用を練習する';

  @override
  String get learnVocabulary => '語彙';

  @override
  String get learnVocabularyDescription => 'トピックとレベル別';

  @override
  String get learnNumbersDates => '数字と日付';

  @override
  String get learnNumbersDatesDescription => '数字と日付を書く';

  @override
  String get learnGrammar => '文法';

  @override
  String get learnGrammarDescription => 'コースノート';

  @override
  String get learnSpelling => 'スペル';

  @override
  String get learnSpellingDescription => '近日公開';

  @override
  String get trainOralExpression => 'EO - 口頭表現';

  @override
  String get trainOralExpressionDescription => '声に出して答える';

  @override
  String get trainOralComprehension => 'CO - 聴解力';

  @override
  String get trainOralComprehensionDescription => 'ラジオ局を聴く';

  @override
  String get trainWrittenComprehension => 'CE - 読解力';

  @override
  String get trainWrittenComprehensionDescription => 'イタリアのニュースを読む';

  @override
  String get trainWrittenExpression => 'EE - 文章表現';

  @override
  String get trainWrittenExpressionDescription => '文章を翻訳する';

  @override
  String get evaluateTitle => 'テスト - 現実の状況';

  @override
  String get evaluateIntro => '同時に複数のスキルを組み合わせて、現実の状況をシミュレートします。';

  @override
  String get evaluateProgression =>
      '学習は基礎を築きます。練習は特定のスキルを対象とします。テストは全体的な習熟度を測定します。';

  @override
  String get scenarioDailyConversation => '日常会話';

  @override
  String get scenarioArticleSummary => '記事の要約';

  @override
  String get scenarioMatchDebrief => '試合の振り返り';

  @override
  String get scenarioQuickDiscussion => 'クイックディスカッション';

  @override
  String get scenarioDailyConversationDetails => '聞き、理解し、自然に答えます。';

  @override
  String get scenarioArticleSummaryDetails => 'テキストを読み、明確で構造化された要約を作成します。';

  @override
  String get scenarioMatchDebriefDetails => '語彙と文化的背景を使って試合について話します。';

  @override
  String get scenarioQuickDiscussionDetails => '時間制限のあるダイナミックなやり取りで素早く反応します。';

  @override
  String get resultsComingSoon => 'パフォーマンスチャート（近日公開）';

  @override
  String get grammarTitle => '文法';

  @override
  String get grammarComingSoon =>
      '文法ノート - 近日公開。\n\nページまたはMarkdownとしてこのモジュールにメモを追加します。';

  @override
  String get spellingTitle => 'スペル';

  @override
  String get spellingComingSoon => 'スペルモジュール - 近日公開。';

  @override
  String get ceTitle => 'CE - 読解力';

  @override
  String get ceIntro => 'イタリア語の記事を読んで読解力を向上させます';

  @override
  String get ceAdviceTitle => 'アドバイス';

  @override
  String get ceAdvice => '短い記事から始めます。まずは全体的な意味をつかみ、次に詳細を読みます。';

  @override
  String get ceOpenSource => 'ソースサイトを開く';

  @override
  String get eeTitle => 'EE - 文章表現';

  @override
  String get eePrompt => '次の文をイタリア語に翻訳してください';

  @override
  String get eeTranslationLabel => 'あなたのイタリア語の翻訳';

  @override
  String get eeTranslationHint => 'ここに翻訳を書いてください...';

  @override
  String get eeCheck => 'チェック';

  @override
  String get eeCorrection => '訂正';

  @override
  String get eeYourAnswer => 'あなたの答え';

  @override
  String get coTitle => 'CO - 聴解力';

  @override
  String get coIntro => 'イタリアのラジオ局を聴いて聴解力を向上させます';

  @override
  String get coLive => 'ライブ:';

  @override
  String coStopped(Object station) {
    return '$station 停止';
  }

  @override
  String coConnecting(Object station) {
    return '$station に接続中...';
  }

  @override
  String get coPlay => '再生';

  @override
  String get coStop => '停止';

  @override
  String get eoTitle => 'EO - 口頭表現';

  @override
  String get eoChooseLevel => 'レベルを選択';

  @override
  String eoLevel(String level) {
    return 'レベル $level';
  }

  @override
  String get eoNoQuestion => '利用可能な質問はありません';

  @override
  String get eoQuestion => '質問';

  @override
  String get eoHint => 'ヒント';

  @override
  String get eoClickHint => 'クリックしてヒントを表示';

  @override
  String get eoAnswerHint => '答えの手がかり';

  @override
  String get eoClickAnswerHint => 'クリックして答えの手がかりを表示';

  @override
  String get eoTimer => 'タイマー';

  @override
  String get eoTotal => '合計';

  @override
  String get eoSpeech => 'スピーチ';

  @override
  String get eoHesitation => 'ためらい';

  @override
  String get eoStart => '開始';

  @override
  String get eoStop => '停止';

  @override
  String get eoReset => 'リセット';

  @override
  String get eoModeFree => 'フリーモード';

  @override
  String get eoModeFreeDescription => '助けなしで、いつでも進めることができます。';

  @override
  String get eoModeEasy => '簡単';

  @override
  String get eoModeEasyDescription => '答えて、自己評価し、手がかりを見ます。';

  @override
  String get eoModeHard => '難しい';

  @override
  String get eoModeHardDescription => 'タイマー、ためらいの追跡、自己評価。';

  @override
  String eoLevelChip(Object level) {
    return 'レベル $level';
  }

  @override
  String get eoSelfEvaluation => '自己評価';

  @override
  String get eoExcellent => '素晴らしい';

  @override
  String get eoGood => '良い';

  @override
  String get eoAverage => '普通';

  @override
  String get eoDifficult => '難しい';

  @override
  String get eoNextQuestion => '次の質問';

  @override
  String get numDateTitle => '数字と日付';

  @override
  String get numDateNumbersTab => '数字';

  @override
  String get numDateDatesTab => '日付';

  @override
  String get numDateTimeTab => '時間';

  @override
  String get numDatePreviewNumberTitle => 'プレビュー番号を選択';

  @override
  String get numDatePreviewNumberSubtitle => 'この値は素早い変換にのみ使用されます。';

  @override
  String get numDatePreviewNumberLabel => 'プレビュー番号';

  @override
  String get numDatePositiveInteger => '開始するには正の整数を入力してください。';

  @override
  String get numDateTraining => '練習';

  @override
  String get numDateTrainingNumberSubtitle => 'イタリア語の単語で書く練習をするために別の数字を選択します。';

  @override
  String get numDateTrainingNumberLabel => '練習番号';

  @override
  String get numDateAnswerInWords => '言葉でのあなたの答え';

  @override
  String get numDateCheck => 'チェック';

  @override
  String get numDateClear => 'クリア';

  @override
  String get numDatePreviewDateTitle => 'プレビュー日付を選択';

  @override
  String get numDatePreviewDateSubtitle => 'この日付は簡単な参考としてのみ使用されます。';

  @override
  String get numDateToday => '今日';

  @override
  String get numDateTrainingDateSubtitle => 'イタリア語の単語で書く練習をするために別の日付を選択します。';

  @override
  String numDateExpectedDay(String day) {
    return '予定日: $day';
  }

  @override
  String get numDatePreviewTimeTitle => 'プレビュー時間を選択';

  @override
  String get numDatePreviewTimeSubtitle => 'この時間は簡単な確認としてのみ使用されます。';

  @override
  String get numDateTrainingTimeSubtitle => '特に15分単位で、練習する別の時間を選択します。';

  @override
  String get numDateDefinedTime => '指定された時間:';

  @override
  String get answerCorrect => '正解です。';

  @override
  String get answerIncorrect => '不正解です。';

  @override
  String answerYourAnswer(String answer) {
    return 'あなたの答え: $answer';
  }

  @override
  String answerExpected(String answer) {
    return '正解: $answer';
  }

  @override
  String get conjugationTitle => '動詞の活用';

  @override
  String get conjugationRegular => '規則動詞';

  @override
  String get conjugationSemiRegular => '半規則動詞';

  @override
  String get conjugationIrregular => '不規則動詞';

  @override
  String get conjugationClearFilters => 'すべてのフィルターをクリア';

  @override
  String get conjugationChooseVerb => '動詞を選択';

  @override
  String get conjugationRandomVerb => 'ランダムな動詞';

  @override
  String get conjugationHideBaseVerb => '基本動詞を隠す';

  @override
  String get conjugationChooseMood => '法を選択';

  @override
  String get conjugationChooseTense => '時制を選択';

  @override
  String conjugationVerb(String verb) {
    return '動詞: $verb';
  }

  @override
  String conjugationTranslation(String translation) {
    return '翻訳: $translation';
  }

  @override
  String conjugationMood(String mood) {
    return '法: $mood';
  }

  @override
  String conjugationTense(String tense) {
    return '時制: $tense';
  }

  @override
  String conjugationLoadingError(String error) {
    return '読み込みエラー: $error';
  }

  @override
  String get profileLanguage => 'インターフェース言語';

  @override
  String get profileUserName => 'ユーザー名';

  @override
  String get profileAbout => 'アプリについて';

  @override
  String get profileAboutDescription => 'Parlamiはイタリア語の学習をサポートします。';

  @override
  String get profileTheme => 'テーマ';

  @override
  String get profileThemeDescription => 'ライトモードとダークモードを切り替える';

  @override
  String get themeSystem => 'システムテーマ';

  @override
  String get themeLight => 'ライトテーマ';

  @override
  String get themeDark => 'ダークテーマ';

  @override
  String get vocabTitle => '語彙';

  @override
  String get vocabReview => '復習';

  @override
  String get vocabCatalog => 'カタログ';

  @override
  String get vocabAdd => '追加';

  @override
  String get vocabImport => '単語をインポート';

  @override
  String get vocabExport => '単語をエクスポート';

  @override
  String get vocabResetCatalog => '元のカタログをリセット';

  @override
  String get vocabSelect => '選択';

  @override
  String get vocabSave => '単語を保存';

  @override
  String get vocabChooseCategories => '単語のカテゴリを選択';

  @override
  String get vocabPasteJson => 'JSONリストを貼り付けてください。許可される形式:';

  @override
  String get vocabCancel => 'キャンセル';

  @override
  String vocabImportError(String error) {
    return 'インポートに失敗しました: $error';
  }

  @override
  String get vocabResetQuestion => '元の単語をリセットしますか？';

  @override
  String get vocabResetDescription =>
      'これによりインポートされた単語がリセットされ、元のカタログが再適用されます。ユーザーが追加した単語は保持されます。';

  @override
  String get vocabDeleteQuestion => 'この単語を削除しますか？';

  @override
  String vocabDeleteDescription(String word) {
    return 'カタログから \"$word\" を削除しますか？';
  }

  @override
  String get vocabDelete => '削除';

  @override
  String get vocabNoCategory => 'カテゴリが選択されていません';

  @override
  String get vocabLoading => '語彙を読み込み中...';

  @override
  String get vocabFields => '語彙フィールド';

  @override
  String get vocabNoMatch => '現在のフィルターに一致する単語はありません。';

  @override
  String get vocabNoTrainingMatch => '練習フィルターに一致する単語はありません。';

  @override
  String get vocabTrainingWord => '練習用の単語';

  @override
  String vocabScore(String score) {
    return 'スコア $score%';
  }

  @override
  String vocabBaseLanguage(String language) {
    return 'ベース言語: $language';
  }

  @override
  String get vocabHiddenAnswer => '答えは隠されています。';

  @override
  String get vocabKnown => '知っている';

  @override
  String get vocabUnknown => '知らない';

  @override
  String get vocabNextWord => '次の単語';

  @override
  String vocabCategories(String categories) {
    return 'カテゴリ: $categories';
  }

  @override
  String get vocabPreparing => '練習用の単語を準備中...';

  @override
  String get vocabPriority => 'まだ習得していない単語を優先する';

  @override
  String get vocabPriorityDescription => 'ランダムにシャッフルするには無効にします。';

  @override
  String vocabSelectedCount(String count) {
    return '選択された単語: $count';
  }

  @override
  String get vocabClearAll => 'すべてクリア';

  @override
  String get vocabConfirm => '確認';

  @override
  String get conjugationCheck => 'チェック';

  @override
  String get conjugationNextVerb => '次の動詞';

  @override
  String get eeNextSentence => '次の文';

  @override
  String get eeNoSentence => '利用可能な文はありません';

  @override
  String ceLevel(String level) {
    return 'レベル: $level';
  }

  @override
  String get sampleItems => 'サンプルアイテム';

  @override
  String get sampleItemDetails => 'アイテムの詳細';

  @override
  String get sampleMoreInformation => '詳細はこちら';

  @override
  String sampleItem(String id) {
    return 'サンプルアイテム $id';
  }

  @override
  String get evaluateScenarioOral => 'CO + EO';

  @override
  String get evaluateScenarioWritten => 'CE + EE';

  @override
  String get evaluateScenarioCulture => 'EO + 文化';

  @override
  String get evaluateScenarioSpeed => 'CO + EO + 速度';

  @override
  String get conjugationAnswerLabel => 'あなたの答え';

  @override
  String get vocabWords => '単語';

  @override
  String get vocabAverageMastery => '平均習熟度';

  @override
  String get vocabMode => 'モード';

  @override
  String get vocabMastery => '習熟度';

  @override
  String get vocabRandom => 'ランダム';

  @override
  String get vocabSearchWord => '単語を検索';

  @override
  String get vocabBaseLanguageDisplay => 'ベース言語を表示';

  @override
  String get vocabDifficulty => '難易度';

  @override
  String get vocabPartOfSpeech => '品詞';

  @override
  String get vocabChooseFilterCategories => 'フィルターカテゴリを選択';

  @override
  String get vocabSearchTrainingWord => '単語を検索';

  @override
  String get vocabTrainingBaseLanguage => '練習用ベース言語';

  @override
  String get vocabFilters => 'フィルター';

  @override
  String get vocabChooseTrainingCategories => '練習カテゴリを選択';

  @override
  String get vocabItalianWord => 'イタリア語の単語';

  @override
  String get vocabFrenchTranslation => '翻訳（ベース言語）';

  @override
  String get vocabOptionalArticle => '任意の冠詞 (il, la, l\', など)';

  @override
  String get vocabCategoriesTitle => 'カテゴリ';

  @override
  String get vocabSearchCategory => 'カテゴリを検索';

  @override
  String vocabAddCategory(String category) {
    return '\"$category\" を追加';
  }

  @override
  String get vocabDeleteFromCatalog => 'カタログから削除';

  @override
  String get vocabHideAnswer => '答えを隠す';

  @override
  String get vocabShowAnswer => '答えを表示';

  @override
  String get vocabStatusSaved => '単語が保存され、フィルターで利用可能になりました。';

  @override
  String vocabStatusImport(String count) {
    return 'インポート完了: $count 個の単語が追加されました。';
  }

  @override
  String vocabStatusExport(String location) {
    return 'エクスポート完了: $location';
  }

  @override
  String get vocabStatusNoExport => 'エクスポートするユーザー単語はありません。';

  @override
  String get vocabStatusReset => '元のカタログがリセットされました。';

  @override
  String get vocabStatusDeleted => '単語がカタログから削除されました。';

  @override
  String get vocabStatusKnown => '記憶しました。';

  @override
  String get vocabStatusReview => 'すぐに復習してください。';

  @override
  String get vocabItalian => 'イタリア語';

  @override
  String get vocabFrench => 'フランス語';

  @override
  String get vocabSourceOriginal => 'オリジナル';

  @override
  String get vocabSourceUser => 'ユーザー';

  @override
  String get vocabNoun => '名詞';

  @override
  String get vocabVerb => '動詞';

  @override
  String get vocabAdjective => '形容詞';

  @override
  String get vocabAdverb => '副詞';

  @override
  String get vocabPronoun => '代名詞';

  @override
  String get vocabDeterminer => '限定詞';

  @override
  String get vocabPreposition => '前置詞';

  @override
  String get vocabConjunction => '接続詞';

  @override
  String get vocabInterjection => '感嘆詞';

  @override
  String get vocabExpression => '表現';

  @override
  String get vocabOther => 'その他';

  @override
  String get profileDonate => '寄付する';

  @override
  String get profileDonateDescription => 'ご支援ありがとうございます';

  @override
  String get profilePrivacy => 'プライバシーポリシー';

  @override
  String get profilePrivacyDescription => 'プライバシーポリシーを開く';

  @override
  String get unavailable => 'この機能はまだ利用できません。';
}
