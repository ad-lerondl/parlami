/// Configuration Supabase injectee au moment de la compilation.
///
/// Lancer l'application avec :
/// `flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...`
///
/// Sans ces deux variables, l'application demarre en mode local sans ecran
/// de connexion (comportement identique aux versions precedentes).
const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

bool get isSupabaseConfigured => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
