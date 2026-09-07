// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Parlami';

  @override
  String get navLearn => 'تعلّم';

  @override
  String get navTrain => 'تدرّب';

  @override
  String get navEvaluate => 'اختبر نفسك';

  @override
  String get navResults => 'النتائج';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get learnConjugation => 'تصريف الأفعال';

  @override
  String get learnConjugationDescription => 'تدرّب على تصريف الأفعال';

  @override
  String get learnVocabulary => 'المفردات';

  @override
  String get learnVocabularyDescription => 'حسب الموضوع والمستوى';

  @override
  String get learnNumbersDates => 'الأرقام والتواريخ';

  @override
  String get learnNumbersDatesDescription => 'كتابة الأرقام والتواريخ';

  @override
  String get learnGrammar => 'القواعد';

  @override
  String get learnGrammarDescription => 'ملاحظات الدورة';

  @override
  String get learnSpelling => 'التهجئة';

  @override
  String get learnSpellingDescription => 'قريباً';

  @override
  String get trainOralExpression => 'EO - التعبير الشفهي';

  @override
  String get trainOralExpressionDescription => 'أجب بصوت عالٍ';

  @override
  String get trainOralComprehension => 'CO - الفهم الشفوي';

  @override
  String get trainOralComprehensionDescription => 'استمع إلى محطات الراديو';

  @override
  String get trainWrittenComprehension => 'CE - الفهم الكتابي';

  @override
  String get trainWrittenComprehensionDescription => 'اقرأ الأخبار الإيطالية';

  @override
  String get trainWrittenExpression => 'EE - التعبير الكتابي';

  @override
  String get trainWrittenExpressionDescription => 'ترجمة الجمل';

  @override
  String get evaluateTitle => 'اختبر نفسك - مواقف واقعية';

  @override
  String get evaluateIntro =>
      'اجمع بين مهارات متعددة لمحاكاة مواقف الحياة الواقعية.';

  @override
  String get evaluateProgression =>
      'التعلم يبني الأسس. التدريب يركز على مهارات محددة. الاختبار يقيس مدى إتقانك العام.';

  @override
  String get scenarioDailyConversation => 'محادثة يومية';

  @override
  String get scenarioArticleSummary => 'ملخص مقال';

  @override
  String get scenarioMatchDebrief => 'تحليل مباراة';

  @override
  String get scenarioQuickDiscussion => 'نقاش سريع';

  @override
  String get scenarioDailyConversationDetails =>
      'استمع، افهم، ثم أجب بشكل طبيعي.';

  @override
  String get scenarioArticleSummaryDetails =>
      'اقرأ نصاً، ثم قدم ملخصاً واضحاً ومنظماً.';

  @override
  String get scenarioMatchDebriefDetails =>
      'تحدث عن مباراة باستخدام المفردات والمراجع الثقافية.';

  @override
  String get scenarioQuickDiscussionDetails =>
      'تفاعل بسرعة في حوار ديناميكي بوقت محدد.';

  @override
  String get resultsComingSoon => 'مخططات الأداء قريباً';

  @override
  String get grammarTitle => 'القواعد';

  @override
  String get grammarComingSoon =>
      'ملاحظات القواعد - المحتوى قريباً.\n\nأضف ملاحظات كصفحات أو Markdown.';

  @override
  String get spellingTitle => 'التهجئة';

  @override
  String get spellingComingSoon => 'وحدة التهجئة - قريباً.';

  @override
  String get ceTitle => 'CE - الفهم الكتابي';

  @override
  String get ceIntro => 'اقرأ مقالات إيطالية لتحسين فهمك الكتابي';

  @override
  String get ceAdviceTitle => 'نصيحة';

  @override
  String get ceAdvice =>
      'ابدأ بالمقالات القصيرة. اقرأ أولاً للفهم العام، ثم أعد القراءة للتفاصيل.';

  @override
  String get ceOpenSource => 'افتح موقع المصدر';

  @override
  String get eeTitle => 'EE - التعبير الكتابي';

  @override
  String get eePrompt => 'ترجم الجملة التالية إلى الإيطالية';

  @override
  String get eeTranslationLabel => 'ترجمتك إلى الإيطالية';

  @override
  String get eeTranslationHint => 'اكتب ترجمتك هنا...';

  @override
  String get eeCheck => 'تحقق';

  @override
  String get eeCorrection => 'التصحيح';

  @override
  String get eeYourAnswer => 'إجابتك';

  @override
  String get coTitle => 'CO - الفهم الشفوي';

  @override
  String get coIntro => 'استمع إلى محطات الراديو الإيطالية لتحسين فهمك الشفهي';

  @override
  String get coLive => 'مباشر:';

  @override
  String coStopped(Object station) {
    return 'تم إيقاف $station';
  }

  @override
  String coConnecting(Object station) {
    return 'جارٍ الاتصال بـ $station...';
  }

  @override
  String get coPlay => 'تشغيل';

  @override
  String get coStop => 'إيقاف';

  @override
  String get eoTitle => 'EO - التعبير الشفهي';

  @override
  String get eoChooseLevel => 'اختر المستوى';

  @override
  String eoLevel(String level) {
    return 'المستوى $level';
  }

  @override
  String get eoNoQuestion => 'لا توجد أسئلة متاحة';

  @override
  String get eoQuestion => 'سؤال';

  @override
  String get eoHint => 'تلميح';

  @override
  String get eoClickHint => 'انقر للحصول على تلميح';

  @override
  String get eoAnswerHint => 'دليل الإجابة';

  @override
  String get eoClickAnswerHint => 'انقر للحصول على دليل الإجابة';

  @override
  String get eoTimer => 'المؤقت';

  @override
  String get eoTotal => 'المجموع';

  @override
  String get eoSpeech => 'التحدث';

  @override
  String get eoHesitation => 'التردد';

  @override
  String get eoStart => 'ابدأ';

  @override
  String get eoStop => 'إيقاف';

  @override
  String get eoReset => 'إعادة ضبط';

  @override
  String get eoModeFree => 'الوضع الحر';

  @override
  String get eoModeFreeDescription => 'تقدم متى شئت، دون مساعدة.';

  @override
  String get eoModeEasy => 'سهل';

  @override
  String get eoModeEasyDescription => 'أجب، قيّم نفسك، وشاهد دليل الإجابة.';

  @override
  String get eoModeHard => 'صعب';

  @override
  String get eoModeHardDescription => 'المؤقت، تتبع التردد، والتقييم الذاتي.';

  @override
  String eoLevelChip(Object level) {
    return 'المستوى $level';
  }

  @override
  String get eoSelfEvaluation => 'التقييم الذاتي';

  @override
  String get eoExcellent => 'ممتاز';

  @override
  String get eoGood => 'جيد';

  @override
  String get eoAverage => 'متوسط';

  @override
  String get eoDifficult => 'صعب';

  @override
  String get eoNextQuestion => 'السؤال التالي';

  @override
  String get numDateTitle => 'الأرقام والتواريخ';

  @override
  String get numDateNumbersTab => 'الأرقام';

  @override
  String get numDateDatesTab => 'التواريخ';

  @override
  String get numDateTimeTab => 'الوقت';

  @override
  String get numDatePreviewNumberTitle => 'اختر رقماً للمعاينة';

  @override
  String get numDatePreviewNumberSubtitle =>
      'تستخدم هذه القيمة للتحويل السريع فقط.';

  @override
  String get numDatePreviewNumberLabel => 'رقم المعاينة';

  @override
  String get numDatePositiveInteger => 'أدخل عدداً صحيحاً موجباً للبدء.';

  @override
  String get numDateTraining => 'تدرّب';

  @override
  String get numDateTrainingNumberSubtitle =>
      'اختر رقماً آخر للتدرب على كتابته بالكلمات الإيطالية.';

  @override
  String get numDateTrainingNumberLabel => 'رقم التدريب';

  @override
  String get numDateAnswerInWords => 'إجابتك بالكلمات';

  @override
  String get numDateCheck => 'تحقق';

  @override
  String get numDateClear => 'مسح';

  @override
  String get numDatePreviewDateTitle => 'اختر تاريخاً للمعاينة';

  @override
  String get numDatePreviewDateSubtitle => 'يستخدم هذا التاريخ كمرجع سريع فقط.';

  @override
  String get numDateToday => 'اليوم';

  @override
  String get numDateTrainingDateSubtitle =>
      'اختر تاريخاً آخر للتدرب على كتابته بالكلمات الإيطالية.';

  @override
  String numDateExpectedDay(String day) {
    return 'اليوم المتوقع: $day';
  }

  @override
  String get numDatePreviewTimeTitle => 'اختر وقتاً للمعاينة';

  @override
  String get numDatePreviewTimeSubtitle =>
      'يستخدم هذا الوقت للقراءة السريعة فقط.';

  @override
  String get numDateTrainingTimeSubtitle =>
      'اختر وقتاً آخر للتدرب، خاصة أرباع الساعة.';

  @override
  String get numDateDefinedTime => 'الوقت المحدد:';

  @override
  String get answerCorrect => 'إجابة صحيحة.';

  @override
  String get answerIncorrect => 'إجابة غير صحيحة.';

  @override
  String answerYourAnswer(String answer) {
    return 'إجابتك: $answer';
  }

  @override
  String answerExpected(String answer) {
    return 'الإجابة الصحيحة: $answer';
  }

  @override
  String get conjugationTitle => 'تصريف الأفعال';

  @override
  String get conjugationRegular => 'منتظمة';

  @override
  String get conjugationSemiRegular => 'شبه منتظمة';

  @override
  String get conjugationIrregular => 'غير منتظمة';

  @override
  String get conjugationClearFilters => 'مسح جميع الفلاتر';

  @override
  String get conjugationChooseVerb => 'اختر فعلاً';

  @override
  String get conjugationRandomVerb => 'فعل عشوائي';

  @override
  String get conjugationHideBaseVerb => 'إخفاء الفعل الأساسي';

  @override
  String get conjugationChooseMood => 'اختر الصيغة';

  @override
  String get conjugationChooseTense => 'اختر الزمن';

  @override
  String conjugationVerb(String verb) {
    return 'الفعل: $verb';
  }

  @override
  String conjugationTranslation(String translation) {
    return 'الترجمة: $translation';
  }

  @override
  String conjugationMood(String mood) {
    return 'الصيغة: $mood';
  }

  @override
  String conjugationTense(String tense) {
    return 'الزمن: $tense';
  }

  @override
  String conjugationLoadingError(String error) {
    return 'خطأ في التحميل: $error';
  }

  @override
  String get profileLanguage => 'لغة الواجهة';

  @override
  String get profileUserName => 'اسم المستخدم';

  @override
  String get profileAbout => 'عن التطبيق';

  @override
  String get profileAboutDescription => 'يساعدك Parlami على تعلم الإيطالية.';

  @override
  String get profileTheme => 'المظهر';

  @override
  String get profileThemeDescription => 'التبديل بين الوضع الفاتح والداكن';

  @override
  String get themeSystem => 'مظهر النظام';

  @override
  String get themeLight => 'مظهر فاتح';

  @override
  String get themeDark => 'مظهر داكن';

  @override
  String get vocabTitle => 'المفردات';

  @override
  String get vocabReview => 'مراجعة';

  @override
  String get vocabCatalog => 'الكتالوج';

  @override
  String get vocabAdd => 'إضافة';

  @override
  String get vocabImport => 'استيراد الكلمات';

  @override
  String get vocabExport => 'تصدير كلماتي';

  @override
  String get vocabResetCatalog => 'إعادة تعيين الكتالوج الأصلي';

  @override
  String get vocabSelect => 'تحديد';

  @override
  String get vocabSave => 'حفظ الكلمة';

  @override
  String get vocabChooseCategories => 'اختر فئات الكلمة';

  @override
  String get vocabPasteJson => 'الصق قائمة JSON للكلمات. التنسيق المقبول:';

  @override
  String get vocabCancel => 'إلغاء';

  @override
  String vocabImportError(String error) {
    return 'فشل الاستيراد: $error';
  }

  @override
  String get vocabResetQuestion => 'إعادة تعيين الكلمات الأصلية؟';

  @override
  String get vocabResetDescription =>
      'سيؤدي هذا إلى إعادة تعيين الكلمات المستوردة وتطبيق الكتالوج الأصلي. يتم الاحتفاظ بكلمات المستخدم.';

  @override
  String get vocabDeleteQuestion => 'حذف هذه الكلمة؟';

  @override
  String vocabDeleteDescription(String word) {
    return 'هل تريد حذف \"$word\" من الكتالوج؟';
  }

  @override
  String get vocabDelete => 'حذف';

  @override
  String get vocabNoCategory => 'لم يتم تحديد فئة';

  @override
  String get vocabLoading => 'جارٍ تحميل المفردات...';

  @override
  String get vocabFields => 'الحقول المعجمية';

  @override
  String get vocabNoMatch => 'لا توجد كلمة تطابق الفلاتر الحالية.';

  @override
  String get vocabNoTrainingMatch => 'لا توجد كلمة تطابق فلاتر التدريب.';

  @override
  String get vocabTrainingWord => 'كلمة التدريب';

  @override
  String vocabScore(String score) {
    return 'النتيجة $score%';
  }

  @override
  String vocabBaseLanguage(String language) {
    return 'اللغة الأساسية: $language';
  }

  @override
  String get vocabHiddenAnswer => 'الإجابة مخفية.';

  @override
  String get vocabKnown => 'معروفة';

  @override
  String get vocabUnknown => 'غير معروفة';

  @override
  String get vocabNextWord => 'الكلمة التالية';

  @override
  String vocabCategories(String categories) {
    return 'الفئات: $categories';
  }

  @override
  String get vocabPreparing => 'جارٍ إعداد كلمات التدريب...';

  @override
  String get vocabPriority => 'إعطاء الأولوية للكلمات غير المتقنة';

  @override
  String get vocabPriorityDescription => 'قم بتعطيله للخلط العشوائي.';

  @override
  String vocabSelectedCount(String count) {
    return 'الكلمات المحددة: $count';
  }

  @override
  String get vocabClearAll => 'مسح الكل';

  @override
  String get vocabConfirm => 'تأكيد';

  @override
  String get conjugationCheck => 'تحقق';

  @override
  String get conjugationNextVerb => 'الفعل التالي';

  @override
  String get eeNextSentence => 'الجملة التالية';

  @override
  String get eeNoSentence => 'لا توجد جملة متاحة';

  @override
  String ceLevel(String level) {
    return 'المستوى: $level';
  }

  @override
  String get sampleItems => 'عناصر نموذجية';

  @override
  String get sampleItemDetails => 'تفاصيل العنصر';

  @override
  String get sampleMoreInformation => 'مزيد من المعلومات هنا';

  @override
  String sampleItem(String id) {
    return 'عنصر نموذجي $id';
  }

  @override
  String get evaluateScenarioOral => 'CO + EO';

  @override
  String get evaluateScenarioWritten => 'CE + EE';

  @override
  String get evaluateScenarioCulture => 'EO + ثقافة';

  @override
  String get evaluateScenarioSpeed => 'CO + EO + سرعة';

  @override
  String get conjugationAnswerLabel => 'إجابتك';

  @override
  String get vocabWords => 'الكلمات';

  @override
  String get vocabAverageMastery => 'متوسط الإتقان';

  @override
  String get vocabMode => 'الوضع';

  @override
  String get vocabMastery => 'الإتقان';

  @override
  String get vocabRandom => 'عشوائي';

  @override
  String get vocabSearchWord => 'ابحث عن كلمة';

  @override
  String get vocabBaseLanguageDisplay => 'عرض اللغة الأساسية';

  @override
  String get vocabDifficulty => 'الصعوبة';

  @override
  String get vocabPartOfSpeech => 'جزء من الكلام';

  @override
  String get vocabChooseFilterCategories => 'اختر فئات الفلتر';

  @override
  String get vocabSearchTrainingWord => 'ابحث عن كلمة';

  @override
  String get vocabTrainingBaseLanguage => 'لغة التدريب الأساسية';

  @override
  String get vocabFilters => 'الفلاتر';

  @override
  String get vocabChooseTrainingCategories => 'اختر فئات التدريب';

  @override
  String get vocabItalianWord => 'كلمة إيطالية';

  @override
  String get vocabFrenchTranslation => 'الترجمة (اللغة الأساسية)';

  @override
  String get vocabOptionalArticle => 'أداة اختيارية (il, la, l\', إلخ)';

  @override
  String get vocabCategoriesTitle => 'الفئات';

  @override
  String get vocabSearchCategory => 'ابحث عن فئة';

  @override
  String vocabAddCategory(String category) {
    return 'إضافة \"$category\"';
  }

  @override
  String get vocabDeleteFromCatalog => 'حذف من الكتالوج';

  @override
  String get vocabHideAnswer => 'إخفاء الإجابة';

  @override
  String get vocabShowAnswer => 'إظهار الإجابة';

  @override
  String get vocabStatusSaved => 'تم حفظ الكلمة وهي متاحة في الفلاتر.';

  @override
  String vocabStatusImport(String count) {
    return 'اكتمل الاستيراد: تمت إضافة $count كلمة/كلمات.';
  }

  @override
  String vocabStatusExport(String location) {
    return 'اكتمل التصدير: $location';
  }

  @override
  String get vocabStatusNoExport => 'لا توجد كلمات مستخدم للتصدير.';

  @override
  String get vocabStatusReset => 'تمت إعادة تعيين الكتالوج الأصلي.';

  @override
  String get vocabStatusDeleted => 'تمت إزالة الكلمة من الكتالوج.';

  @override
  String get vocabStatusKnown => 'تمت الملاحظة.';

  @override
  String get vocabStatusReview => 'راجعها قريباً.';

  @override
  String get vocabItalian => 'الإيطالية';

  @override
  String get vocabFrench => 'الفرنسية';

  @override
  String get vocabSourceOriginal => 'أصلي';

  @override
  String get vocabSourceUser => 'مستخدم';

  @override
  String get vocabNoun => 'اسم';

  @override
  String get vocabVerb => 'فعل';

  @override
  String get vocabAdjective => 'صفة';

  @override
  String get vocabAdverb => 'ظرف';

  @override
  String get vocabPronoun => 'ضمير';

  @override
  String get vocabDeterminer => 'محدد';

  @override
  String get vocabPreposition => 'حرف جر';

  @override
  String get vocabConjunction => 'حرف عطف';

  @override
  String get vocabInterjection => 'صيغة تعجب';

  @override
  String get vocabExpression => 'تعبير';

  @override
  String get vocabOther => 'أخرى';

  @override
  String get profileDonate => 'تبرع';

  @override
  String get profileDonateDescription => 'شكراً لدعمك';

  @override
  String get profilePrivacy => 'سياسة الخصوصية';

  @override
  String get profilePrivacyDescription => 'افتح سياسة الخصوصية';

  @override
  String get unavailable => 'الميزة غير متاحة بعد.';
}
