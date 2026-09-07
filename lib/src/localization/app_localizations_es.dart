// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Parlami';

  @override
  String get navLearn => 'Aprender';

  @override
  String get navTrain => 'Practicar';

  @override
  String get navEvaluate => 'Ponerse a prueba';

  @override
  String get navResults => 'Resultados';

  @override
  String get navProfile => 'Perfil';

  @override
  String get learnConjugation => 'Conjugación';

  @override
  String get learnConjugationDescription => 'Practicar la conjugación';

  @override
  String get learnVocabulary => 'Vocabulario';

  @override
  String get learnVocabularyDescription => 'Por temas y niveles';

  @override
  String get learnNumbersDates => 'Números y fechas';

  @override
  String get learnNumbersDatesDescription => 'Escribir números y fechas';

  @override
  String get learnGrammar => 'Gramática';

  @override
  String get learnGrammarDescription => 'Notas del curso';

  @override
  String get learnSpelling => 'Ortografía';

  @override
  String get learnSpellingDescription => 'Próximamente';

  @override
  String get trainOralExpression => 'EO - Expresión oral';

  @override
  String get trainOralExpressionDescription => 'Responder en voz alta';

  @override
  String get trainOralComprehension => 'CO - Comprensión oral';

  @override
  String get trainOralComprehensionDescription => 'Escuchar emisoras de radio';

  @override
  String get trainWrittenComprehension => 'CE - Comprensión escrita';

  @override
  String get trainWrittenComprehensionDescription => 'Leer noticias italianas';

  @override
  String get trainWrittenExpression => 'EE - Expresión escrita';

  @override
  String get trainWrittenExpressionDescription => 'Traducir frases';

  @override
  String get evaluateTitle => 'Ponte a prueba - Situaciones reales';

  @override
  String get evaluateIntro =>
      'Combina varias habilidades al mismo tiempo para simular situaciones de la vida real.';

  @override
  String get evaluateProgression =>
      'Aprender sienta las bases. Practicar se enfoca en habilidades específicas. Ponerse a prueba mide tu dominio general.';

  @override
  String get scenarioDailyConversation => 'Conversación diaria';

  @override
  String get scenarioArticleSummary => 'Resumen de artículo';

  @override
  String get scenarioMatchDebrief => 'Análisis de partido';

  @override
  String get scenarioQuickDiscussion => 'Discusión rápida';

  @override
  String get scenarioDailyConversationDetails =>
      'Escucha, comprende y luego responde con naturalidad.';

  @override
  String get scenarioArticleSummaryDetails =>
      'Lee un texto y elabora un resumen claro y estructurado.';

  @override
  String get scenarioMatchDebriefDetails =>
      'Habla de un partido usando vocabulario y referencias culturales.';

  @override
  String get scenarioQuickDiscussionDetails =>
      'Reacciona rápidamente en un intercambio dinámico con límite de tiempo.';

  @override
  String get resultsComingSoon => 'Gráficos de rendimiento (próximamente)';

  @override
  String get grammarTitle => 'Gramática';

  @override
  String get grammarComingSoon =>
      'Notas de gramática - contenido próximamente.\n\nAñade notas a este módulo como páginas o Markdown renderizado.';

  @override
  String get spellingTitle => 'Ortografía';

  @override
  String get spellingComingSoon => 'Módulo de ortografía - próximamente.';

  @override
  String get ceTitle => 'CE - Comprensión escrita';

  @override
  String get ceIntro =>
      'Lee artículos en italiano para mejorar tu comprensión escrita';

  @override
  String get ceAdviceTitle => 'Consejo';

  @override
  String get ceAdvice =>
      'Empieza con artículos cortos. Lee primero para entender el sentido general, luego vuelve a leer para los detalles.';

  @override
  String get ceOpenSource => 'Abrir el sitio web de origen';

  @override
  String get eeTitle => 'EE - Expresión escrita';

  @override
  String get eePrompt => 'Traduce la siguiente frase al italiano';

  @override
  String get eeTranslationLabel => 'Tu traducción al italiano';

  @override
  String get eeTranslationHint => 'Escribe tu traducción aquí...';

  @override
  String get eeCheck => 'Comprobar';

  @override
  String get eeCorrection => 'Corrección';

  @override
  String get eeYourAnswer => 'Tu respuesta';

  @override
  String get coTitle => 'CO - Comprensión oral';

  @override
  String get coIntro =>
      'Escucha radios italianas para mejorar tu comprensión oral';

  @override
  String get coLive => 'En directo:';

  @override
  String coStopped(Object station) {
    return '$station detenida';
  }

  @override
  String coConnecting(Object station) {
    return 'Conectando con $station...';
  }

  @override
  String get coPlay => 'Reproducir';

  @override
  String get coStop => 'Detener';

  @override
  String get coPause => 'Pausa';

  @override
  String get coResume => 'Reanudar';

  @override
  String get coRadioGeneral => 'Radio generalista italiana';

  @override
  String get coMusicEntertainment => 'Música y entretenimiento';

  @override
  String get coCultureNews => 'Cultura y noticias';

  @override
  String get coPopNews => 'Música pop y noticias';

  @override
  String get coRadioNewsMusic => 'Noticias y música';

  @override
  String get coNational => 'Nacional';

  @override
  String get ceAnsaDescription =>
      'Agencia de noticias italiana - artículos breves';

  @override
  String get ceRepubblicaDescription => 'Gran diario nacional italiano';

  @override
  String get ceCorriereDescription => 'Periódico de referencia';

  @override
  String get ceIlPostDescription => 'Noticias y análisis';

  @override
  String get ceRaiDescription => 'Noticias de la RAI';

  @override
  String get ceEasyItalianDescription => 'Noticias en italiano fácil';

  @override
  String get eoTitle => 'EO - Expresión oral';

  @override
  String get eoChooseLevel => 'Elige el nivel';

  @override
  String eoLevel(String level) {
    return 'Nivel $level';
  }

  @override
  String get eoNoQuestion => 'No hay preguntas disponibles';

  @override
  String get eoQuestion => 'Pregunta';

  @override
  String get eoHint => 'Pista';

  @override
  String get eoClickHint => 'Haz clic para ver una pista';

  @override
  String get eoAnswerHint => 'Pista de respuesta';

  @override
  String get eoClickAnswerHint => 'Haz clic para ver una pista de respuesta';

  @override
  String get eoTimer => 'Temporizador';

  @override
  String get eoTotal => 'Total';

  @override
  String get eoSpeech => 'Voz';

  @override
  String get eoHesitation => 'Duda';

  @override
  String get eoStart => 'Empezar';

  @override
  String get eoStop => 'Detener';

  @override
  String get eoReset => 'Reiniciar';

  @override
  String get eoModeFree => 'Modo libre';

  @override
  String get eoModeFreeDescription => 'Avanza cuando quieras, sin ayuda.';

  @override
  String get eoModeEasy => 'Fácil';

  @override
  String get eoModeEasyDescription =>
      'Responde, autoevalúate y mira una pista de respuesta.';

  @override
  String get eoModeHard => 'Difícil';

  @override
  String get eoModeHardDescription =>
      'Temporizador, seguimiento de dudas y autoevaluación.';

  @override
  String eoLevelChip(Object level) {
    return 'Nivel $level';
  }

  @override
  String get eoSelfEvaluation => 'Autoevaluación';

  @override
  String get eoExcellent => 'Excelente';

  @override
  String get eoGood => 'Bien';

  @override
  String get eoAverage => 'Regular';

  @override
  String get eoDifficult => 'Difícil';

  @override
  String get eoNextQuestion => 'Siguiente pregunta';

  @override
  String get numDateTitle => 'Números y fechas';

  @override
  String get numDateNumbersTab => 'Números';

  @override
  String get numDateDatesTab => 'Fechas';

  @override
  String get numDateTimeTab => 'Hora';

  @override
  String get numDatePreviewNumberTitle => 'Elegir un número de vista previa';

  @override
  String get numDatePreviewNumberSubtitle =>
      'Este valor solo se usa para una conversión rápida.';

  @override
  String get numDatePreviewNumberLabel => 'Número de vista previa';

  @override
  String get numDatePositiveInteger =>
      'Introduce un número entero positivo para empezar.';

  @override
  String get numDateTraining => 'Práctica';

  @override
  String get numDateTrainingNumberSubtitle =>
      'Elige otro número para practicar escribiéndolo en italiano.';

  @override
  String get numDateTrainingNumberLabel => 'Número de práctica';

  @override
  String get numDateAnswerInWords => 'Tu respuesta en letras';

  @override
  String get numDateCheck => 'Comprobar';

  @override
  String get numDateClear => 'Borrar';

  @override
  String get numDatePreviewDateTitle => 'Elegir una fecha de vista previa';

  @override
  String get numDatePreviewDateSubtitle =>
      'Esta fecha solo se usa como referencia rápida.';

  @override
  String get numDateToday => 'Hoy';

  @override
  String get numDateTrainingDateSubtitle =>
      'Elige otra fecha para practicar escribiéndola en italiano.';

  @override
  String numDateExpectedDay(String day) {
    return 'Día esperado: $day';
  }

  @override
  String get numDatePreviewTimeTitle => 'Elegir una hora de vista previa';

  @override
  String get numDatePreviewTimeSubtitle =>
      'Esta hora solo se usa como referencia rápida.';

  @override
  String get numDateTrainingTimeSubtitle =>
      'Elige otra hora para practicar, especialmente los cuartos de hora.';

  @override
  String get numDateDefinedTime => 'Hora definida:';

  @override
  String get answerCorrect => 'Respuesta correcta.';

  @override
  String get answerIncorrect => 'Respuesta incorrecta.';

  @override
  String answerYourAnswer(String answer) {
    return 'Tu respuesta: $answer';
  }

  @override
  String answerExpected(String answer) {
    return 'Respuesta correcta: $answer';
  }

  @override
  String get conjugationTitle => 'Conjugación';

  @override
  String get conjugationRegular => 'Regulares';

  @override
  String get conjugationSemiRegular => 'Semi-regulares';

  @override
  String get conjugationIrregular => 'Irregulares';

  @override
  String get conjugationPronominal => 'Pronominales';

  @override
  String conjugationGroup(Object group) {
    return 'Grupo $group';
  }

  @override
  String conjugationAuxiliary(Object auxiliary) {
    return 'Auxiliar $auxiliary';
  }

  @override
  String get conjugationShowAnswers => 'Mostrar';

  @override
  String get conjugationHideAnswers => 'Ocultar';

  @override
  String get conjugationNonPronominal => 'No pronominales';

  @override
  String get conjugationDetailsVisibility =>
      'Mostrar características del verbo';

  @override
  String get conjugationClearFilters => 'Borrar todos los filtros';

  @override
  String get conjugationChooseVerb => 'Elige un verbo';

  @override
  String get conjugationRandomVerb => 'Verbo aleatorio';

  @override
  String get conjugationHideBaseVerb => 'Ocultar verbo base';

  @override
  String get conjugationChooseMood => 'Elige un modo';

  @override
  String get conjugationChooseTense => 'Elige un tiempo verbal';

  @override
  String conjugationVerb(String verb) {
    return 'Verbo: $verb';
  }

  @override
  String conjugationTranslation(String translation) {
    return 'Traducción: $translation';
  }

  @override
  String conjugationMood(String mood) {
    return 'Modo: $mood';
  }

  @override
  String conjugationTense(String tense) {
    return 'Tiempo: $tense';
  }

  @override
  String conjugationLoadingError(String error) {
    return 'Error de carga: $error';
  }

  @override
  String get profileLanguage => 'Idioma de la interfaz';

  @override
  String get profileUserName => 'Nombre de usuario';

  @override
  String get profileAbout => 'Acerca de la aplicación';

  @override
  String get profileAboutDescription => 'Parlami te ayuda a aprender italiano.';

  @override
  String get profileTheme => 'Tema';

  @override
  String get profileThemeDescription => 'Cambiar entre modo claro y oscuro';

  @override
  String get themeSystem => 'Tema del sistema';

  @override
  String get themeLight => 'Tema claro';

  @override
  String get themeDark => 'Tema oscuro';

  @override
  String get vocabTitle => 'Vocabulario';

  @override
  String get vocabReview => 'Repasar';

  @override
  String get vocabCatalog => 'Catálogo';

  @override
  String get vocabAdd => 'Añadir';

  @override
  String get vocabImport => 'Importar palabras';

  @override
  String get vocabExport => 'Exportar mis palabras';

  @override
  String get vocabResetCatalog => 'Restablecer catálogo original';

  @override
  String get vocabSelect => 'Seleccionar';

  @override
  String get vocabSave => 'Guardar palabra';

  @override
  String get vocabChooseCategories => 'Elegir las categorías de la palabra';

  @override
  String get vocabPasteJson =>
      'Pega una lista JSON de palabras. Formato aceptado:';

  @override
  String get vocabCancel => 'Cancelar';

  @override
  String vocabImportError(String error) {
    return 'Error de importación: $error';
  }

  @override
  String get vocabResetQuestion => '¿Restablecer palabras originales?';

  @override
  String get vocabResetDescription =>
      'Esto reinicia las palabras importadas y vuelve a aplicar el catálogo original. Las palabras añadidas por el usuario se conservan.';

  @override
  String get vocabDeleteQuestion => '¿Eliminar esta palabra?';

  @override
  String vocabDeleteDescription(String word) {
    return '¿Eliminar \"$word\" del catálogo?';
  }

  @override
  String get vocabDelete => 'Eliminar';

  @override
  String get vocabNoCategory => 'Ninguna categoría seleccionada';

  @override
  String get vocabLoading => 'Cargando vocabulario...';

  @override
  String get vocabFields => 'Campos léxicos';

  @override
  String get vocabNoMatch =>
      'Ninguna palabra coincide con los filtros actuales.';

  @override
  String get vocabNoTrainingMatch =>
      'Ninguna palabra coincide con los filtros de práctica.';

  @override
  String get vocabTrainingWord => 'Palabra de práctica';

  @override
  String vocabScore(String score) {
    return 'Puntuación $score %';
  }

  @override
  String vocabBaseLanguage(String language) {
    return 'Idioma base: $language';
  }

  @override
  String get vocabHiddenAnswer => 'Respuesta oculta.';

  @override
  String get vocabKnown => 'Conocida';

  @override
  String get vocabUnknown => 'Desconocida';

  @override
  String get vocabNextWord => 'Siguiente palabra';

  @override
  String vocabCategories(String categories) {
    return 'Categorías: $categories';
  }

  @override
  String get vocabPreparing => 'Preparando palabras de práctica...';

  @override
  String get vocabPriority => 'Priorizar palabras no dominadas';

  @override
  String get vocabPriorityDescription =>
      'Desactivar para mezclar aleatoriamente.';

  @override
  String vocabSelectedCount(String count) {
    return 'Palabras seleccionadas: $count';
  }

  @override
  String get vocabClearAll => 'Borrar todo';

  @override
  String get vocabConfirm => 'Confirmar';

  @override
  String get conjugationCheck => 'Comprobar';

  @override
  String get conjugationNextVerb => 'Siguiente verbo';

  @override
  String get eeNextSentence => 'Siguiente frase';

  @override
  String get eeNoSentence => 'No hay frases disponibles';

  @override
  String ceLevel(String level) {
    return 'Nivel: $level';
  }

  @override
  String get sampleItems => 'Elementos de ejemplo';

  @override
  String get sampleItemDetails => 'Detalles del elemento';

  @override
  String get sampleMoreInformation => 'Más información aquí';

  @override
  String sampleItem(String id) {
    return 'Elemento de ejemplo $id';
  }

  @override
  String get evaluateScenarioOral => 'CO + EO';

  @override
  String get evaluateScenarioWritten => 'CE + EE';

  @override
  String get evaluateScenarioCulture => 'EO + Cultura';

  @override
  String get evaluateScenarioSpeed => 'CO + EO + Velocidad';

  @override
  String get conjugationAnswerLabel => 'Tu respuesta';

  @override
  String get vocabWords => 'Palabras';

  @override
  String get vocabAverageMastery => 'Dominio medio';

  @override
  String get vocabMode => 'Modo';

  @override
  String get vocabMastery => 'Dominio';

  @override
  String get vocabRandom => 'Aleatorio';

  @override
  String get vocabSearchWord => 'Buscar una palabra';

  @override
  String get vocabBaseLanguageDisplay => 'Idioma base de visualización';

  @override
  String get vocabDifficulty => 'Dificultad';

  @override
  String get vocabPartOfSpeech => 'Categoría gramatical';

  @override
  String get vocabChooseFilterCategories => 'Elegir categorías de filtro';

  @override
  String get vocabSearchTrainingWord => 'Buscar una palabra';

  @override
  String get vocabTrainingBaseLanguage => 'Idioma base de práctica';

  @override
  String get vocabFilters => 'Filtros';

  @override
  String get vocabChooseTrainingCategories => 'Elegir categorías de práctica';

  @override
  String get vocabItalianWord => 'Palabra italiana';

  @override
  String get vocabFrenchTranslation => 'Traducción (idioma base)';

  @override
  String get vocabOptionalArticle => 'Artículo opcional (il, la, l\', etc.)';

  @override
  String get vocabCategoriesTitle => 'Categorías';

  @override
  String get vocabSearchCategory => 'Buscar una categoría';

  @override
  String vocabAddCategory(String category) {
    return 'Añadir \"$category\"';
  }

  @override
  String get vocabDeleteFromCatalog => 'Eliminar del catálogo';

  @override
  String get vocabHideAnswer => 'Ocultar respuesta';

  @override
  String get vocabShowAnswer => 'Mostrar respuesta';

  @override
  String get vocabStatusSaved =>
      'Palabra guardada y disponible en los filtros.';

  @override
  String vocabStatusImport(String count) {
    return 'Importación completada: $count palabra(s) añadida(s).';
  }

  @override
  String vocabStatusExport(String location) {
    return 'Exportación completada: $location';
  }

  @override
  String get vocabStatusNoExport => 'No hay palabras de usuario para exportar.';

  @override
  String get vocabStatusReset => 'Catálogo original restablecido.';

  @override
  String get vocabStatusDeleted => 'Palabra eliminada del catálogo.';

  @override
  String get vocabStatusKnown => 'Anotado.';

  @override
  String get vocabStatusReview => 'Repasar pronto.';

  @override
  String get vocabItalian => 'Italiano';

  @override
  String get vocabFrench => 'Francés';

  @override
  String get vocabSourceOriginal => 'Original';

  @override
  String get vocabSourceUser => 'Usuario';

  @override
  String get vocabNoun => 'Sustantivo';

  @override
  String get vocabVerb => 'Verbo';

  @override
  String get vocabAdjective => 'Adjetivo';

  @override
  String get vocabAdverb => 'Adverbio';

  @override
  String get vocabPronoun => 'Pronombre';

  @override
  String get vocabDeterminer => 'Determinante';

  @override
  String get vocabPreposition => 'Preposición';

  @override
  String get vocabConjunction => 'Conjunción';

  @override
  String get vocabInterjection => 'Interjección';

  @override
  String get vocabExpression => 'Expresión';

  @override
  String get vocabOther => 'Otro';

  @override
  String get profileDonate => 'Hacer una donación';

  @override
  String get profileDonateDescription => 'Gracias por tu apoyo';

  @override
  String get profilePrivacy => 'Política de privacidad';

  @override
  String get profilePrivacyDescription => 'Abrir la política de privacidad';

  @override
  String get unavailable => 'Función aún no disponible.';
}
