/// Configuration Supabase de Parlami.
///
/// La cle `anon`/publishable est concue par Supabase pour etre embarquee dans
/// une application cliente : elle n'ouvre aucun acces sans les policies RLS
/// cote base. Les variables `--dart-define` restent disponibles pour pointer
/// vers un autre projet (tests, staging) sans modifier le code.
const String supabaseUrl = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: 'https://ipsjvcoguyrxeqebdvbs.supabase.co',
);

const String supabaseAnonKey = String.fromEnvironment(
  'SUPABASE_ANON_KEY',
  defaultValue: 'sb_publishable_jtSrxdusw1isMgjfgFTuag_ve7Oqy8I',
);
