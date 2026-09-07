// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Parlami';

  @override
  String get navLearn => 'Учить';

  @override
  String get navTrain => 'Практика';

  @override
  String get navEvaluate => 'Проверить себя';

  @override
  String get navResults => 'Результаты';

  @override
  String get navProfile => 'Профиль';

  @override
  String get learnConjugation => 'Спряжение';

  @override
  String get learnConjugationDescription => 'Практика спряжения глаголов';

  @override
  String get learnVocabulary => 'Словарный запас';

  @override
  String get learnVocabularyDescription => 'По темам и уровням';

  @override
  String get learnNumbersDates => 'Числа и даты';

  @override
  String get learnNumbersDatesDescription => 'Писать числа и даты';

  @override
  String get learnGrammar => 'Грамматика';

  @override
  String get learnGrammarDescription => 'Заметки курса';

  @override
  String get learnSpelling => 'Орфография';

  @override
  String get learnSpellingDescription => 'Скоро';

  @override
  String get trainOralExpression => 'EO - Устная речь';

  @override
  String get trainOralExpressionDescription => 'Отвечать вслух';

  @override
  String get trainOralComprehension => 'CO - Аудирование';

  @override
  String get trainOralComprehensionDescription => 'Слушать радиостанции';

  @override
  String get trainWrittenComprehension => 'CE - Чтение';

  @override
  String get trainWrittenComprehensionDescription =>
      'Читать итальянские новости';

  @override
  String get trainWrittenExpression => 'EE - Письмо';

  @override
  String get trainWrittenExpressionDescription => 'Переводить предложения';

  @override
  String get evaluateTitle => 'Проверь себя - Реальные ситуации';

  @override
  String get evaluateIntro =>
      'Комбинируйте несколько навыков, чтобы симулировать реальные ситуации.';

  @override
  String get evaluateProgression =>
      'Обучение закладывает основы. Практика развивает навыки. Тестирование измеряет общий уровень.';

  @override
  String get scenarioDailyConversation => 'Ежедневный разговор';

  @override
  String get scenarioArticleSummary => 'Краткое содержание статьи';

  @override
  String get scenarioMatchDebrief => 'Обсуждение матча';

  @override
  String get scenarioQuickDiscussion => 'Быстрая дискуссия';

  @override
  String get scenarioDailyConversationDetails =>
      'Слушайте, понимайте и отвечайте естественно.';

  @override
  String get scenarioArticleSummaryDetails =>
      'Прочитайте текст и сделайте четкое резюме.';

  @override
  String get scenarioMatchDebriefDetails =>
      'Поговорите о матче, используя лексику и культурные отсылки.';

  @override
  String get scenarioQuickDiscussionDetails =>
      'Быстро реагируйте в динамичном обмене репликами.';

  @override
  String get resultsComingSoon => 'Графики производительности скоро';

  @override
  String get grammarTitle => 'Грамматика';

  @override
  String get grammarComingSoon =>
      'Заметки по грамматике - скоро.\n\nДобавляйте заметки в этот модуль как страницы или Markdown.';

  @override
  String get spellingTitle => 'Орфография';

  @override
  String get spellingComingSoon => 'Модуль орфографии - скоро.';

  @override
  String get ceTitle => 'CE - Чтение';

  @override
  String get ceIntro =>
      'Читайте итальянские статьи для улучшения понимания текста';

  @override
  String get ceAdviceTitle => 'Совет';

  @override
  String get ceAdvice =>
      'Начните с коротких статей. Сначала читайте для общего смысла, затем для деталей.';

  @override
  String get ceOpenSource => 'Открыть сайт источника';

  @override
  String get eeTitle => 'EE - Письмо';

  @override
  String get eePrompt => 'Переведите следующее предложение на итальянский';

  @override
  String get eeTranslationLabel => 'Ваш перевод на итальянский';

  @override
  String get eeTranslationHint => 'Напишите перевод здесь...';

  @override
  String get eeCheck => 'Проверить';

  @override
  String get eeCorrection => 'Исправление';

  @override
  String get eeYourAnswer => 'Ваш ответ';

  @override
  String get coTitle => 'CO - Аудирование';

  @override
  String get coIntro =>
      'Слушайте итальянские радиостанции для улучшения аудирования';

  @override
  String get coLive => 'Прямой эфир:';

  @override
  String coStopped(Object station) {
    return '$station остановлено';
  }

  @override
  String coConnecting(Object station) {
    return 'Подключение к $station...';
  }

  @override
  String get coPlay => 'Играть';

  @override
  String get coStop => 'Стоп';

  @override
  String get coPause => 'Пауза';

  @override
  String get coResume => 'Продолжить';

  @override
  String get coRadioGeneral => 'Итальянское радио широкого формата';

  @override
  String get coMusicEntertainment => 'Музыка и развлечения';

  @override
  String get coCultureNews => 'Культура и новости';

  @override
  String get coPopNews => 'Поп-музыка и новости';

  @override
  String get coRadioNewsMusic => 'Новости и музыка';

  @override
  String get coNational => 'Национальное';

  @override
  String get ceAnsaDescription =>
      'Итальянское информационное агентство — короткие статьи';

  @override
  String get ceRepubblicaDescription => 'Крупная итальянская ежедневная газета';

  @override
  String get ceCorriereDescription => 'Авторитетное издание';

  @override
  String get ceIlPostDescription => 'Новости и аналитика';

  @override
  String get ceRaiDescription => 'Новости RAI';

  @override
  String get ceEasyItalianDescription => 'Новости на простом итальянском';

  @override
  String get eoTitle => 'EO - Устная речь';

  @override
  String get eoChooseLevel => 'Выберите уровень';

  @override
  String eoLevel(String level) {
    return 'Уровень $level';
  }

  @override
  String get eoNoQuestion => 'Нет доступных вопросов';

  @override
  String get eoQuestion => 'Вопрос';

  @override
  String get eoHint => 'Подсказка';

  @override
  String get eoClickHint => 'Нажмите для подсказки';

  @override
  String get eoAnswerHint => 'Ключ к ответу';

  @override
  String get eoClickAnswerHint => 'Нажмите для ключа к ответу';

  @override
  String get eoTimer => 'Таймер';

  @override
  String get eoTotal => 'Всего';

  @override
  String get eoSpeech => 'Речь';

  @override
  String get eoHesitation => 'Заминка';

  @override
  String get eoStart => 'Старт';

  @override
  String get eoStop => 'Стоп';

  @override
  String get eoReset => 'Сброс';

  @override
  String get eoModeFree => 'Свободный режим';

  @override
  String get eoModeFreeDescription =>
      'Двигайтесь вперед, когда хотите, без помощи.';

  @override
  String get eoModeEasy => 'Легкий';

  @override
  String get eoModeEasyDescription =>
      'Ответьте, оцените себя и посмотрите подсказку.';

  @override
  String get eoModeHard => 'Сложный';

  @override
  String get eoModeHardDescription =>
      'Таймер, отслеживание заминок и самооценка.';

  @override
  String eoLevelChip(Object level) {
    return 'Уровень $level';
  }

  @override
  String get eoSelfEvaluation => 'Самооценка';

  @override
  String get eoExcellent => 'Отлично';

  @override
  String get eoGood => 'Хорошо';

  @override
  String get eoAverage => 'Средне';

  @override
  String get eoDifficult => 'Сложно';

  @override
  String get eoNextQuestion => 'Следующий вопрос';

  @override
  String get numDateTitle => 'Числа и даты';

  @override
  String get numDateNumbersTab => 'Числа';

  @override
  String get numDateDatesTab => 'Даты';

  @override
  String get numDateTimeTab => 'Время';

  @override
  String get numDatePreviewNumberTitle => 'Выберите число для предпросмотра';

  @override
  String get numDatePreviewNumberSubtitle =>
      'Это значение используется только для быстрой конвертации.';

  @override
  String get numDatePreviewNumberLabel => 'Число предпросмотра';

  @override
  String get numDatePositiveInteger =>
      'Введите целое положительное число для начала.';

  @override
  String get numDateTraining => 'Практика';

  @override
  String get numDateTrainingNumberSubtitle =>
      'Выберите другое число, чтобы попрактиковаться писать его по-итальянски.';

  @override
  String get numDateTrainingNumberLabel => 'Число для практики';

  @override
  String get numDateAnswerInWords => 'Ваш ответ прописью';

  @override
  String get numDateCheck => 'Проверить';

  @override
  String get numDateClear => 'Очистить';

  @override
  String get numDatePreviewDateTitle => 'Выберите дату для предпросмотра';

  @override
  String get numDatePreviewDateSubtitle =>
      'Эта дата используется только для справки.';

  @override
  String get numDateToday => 'Сегодня';

  @override
  String get numDateTrainingDateSubtitle =>
      'Выберите другую дату, чтобы попрактиковаться писать её по-итальянски.';

  @override
  String numDateExpectedDay(String day) {
    return 'Ожидаемый день: $day';
  }

  @override
  String get numDatePreviewTimeTitle => 'Выберите время для предпросмотра';

  @override
  String get numDatePreviewTimeSubtitle =>
      'Это время используется только для справки.';

  @override
  String get numDateTrainingTimeSubtitle =>
      'Выберите другое время для практики, особенно четверти часа.';

  @override
  String get numDateDefinedTime => 'Заданное время:';

  @override
  String get answerCorrect => 'Правильный ответ.';

  @override
  String get answerIncorrect => 'Неправильный ответ.';

  @override
  String answerYourAnswer(String answer) {
    return 'Ваш ответ: $answer';
  }

  @override
  String answerExpected(String answer) {
    return 'Правильный ответ: $answer';
  }

  @override
  String get conjugationTitle => 'Спряжение';

  @override
  String get conjugationRegular => 'Правильные';

  @override
  String get conjugationSemiRegular => 'Полуправильные';

  @override
  String get conjugationIrregular => 'Неправильные';

  @override
  String get conjugationPronominal => 'Местоименные';

  @override
  String conjugationGroup(Object group) {
    return 'Группа $group';
  }

  @override
  String conjugationAuxiliary(Object auxiliary) {
    return 'Вспомогательный глагол $auxiliary';
  }

  @override
  String get conjugationShowAnswers => 'Показать';

  @override
  String get conjugationHideAnswers => 'Скрыть';

  @override
  String get conjugationNonPronominal => 'Неместоименные';

  @override
  String get conjugationDetailsVisibility => 'Показать характеристики глагола';

  @override
  String get conjugationClearFilters => 'Очистить все фильтры';

  @override
  String get conjugationChooseVerb => 'Выберите глагол';

  @override
  String get conjugationRandomVerb => 'Случайный глагол';

  @override
  String get conjugationHideBaseVerb => 'Скрыть инфинитив';

  @override
  String get conjugationChooseMood => 'Выберите наклонение';

  @override
  String get conjugationChooseTense => 'Выберите время';

  @override
  String conjugationVerb(String verb) {
    return 'Глагол: $verb';
  }

  @override
  String conjugationTranslation(String translation) {
    return 'Перевод: $translation';
  }

  @override
  String conjugationMood(String mood) {
    return 'Наклонение: $mood';
  }

  @override
  String conjugationTense(String tense) {
    return 'Время: $tense';
  }

  @override
  String conjugationLoadingError(String error) {
    return 'Ошибка загрузки: $error';
  }

  @override
  String get profileLanguage => 'Язык интерфейса';

  @override
  String get profileUserName => 'Имя пользователя';

  @override
  String get profileAbout => 'О приложении';

  @override
  String get profileAboutDescription => 'Parlami помогает изучать итальянский.';

  @override
  String get profileTheme => 'Тема';

  @override
  String get profileThemeDescription =>
      'Переключение между светлой и темной темой';

  @override
  String get themeSystem => 'Системная тема';

  @override
  String get themeLight => 'Светлая тема';

  @override
  String get themeDark => 'Темная тема';

  @override
  String get vocabTitle => 'Словарный запас';

  @override
  String get vocabReview => 'Повторение';

  @override
  String get vocabCatalog => 'Каталог';

  @override
  String get vocabAdd => 'Добавить';

  @override
  String get vocabImport => 'Импорт слов';

  @override
  String get vocabExport => 'Экспорт моих слов';

  @override
  String get vocabResetCatalog => 'Сбросить оригинальный каталог';

  @override
  String get vocabSelect => 'Выбрать';

  @override
  String get vocabSave => 'Сохранить слово';

  @override
  String get vocabChooseCategories => 'Выбрать категории слов';

  @override
  String get vocabPasteJson => 'Вставьте JSON список слов. Принимаемый формат:';

  @override
  String get vocabCancel => 'Отмена';

  @override
  String vocabImportError(String error) {
    return 'Ошибка импорта: $error';
  }

  @override
  String get vocabResetQuestion => 'Сбросить оригинальные слова?';

  @override
  String get vocabResetDescription =>
      'Это сбросит импортированные слова и вернет оригинальный каталог. Слова пользователя сохранятся.';

  @override
  String get vocabDeleteQuestion => 'Удалить это слово?';

  @override
  String vocabDeleteDescription(String word) {
    return 'Удалить \"$word\" из каталога?';
  }

  @override
  String get vocabDelete => 'Удалить';

  @override
  String get vocabNoCategory => 'Категория не выбрана';

  @override
  String get vocabLoading => 'Загрузка словаря...';

  @override
  String get vocabFields => 'Лексические поля';

  @override
  String get vocabNoMatch => 'Нет слов, соответствующих текущим фильтрам.';

  @override
  String get vocabNoTrainingMatch =>
      'Нет слов, соответствующих фильтрам тренировки.';

  @override
  String get vocabTrainingWord => 'Слово для тренировки';

  @override
  String vocabScore(String score) {
    return 'Счет $score%';
  }

  @override
  String vocabBaseLanguage(String language) {
    return 'Базовый язык: $language';
  }

  @override
  String get vocabHiddenAnswer => 'Ответ скрыт.';

  @override
  String get vocabKnown => 'Известно';

  @override
  String get vocabUnknown => 'Неизвестно';

  @override
  String get vocabNextWord => 'Следующее слово';

  @override
  String vocabCategories(String categories) {
    return 'Категории: $categories';
  }

  @override
  String get vocabPreparing => 'Подготовка слов для тренировки...';

  @override
  String get vocabPriority => 'Приоритет неизученных слов';

  @override
  String get vocabPriorityDescription =>
      'Отключите для случайного перемешивания.';

  @override
  String vocabSelectedCount(String count) {
    return 'Выбрано слов: $count';
  }

  @override
  String get vocabClearAll => 'Очистить все';

  @override
  String get vocabConfirm => 'Подтвердить';

  @override
  String get conjugationCheck => 'Проверить';

  @override
  String get conjugationNextVerb => 'Следующий глагол';

  @override
  String get eeNextSentence => 'Следующее предложение';

  @override
  String get eeNoSentence => 'Нет доступных предложений';

  @override
  String ceLevel(String level) {
    return 'Уровень: $level';
  }

  @override
  String get sampleItems => 'Примеры элементов';

  @override
  String get sampleItemDetails => 'Детали элемента';

  @override
  String get sampleMoreInformation => 'Больше информации здесь';

  @override
  String sampleItem(String id) {
    return 'Пример элемента $id';
  }

  @override
  String get evaluateScenarioOral => 'CO + EO';

  @override
  String get evaluateScenarioWritten => 'CE + EE';

  @override
  String get evaluateScenarioCulture => 'EO + Культура';

  @override
  String get evaluateScenarioSpeed => 'CO + EO + Скорость';

  @override
  String get conjugationAnswerLabel => 'Ваш ответ';

  @override
  String get vocabWords => 'Слова';

  @override
  String get vocabAverageMastery => 'Среднее владение';

  @override
  String get vocabMode => 'Режим';

  @override
  String get vocabMastery => 'Владение';

  @override
  String get vocabRandom => 'Случайно';

  @override
  String get vocabSearchWord => 'Поиск слова';

  @override
  String get vocabBaseLanguageDisplay => 'Отображать базовый язык';

  @override
  String get vocabDifficulty => 'Сложность';

  @override
  String get vocabPartOfSpeech => 'Часть речи';

  @override
  String get vocabChooseFilterCategories => 'Выберите категории фильтра';

  @override
  String get vocabSearchTrainingWord => 'Поиск слова';

  @override
  String get vocabTrainingBaseLanguage => 'Базовый язык тренировки';

  @override
  String get vocabFilters => 'Фильтры';

  @override
  String get vocabChooseTrainingCategories => 'Выберите категории тренировки';

  @override
  String get vocabItalianWord => 'Итальянское слово';

  @override
  String get vocabFrenchTranslation => 'Перевод (базовый язык)';

  @override
  String get vocabOptionalArticle => 'Артикль (il, la, l\', и т.д.)';

  @override
  String get vocabCategoriesTitle => 'Категории';

  @override
  String get vocabSearchCategory => 'Поиск категории';

  @override
  String vocabAddCategory(String category) {
    return 'Добавить \"$category\"';
  }

  @override
  String get vocabDeleteFromCatalog => 'Удалить из каталога';

  @override
  String get vocabHideAnswer => 'Скрыть ответ';

  @override
  String get vocabShowAnswer => 'Показать ответ';

  @override
  String get vocabStatusSaved => 'Слово сохранено и доступно в фильтрах.';

  @override
  String vocabStatusImport(String count) {
    return 'Импорт завершен: добавлено $count слов(о).';
  }

  @override
  String vocabStatusExport(String location) {
    return 'Экспорт завершен: $location';
  }

  @override
  String get vocabStatusNoExport => 'Нет пользовательских слов для экспорта.';

  @override
  String get vocabStatusReset => 'Оригинальный каталог сброшен.';

  @override
  String get vocabStatusDeleted => 'Слово удалено из каталога.';

  @override
  String get vocabStatusKnown => 'Отмечено.';

  @override
  String get vocabStatusReview => 'Скоро повторить.';

  @override
  String get vocabItalian => 'Итальянский';

  @override
  String get vocabFrench => 'Французский';

  @override
  String get vocabSourceOriginal => 'Оригинал';

  @override
  String get vocabSourceUser => 'Пользователь';

  @override
  String get vocabNoun => 'Существительное';

  @override
  String get vocabVerb => 'Глагол';

  @override
  String get vocabAdjective => 'Прилагательное';

  @override
  String get vocabAdverb => 'Наречие';

  @override
  String get vocabPronoun => 'Местоимение';

  @override
  String get vocabDeterminer => 'Определитель';

  @override
  String get vocabPreposition => 'Предлог';

  @override
  String get vocabConjunction => 'Союз';

  @override
  String get vocabInterjection => 'Междометие';

  @override
  String get vocabExpression => 'Выражение';

  @override
  String get vocabOther => 'Другое';

  @override
  String get profileDonate => 'Сделать пожертвование';

  @override
  String get profileDonateDescription => 'Спасибо за вашу поддержку';

  @override
  String get profilePrivacy => 'Политика конфиденциальности';

  @override
  String get profilePrivacyDescription => 'Открыть политику';

  @override
  String get unavailable => 'Функция пока недоступна.';
}
