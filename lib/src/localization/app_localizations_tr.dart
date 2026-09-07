// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Parlami';

  @override
  String get navLearn => 'Öğren';

  @override
  String get navTrain => 'Pratik Yap';

  @override
  String get navEvaluate => 'Kendini Test Et';

  @override
  String get navResults => 'Sonuçlar';

  @override
  String get navProfile => 'Profil';

  @override
  String get learnConjugation => 'Fiil Çekimi';

  @override
  String get learnConjugationDescription => 'Fiil çekimi pratiği yap';

  @override
  String get learnVocabulary => 'Kelime Bilgisi';

  @override
  String get learnVocabularyDescription => 'Konuya ve seviyeye göre';

  @override
  String get learnNumbersDates => 'Sayılar ve Tarihler';

  @override
  String get learnNumbersDatesDescription => 'Sayıları ve tarihleri yaz';

  @override
  String get learnGrammar => 'Dilbilgisi';

  @override
  String get learnGrammarDescription => 'Ders notları';

  @override
  String get learnSpelling => 'Heceleme';

  @override
  String get learnSpellingDescription => 'Yakında';

  @override
  String get trainOralExpression => 'EO - Sözlü İfade';

  @override
  String get trainOralExpressionDescription => 'Yüksek sesle cevapla';

  @override
  String get trainOralComprehension => 'CO - İşitsel Anlama';

  @override
  String get trainOralComprehensionDescription => 'Radyo istasyonlarını dinle';

  @override
  String get trainWrittenComprehension => 'CE - Okuduğunu Anlama';

  @override
  String get trainWrittenComprehensionDescription => 'İtalyanca haberleri oku';

  @override
  String get trainWrittenExpression => 'EE - Yazılı İfade';

  @override
  String get trainWrittenExpressionDescription => 'Cümleleri çevir';

  @override
  String get evaluateTitle => 'Kendini test et - Gerçek hayat durumları';

  @override
  String get evaluateIntro =>
      'Gerçek hayat durumlarını simüle etmek için aynı anda birkaç beceriyi birleştirin.';

  @override
  String get evaluateProgression =>
      'Öğrenme temelleri oluşturur. Pratik, belirli becerileri hedefler. Test, genel ustalığınızı ölçer.';

  @override
  String get scenarioDailyConversation => 'Günlük konuşma';

  @override
  String get scenarioArticleSummary => 'Makale özeti';

  @override
  String get scenarioMatchDebrief => 'Maç değerlendirmesi';

  @override
  String get scenarioQuickDiscussion => 'Hızlı tartışma';

  @override
  String get scenarioDailyConversationDetails =>
      'Dinle, anla ve doğal bir şekilde cevap ver.';

  @override
  String get scenarioArticleSummaryDetails =>
      'Bir metni oku, ardından net ve yapılandırılmış bir özet üret.';

  @override
  String get scenarioMatchDebriefDetails =>
      'Kelime dağarcığı ve kültürel referanslar kullanarak bir maç hakkında konuşun.';

  @override
  String get scenarioQuickDiscussionDetails =>
      'Zaman kısıtlamaları olan dinamik bir sohbette hızlı tepki verin.';

  @override
  String get resultsComingSoon => 'Performans grafikleri yakında';

  @override
  String get grammarTitle => 'Dilbilgisi';

  @override
  String get grammarComingSoon =>
      'Dilbilgisi notları - içerik yakında.\n\nBu modüle sayfalar veya işlenmiş Markdown olarak notlar ekleyin.';

  @override
  String get spellingTitle => 'Heceleme';

  @override
  String get spellingComingSoon => 'Heceleme modülü - yakında.';

  @override
  String get ceTitle => 'CE - Okuduğunu Anlama';

  @override
  String get ceIntro =>
      'Okuduğunu anlamayı geliştirmek için İtalyanca makaleler oku';

  @override
  String get ceAdviceTitle => 'Tavsiye';

  @override
  String get ceAdvice =>
      'Kısa makalelerle başlayın. Önce genel anlamı anlamak için okuyun, ardından ayrıntılar için tekrar okuyun.';

  @override
  String get ceOpenSource => 'Kaynak siteyi aç';

  @override
  String get eeTitle => 'EE - Yazılı İfade';

  @override
  String get eePrompt => 'Aşağıdaki cümleyi İtalyancaya çevirin';

  @override
  String get eeTranslationLabel => 'İtalyanca çeviriniz';

  @override
  String get eeTranslationHint => 'Çevirinizi buraya yazın...';

  @override
  String get eeCheck => 'Kontrol Et';

  @override
  String get eeCorrection => 'Düzeltme';

  @override
  String get eeYourAnswer => 'Cevabınız';

  @override
  String get coTitle => 'CO - İşitsel Anlama';

  @override
  String get coIntro =>
      'İşitsel anlamanızı geliştirmek için İtalyan radyo istasyonlarını dinleyin';

  @override
  String get coLive => 'Canlı:';

  @override
  String coStopped(Object station) {
    return '$station durduruldu';
  }

  @override
  String coConnecting(Object station) {
    return '$station bağlanıyor...';
  }

  @override
  String get coPlay => 'Oynat';

  @override
  String get coStop => 'Durdur';

  @override
  String get coPause => 'Duraklat';

  @override
  String get coResume => 'Devam Et';

  @override
  String get coRadioGeneral => 'İtalyan genel yayın radyosu';

  @override
  String get coMusicEntertainment => 'Müzik ve eğlence';

  @override
  String get coCultureNews => 'Kültür ve haberler';

  @override
  String get coPopNews => 'Pop müzik ve haberler';

  @override
  String get coRadioNewsMusic => 'Haber ve müzik';

  @override
  String get coNational => 'Ulusal';

  @override
  String get ceAnsaDescription => 'İtalyan haber ajansı - kısa makaleler';

  @override
  String get ceRepubblicaDescription => 'Büyük İtalyan günlük gazetesi';

  @override
  String get ceCorriereDescription => 'Referans gazete';

  @override
  String get ceIlPostDescription => 'Haberler ve analizler';

  @override
  String get ceRaiDescription => 'RAI haberleri';

  @override
  String get ceEasyItalianDescription => 'Kolay İtalyanca haberler';

  @override
  String get eoTitle => 'EO - Sözlü İfade';

  @override
  String get eoChooseLevel => 'Seviyeyi seç';

  @override
  String eoLevel(String level) {
    return 'Seviye $level';
  }

  @override
  String get eoNoQuestion => 'Soru yok';

  @override
  String get eoQuestion => 'Soru';

  @override
  String get eoHint => 'İpucu';

  @override
  String get eoClickHint => 'İpucu için tıklayın';

  @override
  String get eoAnswerHint => 'Cevap ipucu';

  @override
  String get eoClickAnswerHint => 'Cevap ipucu için tıklayın';

  @override
  String get eoTimer => 'Zamanlayıcı';

  @override
  String get eoTotal => 'Toplam';

  @override
  String get eoSpeech => 'Konuşma';

  @override
  String get eoHesitation => 'Duraksama';

  @override
  String get eoStart => 'Başla';

  @override
  String get eoStop => 'Durdur';

  @override
  String get eoReset => 'Sıfırla';

  @override
  String get eoModeFree => 'Serbest mod';

  @override
  String get eoModeFreeDescription =>
      'Yardım almadan istediğiniz zaman ilerleyin.';

  @override
  String get eoModeEasy => 'Kolay';

  @override
  String get eoModeEasyDescription =>
      'Cevapla, kendini değerlendir ve bir ipucu gör.';

  @override
  String get eoModeHard => 'Zor';

  @override
  String get eoModeHardDescription =>
      'Zamanlayıcı, duraksama takibi ve öz değerlendirme.';

  @override
  String eoLevelChip(Object level) {
    return 'Seviye $level';
  }

  @override
  String get eoSelfEvaluation => 'Öz Değerlendirme';

  @override
  String get eoExcellent => 'Mükemmel';

  @override
  String get eoGood => 'İyi';

  @override
  String get eoAverage => 'Orta';

  @override
  String get eoDifficult => 'Zor';

  @override
  String get eoNextQuestion => 'Sonraki soru';

  @override
  String get numDateTitle => 'Sayılar ve Tarihler';

  @override
  String get numDateNumbersTab => 'Sayılar';

  @override
  String get numDateDatesTab => 'Tarihler';

  @override
  String get numDateTimeTab => 'Saat';

  @override
  String get numDatePreviewNumberTitle => 'Bir önizleme numarası seçin';

  @override
  String get numDatePreviewNumberSubtitle =>
      'Bu değer sadece hızlı dönüştürme için kullanılır.';

  @override
  String get numDatePreviewNumberLabel => 'Önizleme numarası';

  @override
  String get numDatePositiveInteger =>
      'Başlamak için pozitif bir tam sayı girin.';

  @override
  String get numDateTraining => 'Pratik';

  @override
  String get numDateTrainingNumberSubtitle =>
      'İtalyanca kelimelerle yazma pratiği yapmak için başka bir numara seçin.';

  @override
  String get numDateTrainingNumberLabel => 'Pratik numarası';

  @override
  String get numDateAnswerInWords => 'Kelimelerle cevabınız';

  @override
  String get numDateCheck => 'Kontrol Et';

  @override
  String get numDateClear => 'Temizle';

  @override
  String get numDatePreviewDateTitle => 'Bir önizleme tarihi seçin';

  @override
  String get numDatePreviewDateSubtitle =>
      'Bu tarih sadece hızlı referans için kullanılır.';

  @override
  String get numDateToday => 'Bugün';

  @override
  String get numDateTrainingDateSubtitle =>
      'İtalyanca kelimelerle yazma pratiği yapmak için başka bir tarih seçin.';

  @override
  String numDateExpectedDay(String day) {
    return 'Beklenen gün: $day';
  }

  @override
  String get numDatePreviewTimeTitle => 'Bir önizleme saati seçin';

  @override
  String get numDatePreviewTimeSubtitle =>
      'Bu saat sadece hızlı okuma için kullanılır.';

  @override
  String get numDateTrainingTimeSubtitle =>
      'Pratik yapmak için özellikle çeyrek saatler olmak üzere başka bir zaman seçin.';

  @override
  String get numDateDefinedTime => 'Belirlenen zaman:';

  @override
  String get answerCorrect => 'Doğru cevap.';

  @override
  String get answerIncorrect => 'Yanlış cevap.';

  @override
  String answerYourAnswer(String answer) {
    return 'Cevabınız: $answer';
  }

  @override
  String answerExpected(String answer) {
    return 'Doğru cevap: $answer';
  }

  @override
  String get conjugationTitle => 'Fiil Çekimi';

  @override
  String get conjugationRegular => 'Düzenli';

  @override
  String get conjugationSemiRegular => 'Yarı Düzenli';

  @override
  String get conjugationIrregular => 'Düzensiz';

  @override
  String get conjugationPronominal => 'Dönüşlü';

  @override
  String conjugationGroup(Object group) {
    return 'Grup $group';
  }

  @override
  String conjugationAuxiliary(Object auxiliary) {
    return 'Yardımcı fiil $auxiliary';
  }

  @override
  String get conjugationShowAnswers => 'Göster';

  @override
  String get conjugationHideAnswers => 'Gizle';

  @override
  String get conjugationNonPronominal => 'Dönüşlü olmayan';

  @override
  String get conjugationDetailsVisibility => 'Fiil özelliklerini göster';

  @override
  String get conjugationClearFilters => 'Tüm filtreleri temizle';

  @override
  String get conjugationChooseVerb => 'Bir fiil seçin';

  @override
  String get conjugationRandomVerb => 'Rastgele fiil';

  @override
  String get conjugationHideBaseVerb => 'Kök fiili gizle';

  @override
  String get conjugationChooseMood => 'Bir kip seç';

  @override
  String get conjugationChooseTense => 'Bir zaman seç';

  @override
  String conjugationVerb(String verb) {
    return 'Fiil: $verb';
  }

  @override
  String conjugationTranslation(String translation) {
    return 'Çeviri: $translation';
  }

  @override
  String conjugationMood(String mood) {
    return 'Kip: $mood';
  }

  @override
  String conjugationTense(String tense) {
    return 'Zaman: $tense';
  }

  @override
  String conjugationLoadingError(String error) {
    return 'Yükleme hatası: $error';
  }

  @override
  String get profileLanguage => 'Arayüz dili';

  @override
  String get profileUserName => 'Kullanıcı adı';

  @override
  String get profileAbout => 'Uygulama hakkında';

  @override
  String get profileAboutDescription =>
      'Parlami İtalyanca öğrenmenize yardımcı olur.';

  @override
  String get profileTheme => 'Tema';

  @override
  String get profileThemeDescription => 'Açık ve koyu mod arasında geçiş yap';

  @override
  String get themeSystem => 'Sistem teması';

  @override
  String get themeLight => 'Açık tema';

  @override
  String get themeDark => 'Koyu tema';

  @override
  String get vocabTitle => 'Kelime Bilgisi';

  @override
  String get vocabReview => 'Gözden Geçir';

  @override
  String get vocabCatalog => 'Katalog';

  @override
  String get vocabAdd => 'Ekle';

  @override
  String get vocabImport => 'Kelimeleri içe aktar';

  @override
  String get vocabExport => 'Kelimelerimi dışa aktar';

  @override
  String get vocabResetCatalog => 'Orijinal kataloğu sıfırla';

  @override
  String get vocabSelect => 'Seç';

  @override
  String get vocabSave => 'Kelimeyi kaydet';

  @override
  String get vocabChooseCategories => 'Kelime kategorilerini seç';

  @override
  String get vocabPasteJson =>
      'Kelimelerin JSON listesini yapıştırın. Kabul edilen format:';

  @override
  String get vocabCancel => 'İptal';

  @override
  String vocabImportError(String error) {
    return 'İçe aktarma başarısız: $error';
  }

  @override
  String get vocabResetQuestion => 'Orijinal kelimeleri sıfırla?';

  @override
  String get vocabResetDescription =>
      'Bu, içe aktarılan kelimeleri sıfırlar ve orijinal kataloğu yeniden uygular. Kullanıcı tarafından eklenen kelimeler tutulur.';

  @override
  String get vocabDeleteQuestion => 'Bu kelime silinsin mi?';

  @override
  String vocabDeleteDescription(String word) {
    return '\"$word\" katalogdan silinsin mi?';
  }

  @override
  String get vocabDelete => 'Sil';

  @override
  String get vocabNoCategory => 'Hiçbir kategori seçilmedi';

  @override
  String get vocabLoading => 'Kelime bilgisi yükleniyor...';

  @override
  String get vocabFields => 'Sözcük alanları';

  @override
  String get vocabNoMatch => 'Geçerli filtrelere uyan kelime yok.';

  @override
  String get vocabNoTrainingMatch => 'Eğitim filtrelerine uyan kelime yok.';

  @override
  String get vocabTrainingWord => 'Pratik kelimesi';

  @override
  String vocabScore(String score) {
    return 'Puan %$score';
  }

  @override
  String vocabBaseLanguage(String language) {
    return 'Temel dil: $language';
  }

  @override
  String get vocabHiddenAnswer => 'Cevap gizli.';

  @override
  String get vocabKnown => 'Bilinçli';

  @override
  String get vocabUnknown => 'Bilinmiyor';

  @override
  String get vocabNextWord => 'Sonraki kelime';

  @override
  String vocabCategories(String categories) {
    return 'Kategoriler: $categories';
  }

  @override
  String get vocabPreparing => 'Pratik kelimeleri hazırlanıyor...';

  @override
  String get vocabPriority => 'Henüz ustalaşmamış kelimelere öncelik ver';

  @override
  String get vocabPriorityDescription =>
      'Rastgele karıştırmak için devre dışı bırakın.';

  @override
  String vocabSelectedCount(String count) {
    return 'Seçilen kelimeler: $count';
  }

  @override
  String get vocabClearAll => 'Hepsini temizle';

  @override
  String get vocabConfirm => 'Onayla';

  @override
  String get conjugationCheck => 'Kontrol Et';

  @override
  String get conjugationNextVerb => 'Sonraki fiil';

  @override
  String get eeNextSentence => 'Sonraki cümle';

  @override
  String get eeNoSentence => 'Mevcut cümle yok';

  @override
  String ceLevel(String level) {
    return 'Seviye: $level';
  }

  @override
  String get sampleItems => 'Örnek öğeler';

  @override
  String get sampleItemDetails => 'Öğe detayları';

  @override
  String get sampleMoreInformation => 'Daha fazla bilgi burada';

  @override
  String sampleItem(String id) {
    return 'Örnek öğe $id';
  }

  @override
  String get evaluateScenarioOral => 'CO + EO';

  @override
  String get evaluateScenarioWritten => 'CE + EE';

  @override
  String get evaluateScenarioCulture => 'EO + Kültür';

  @override
  String get evaluateScenarioSpeed => 'CO + EO + Hız';

  @override
  String get conjugationAnswerLabel => 'Cevabınız';

  @override
  String get vocabWords => 'Kelimeler';

  @override
  String get vocabAverageMastery => 'Ortalama ustalık';

  @override
  String get vocabMode => 'Mod';

  @override
  String get vocabMastery => 'Ustalık';

  @override
  String get vocabRandom => 'Rastgele';

  @override
  String get vocabSearchWord => 'Bir kelime ara';

  @override
  String get vocabBaseLanguageDisplay => 'Temel dili göster';

  @override
  String get vocabDifficulty => 'Zorluk';

  @override
  String get vocabPartOfSpeech => 'Sözcük türü';

  @override
  String get vocabChooseFilterCategories => 'Filtre kategorilerini seç';

  @override
  String get vocabSearchTrainingWord => 'Bir kelime ara';

  @override
  String get vocabTrainingBaseLanguage => 'Pratik temel dili';

  @override
  String get vocabFilters => 'Filtreler';

  @override
  String get vocabChooseTrainingCategories => 'Pratik kategorilerini seç';

  @override
  String get vocabItalianWord => 'İtalyanca kelime';

  @override
  String get vocabFrenchTranslation => 'Çeviri (temel dil)';

  @override
  String get vocabOptionalArticle => 'İsteğe bağlı makale (il, la, l\', vb.)';

  @override
  String get vocabCategoriesTitle => 'Kategoriler';

  @override
  String get vocabSearchCategory => 'Bir kategori ara';

  @override
  String vocabAddCategory(String category) {
    return '\"$category\" ekle';
  }

  @override
  String get vocabDeleteFromCatalog => 'Katalogdan sil';

  @override
  String get vocabHideAnswer => 'Cevabı gizle';

  @override
  String get vocabShowAnswer => 'Cevabı göster';

  @override
  String get vocabStatusSaved => 'Kelime kaydedildi ve filtrelerde mevcut.';

  @override
  String vocabStatusImport(String count) {
    return 'İçe aktarma tamamlandı: $count kelime eklendi.';
  }

  @override
  String vocabStatusExport(String location) {
    return 'Dışa aktarma tamamlandı: $location';
  }

  @override
  String get vocabStatusNoExport => 'Dışa aktarılacak kullanıcı kelimesi yok.';

  @override
  String get vocabStatusReset => 'Orijinal katalog sıfırlandı.';

  @override
  String get vocabStatusDeleted => 'Kelime katalogdan kaldırıldı.';

  @override
  String get vocabStatusKnown => 'Not edildi.';

  @override
  String get vocabStatusReview => 'Yakında gözden geçir.';

  @override
  String get vocabItalian => 'İtalyanca';

  @override
  String get vocabFrench => 'Fransızca';

  @override
  String get vocabSourceOriginal => 'Orijinal';

  @override
  String get vocabSourceUser => 'Kullanıcı';

  @override
  String get vocabNoun => 'İsim';

  @override
  String get vocabVerb => 'Fiil';

  @override
  String get vocabAdjective => 'Sıfat';

  @override
  String get vocabAdverb => 'Zarf';

  @override
  String get vocabPronoun => 'Zamir';

  @override
  String get vocabDeterminer => 'Belirleyici';

  @override
  String get vocabPreposition => 'Edat';

  @override
  String get vocabConjunction => 'Bağlaç';

  @override
  String get vocabInterjection => 'Ünlem';

  @override
  String get vocabExpression => 'İfade';

  @override
  String get vocabOther => 'Diğer';

  @override
  String get profileDonate => 'Bağış yap';

  @override
  String get profileDonateDescription => 'Desteğiniz için teşekkürler';

  @override
  String get profilePrivacy => 'Gizlilik politikası';

  @override
  String get profilePrivacyDescription => 'Gizlilik politikasını aç';

  @override
  String get unavailable => 'Özellik henüz mevcut değil.';
}
