// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Parlami';

  @override
  String get navLearn => 'Aprender';

  @override
  String get navTrain => 'Praticar';

  @override
  String get navEvaluate => 'Testar';

  @override
  String get navResults => 'Resultados';

  @override
  String get navProfile => 'Perfil';

  @override
  String get learnConjugation => 'Conjugação';

  @override
  String get learnConjugationDescription => 'Praticar conjugação de verbos';

  @override
  String get learnVocabulary => 'Vocabulário';

  @override
  String get learnVocabularyDescription => 'Por tema e nível';

  @override
  String get learnNumbersDates => 'Números e Datas';

  @override
  String get learnNumbersDatesDescription => 'Escrever números e datas';

  @override
  String get learnGrammar => 'Gramática';

  @override
  String get learnGrammarDescription => 'Notas do curso';

  @override
  String get learnSpelling => 'Ortografia';

  @override
  String get learnSpellingDescription => 'Em breve';

  @override
  String get trainOralExpression => 'EO - Expressão oral';

  @override
  String get trainOralExpressionDescription => 'Responder em voz alta';

  @override
  String get trainOralComprehension => 'CO - Compreensão oral';

  @override
  String get trainOralComprehensionDescription => 'Ouvir estações de rádio';

  @override
  String get trainWrittenComprehension => 'CE - Compreensão escrita';

  @override
  String get trainWrittenComprehensionDescription => 'Ler notícias italianas';

  @override
  String get trainWrittenExpression => 'EE - Expressão escrita';

  @override
  String get trainWrittenExpressionDescription => 'Traduzir frases';

  @override
  String get evaluateTitle => 'Teste-se - Situações reais';

  @override
  String get evaluateIntro =>
      'Combine várias habilidades ao mesmo tempo para simular situações da vida real.';

  @override
  String get evaluateProgression =>
      'Aprender constrói as bases. Praticar foca em habilidades específicas. Testar mede seu domínio geral.';

  @override
  String get scenarioDailyConversation => 'Conversa diária';

  @override
  String get scenarioArticleSummary => 'Resumo de artigo';

  @override
  String get scenarioMatchDebrief => 'Análise da partida';

  @override
  String get scenarioQuickDiscussion => 'Discussão rápida';

  @override
  String get scenarioDailyConversationDetails =>
      'Ouça, entenda e responda naturalmente.';

  @override
  String get scenarioArticleSummaryDetails =>
      'Leia um texto e produza um resumo claro e estruturado.';

  @override
  String get scenarioMatchDebriefDetails =>
      'Fale sobre uma partida usando vocabulário e referências culturais.';

  @override
  String get scenarioQuickDiscussionDetails =>
      'Reaja rapidamente em uma troca dinâmica com limite de tempo.';

  @override
  String get resultsComingSoon => 'Gráficos de desempenho em breve';

  @override
  String get grammarTitle => 'Gramática';

  @override
  String get grammarComingSoon =>
      'Notas de gramática - conteúdo em breve.\n\nAdicione notas a este módulo como páginas ou Markdown renderizado.';

  @override
  String get spellingTitle => 'Ortografia';

  @override
  String get spellingComingSoon => 'Módulo de ortografia - em breve.';

  @override
  String get ceTitle => 'CE - Compreensão escrita';

  @override
  String get ceIntro =>
      'Leia artigos em italiano para melhorar sua compreensão escrita';

  @override
  String get ceAdviceTitle => 'Conselho';

  @override
  String get ceAdvice =>
      'Comece com artigos curtos. Leia primeiro para o sentido geral, depois leia novamente para os detalhes.';

  @override
  String get ceOpenSource => 'Abrir site de origem';

  @override
  String get eeTitle => 'EE - Expressão escrita';

  @override
  String get eePrompt => 'Traduza a seguinte frase para o italiano';

  @override
  String get eeTranslationLabel => 'Sua tradução para o italiano';

  @override
  String get eeTranslationHint => 'Escreva sua tradução aqui...';

  @override
  String get eeCheck => 'Verificar';

  @override
  String get eeCorrection => 'Correção';

  @override
  String get eeYourAnswer => 'Sua resposta';

  @override
  String get coTitle => 'CO - Compreensão oral';

  @override
  String get coIntro =>
      'Ouça rádios italianas para melhorar sua compreensão oral';

  @override
  String get coLive => 'Ao vivo:';

  @override
  String coStopped(Object station) {
    return '$station parada';
  }

  @override
  String coConnecting(Object station) {
    return 'Conectando a $station...';
  }

  @override
  String get coPlay => 'Tocar';

  @override
  String get coStop => 'Parar';

  @override
  String get eoTitle => 'EO - Expressão oral';

  @override
  String get eoChooseLevel => 'Escolha o nível';

  @override
  String eoLevel(String level) {
    return 'Nível $level';
  }

  @override
  String get eoNoQuestion => 'Nenhuma pergunta disponível';

  @override
  String get eoQuestion => 'Pergunta';

  @override
  String get eoHint => 'Dica';

  @override
  String get eoClickHint => 'Clique para uma dica';

  @override
  String get eoAnswerHint => 'Pista da resposta';

  @override
  String get eoClickAnswerHint => 'Clique para uma pista da resposta';

  @override
  String get eoTimer => 'Cronômetro';

  @override
  String get eoTotal => 'Total';

  @override
  String get eoSpeech => 'Falar';

  @override
  String get eoHesitation => 'Hesitação';

  @override
  String get eoStart => 'Começar';

  @override
  String get eoStop => 'Parar';

  @override
  String get eoReset => 'Reiniciar';

  @override
  String get eoModeFree => 'Modo livre';

  @override
  String get eoModeFreeDescription => 'Avance quando quiser, sem ajuda.';

  @override
  String get eoModeEasy => 'Fácil';

  @override
  String get eoModeEasyDescription =>
      'Responda, autoavalie-se e veja uma pista.';

  @override
  String get eoModeHard => 'Difícil';

  @override
  String get eoModeHardDescription =>
      'Cronômetro, rastreamento de hesitação e autoavaliação.';

  @override
  String eoLevelChip(Object level) {
    return 'Nível $level';
  }

  @override
  String get eoSelfEvaluation => 'Autoavaliação';

  @override
  String get eoExcellent => 'Excelente';

  @override
  String get eoGood => 'Bom';

  @override
  String get eoAverage => 'Médio';

  @override
  String get eoDifficult => 'Difícil';

  @override
  String get eoNextQuestion => 'Próxima pergunta';

  @override
  String get numDateTitle => 'Números e Datas';

  @override
  String get numDateNumbersTab => 'Números';

  @override
  String get numDateDatesTab => 'Datas';

  @override
  String get numDateTimeTab => 'Hora';

  @override
  String get numDatePreviewNumberTitle => 'Escolha um número de visualização';

  @override
  String get numDatePreviewNumberSubtitle =>
      'Este valor é usado apenas para conversão rápida.';

  @override
  String get numDatePreviewNumberLabel => 'Número de visualização';

  @override
  String get numDatePositiveInteger =>
      'Insira um número inteiro positivo para começar.';

  @override
  String get numDateTraining => 'Prática';

  @override
  String get numDateTrainingNumberSubtitle =>
      'Escolha outro número para praticar escrevê-lo em italiano.';

  @override
  String get numDateTrainingNumberLabel => 'Número de prática';

  @override
  String get numDateAnswerInWords => 'Sua resposta por extenso';

  @override
  String get numDateCheck => 'Verificar';

  @override
  String get numDateClear => 'Limpar';

  @override
  String get numDatePreviewDateTitle => 'Escolha uma data de visualização';

  @override
  String get numDatePreviewDateSubtitle =>
      'Esta data é usada apenas como referência rápida.';

  @override
  String get numDateToday => 'Hoje';

  @override
  String get numDateTrainingDateSubtitle =>
      'Escolha outra data para praticar escrevê-la em italiano.';

  @override
  String numDateExpectedDay(String day) {
    return 'Dia esperado: $day';
  }

  @override
  String get numDatePreviewTimeTitle => 'Escolha um horário de visualização';

  @override
  String get numDatePreviewTimeSubtitle =>
      'Este horário é usado apenas para leitura rápida.';

  @override
  String get numDateTrainingTimeSubtitle =>
      'Escolha outro horário para praticar, especialmente os quartos de hora.';

  @override
  String get numDateDefinedTime => 'Horário definido:';

  @override
  String get answerCorrect => 'Resposta correta.';

  @override
  String get answerIncorrect => 'Resposta incorreta.';

  @override
  String answerYourAnswer(String answer) {
    return 'Sua resposta: $answer';
  }

  @override
  String answerExpected(String answer) {
    return 'Resposta correta: $answer';
  }

  @override
  String get conjugationTitle => 'Conjugação';

  @override
  String get conjugationRegular => 'Regulares';

  @override
  String get conjugationSemiRegular => 'Semirregulares';

  @override
  String get conjugationIrregular => 'Irregulares';

  @override
  String get conjugationClearFilters => 'Limpar todos os filtros';

  @override
  String get conjugationChooseVerb => 'Escolha um verbo';

  @override
  String get conjugationRandomVerb => 'Verbo aleatório';

  @override
  String get conjugationHideBaseVerb => 'Ocultar verbo base';

  @override
  String get conjugationChooseMood => 'Escolha um modo';

  @override
  String get conjugationChooseTense => 'Escolha um tempo verbal';

  @override
  String conjugationVerb(String verb) {
    return 'Verbo: $verb';
  }

  @override
  String conjugationTranslation(String translation) {
    return 'Tradução: $translation';
  }

  @override
  String conjugationMood(String mood) {
    return 'Modo: $mood';
  }

  @override
  String conjugationTense(String tense) {
    return 'Tempo: $tense';
  }

  @override
  String conjugationLoadingError(String error) {
    return 'Erro de carregamento: $error';
  }

  @override
  String get profileLanguage => 'Idioma da interface';

  @override
  String get profileUserName => 'Nome de usuário';

  @override
  String get profileAbout => 'Sobre o aplicativo';

  @override
  String get profileAboutDescription =>
      'Parlami ajuda você a aprender italiano.';

  @override
  String get profileTheme => 'Tema';

  @override
  String get profileThemeDescription => 'Alternar entre modo claro e escuro';

  @override
  String get themeSystem => 'Tema do sistema';

  @override
  String get themeLight => 'Tema claro';

  @override
  String get themeDark => 'Tema escuro';

  @override
  String get vocabTitle => 'Vocabulário';

  @override
  String get vocabReview => 'Revisar';

  @override
  String get vocabCatalog => 'Catálogo';

  @override
  String get vocabAdd => 'Adicionar';

  @override
  String get vocabImport => 'Importar palavras';

  @override
  String get vocabExport => 'Exportar minhas palavras';

  @override
  String get vocabResetCatalog => 'Restaurar catálogo original';

  @override
  String get vocabSelect => 'Selecionar';

  @override
  String get vocabSave => 'Salvar palavra';

  @override
  String get vocabChooseCategories => 'Escolher categorias';

  @override
  String get vocabPasteJson =>
      'Cole uma lista JSON de palavras. Formato aceito:';

  @override
  String get vocabCancel => 'Cancelar';

  @override
  String vocabImportError(String error) {
    return 'Falha na importação: $error';
  }

  @override
  String get vocabResetQuestion => 'Restaurar palavras originais?';

  @override
  String get vocabResetDescription =>
      'Isso redefine as palavras importadas e reaplica o catálogo original. As palavras adicionadas pelo usuário são mantidas.';

  @override
  String get vocabDeleteQuestion => 'Excluir esta palavra?';

  @override
  String vocabDeleteDescription(String word) {
    return 'Excluir \"$word\" do catálogo?';
  }

  @override
  String get vocabDelete => 'Excluir';

  @override
  String get vocabNoCategory => 'Nenhuma categoria selecionada';

  @override
  String get vocabLoading => 'Carregando vocabulário...';

  @override
  String get vocabFields => 'Campos lexicais';

  @override
  String get vocabNoMatch => 'Nenhuma palavra corresponde aos filtros atuais.';

  @override
  String get vocabNoTrainingMatch =>
      'Nenhuma palavra corresponde aos filtros de prática.';

  @override
  String get vocabTrainingWord => 'Palavra de prática';

  @override
  String vocabScore(String score) {
    return 'Pontuação $score%';
  }

  @override
  String vocabBaseLanguage(String language) {
    return 'Idioma base: $language';
  }

  @override
  String get vocabHiddenAnswer => 'Resposta oculta.';

  @override
  String get vocabKnown => 'Conhecida';

  @override
  String get vocabUnknown => 'Desconhecida';

  @override
  String get vocabNextWord => 'Próxima palavra';

  @override
  String vocabCategories(String categories) {
    return 'Categorias: $categories';
  }

  @override
  String get vocabPreparing => 'Preparando palavras de prática...';

  @override
  String get vocabPriority => 'Priorizar palavras não dominadas';

  @override
  String get vocabPriorityDescription =>
      'Desative para misturar aleatoriamente.';

  @override
  String vocabSelectedCount(String count) {
    return 'Palavras selecionadas: $count';
  }

  @override
  String get vocabClearAll => 'Limpar tudo';

  @override
  String get vocabConfirm => 'Confirmar';

  @override
  String get conjugationCheck => 'Verificar';

  @override
  String get conjugationNextVerb => 'Próximo verbo';

  @override
  String get eeNextSentence => 'Próxima frase';

  @override
  String get eeNoSentence => 'Nenhuma frase disponível';

  @override
  String ceLevel(String level) {
    return 'Nível: $level';
  }

  @override
  String get sampleItems => 'Itens de exemplo';

  @override
  String get sampleItemDetails => 'Detalhes do item';

  @override
  String get sampleMoreInformation => 'Mais informações aqui';

  @override
  String sampleItem(String id) {
    return 'Item de exemplo $id';
  }

  @override
  String get evaluateScenarioOral => 'CO + EO';

  @override
  String get evaluateScenarioWritten => 'CE + EE';

  @override
  String get evaluateScenarioCulture => 'EO + Cultura';

  @override
  String get evaluateScenarioSpeed => 'CO + EO + Velocidade';

  @override
  String get conjugationAnswerLabel => 'Sua resposta';

  @override
  String get vocabWords => 'Palavras';

  @override
  String get vocabAverageMastery => 'Domínio médio';

  @override
  String get vocabMode => 'Modo';

  @override
  String get vocabMastery => 'Domínio';

  @override
  String get vocabRandom => 'Aleatório';

  @override
  String get vocabSearchWord => 'Pesquisar uma palavra';

  @override
  String get vocabBaseLanguageDisplay => 'Exibir idioma base';

  @override
  String get vocabDifficulty => 'Dificuldade';

  @override
  String get vocabPartOfSpeech => 'Classe gramatical';

  @override
  String get vocabChooseFilterCategories => 'Escolher categorias de filtro';

  @override
  String get vocabSearchTrainingWord => 'Pesquisar uma palavra';

  @override
  String get vocabTrainingBaseLanguage => 'Idioma base de prática';

  @override
  String get vocabFilters => 'Filtros';

  @override
  String get vocabChooseTrainingCategories => 'Escolher categorias de prática';

  @override
  String get vocabItalianWord => 'Palavra italiana';

  @override
  String get vocabFrenchTranslation => 'Tradução (idioma base)';

  @override
  String get vocabOptionalArticle => 'Artigo opcional (il, la, l\', etc.)';

  @override
  String get vocabCategoriesTitle => 'Categorias';

  @override
  String get vocabSearchCategory => 'Pesquisar uma categoria';

  @override
  String vocabAddCategory(String category) {
    return 'Adicionar \"$category\"';
  }

  @override
  String get vocabDeleteFromCatalog => 'Excluir do catálogo';

  @override
  String get vocabHideAnswer => 'Ocultar resposta';

  @override
  String get vocabShowAnswer => 'Mostrar resposta';

  @override
  String get vocabStatusSaved => 'Palavra salva e disponível nos filtros.';

  @override
  String vocabStatusImport(String count) {
    return 'Importação concluída: $count palavra(s) adicionada(s).';
  }

  @override
  String vocabStatusExport(String location) {
    return 'Exportação concluída: $location';
  }

  @override
  String get vocabStatusNoExport => 'Nenhuma palavra de usuário para exportar.';

  @override
  String get vocabStatusReset => 'Catálogo original restaurado.';

  @override
  String get vocabStatusDeleted => 'Palavra removida do catálogo.';

  @override
  String get vocabStatusKnown => 'Anotado.';

  @override
  String get vocabStatusReview => 'Revisar em breve.';

  @override
  String get vocabItalian => 'Italiano';

  @override
  String get vocabFrench => 'Francês';

  @override
  String get vocabSourceOriginal => 'Original';

  @override
  String get vocabSourceUser => 'Usuário';

  @override
  String get vocabNoun => 'Substantivo';

  @override
  String get vocabVerb => 'Verbo';

  @override
  String get vocabAdjective => 'Adjetivo';

  @override
  String get vocabAdverb => 'Advérbio';

  @override
  String get vocabPronoun => 'Pronome';

  @override
  String get vocabDeterminer => 'Determinante';

  @override
  String get vocabPreposition => 'Preposição';

  @override
  String get vocabConjunction => 'Conjunção';

  @override
  String get vocabInterjection => 'Interjeição';

  @override
  String get vocabExpression => 'Expressão';

  @override
  String get vocabOther => 'Outro';

  @override
  String get profileDonate => 'Fazer uma doação';

  @override
  String get profileDonateDescription => 'Obrigado pelo seu apoio';

  @override
  String get profilePrivacy => 'Política de privacidade';

  @override
  String get profilePrivacyDescription => 'Abrir a política de privacidade';

  @override
  String get unavailable => 'Recurso ainda não disponível.';
}
