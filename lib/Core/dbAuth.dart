import 'package:supabase_flutter/supabase_flutter.dart';
import 'dbConfig.dart';

class DbAuth {
  final SupabaseClient _client = DbConfig.client;

  // Login with Email and Password
  Future<AuthResponse> login(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Registration
  // The 'Routing' trigger in DB handles role assignment and entry in customers/merchants tables.
  // We just need to pass the metadata (role, phone, etc) if Supabase supports it,
  // OR the trigger acts purely on new row in `users`.
  // The prompt says: "Questi trigger scattano nel momento esatto della registrazione (AFTER INSERT sulla tabella users)"
  // But Supabase Auth usually creates a user in `auth.users`, not a public `users` table directly unless there is a trigger from `auth.users` -> `public.users`.
  // Assuming the standard Supabase pattern where we sign up via Auth, and a trigger populates public.users.
  // However, the prompt implies we might be inserting into a custom `users` table?
  // "USERS { int uid PK ... }" looks like a custom table.
  // BUT the prompt also says "tabella auth privata di supabase , tabella pubblica user".
  // So: SignUp -> Trigger on auth.users -> Insert into public.users -> Trigger on public.users -> Insert into customers/riders.

  Future<AuthResponse> register({
    required String email,
    required String password,
    required String role,
    required String phone,
    String?
    nome, // Generic name fields not in USERS table but maybe in metadata?
    String? cognome,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'role': role,
        'phone':
            phone, // Passing to metadata so trigger can pick it up if configured
        'full_name': '$nome $cognome',
      },
    );
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
