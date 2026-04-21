import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DbConfig {
  static final DbConfig _instance = DbConfig._internal();

  factory DbConfig() {
    return _instance;
  }

  DbConfig._internal();

  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
    
    final String? supabaseUrl = dotenv.env['SUPABASE_URL'];
    final String? supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (supabaseUrl == null || supabaseAnonKey == null) {
      throw Exception("Supabase credentials not found in .env file");
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
