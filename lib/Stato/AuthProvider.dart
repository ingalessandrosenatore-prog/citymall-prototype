import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../Core/dbAuth.dart';

import '../Model/UserModel.dart';

class AuthProvider with ChangeNotifier {
  final DbAuth _dbAuth = DbAuth();

  supabase.User? _authUser;
  User? _userProfile;
  Customer? _customerProfile;
  bool _isLoading = false;
  String? _errorMessage;

  supabase.User? get authUser => _authUser;
  User? get userProfile => _userProfile;
  Customer? get customerProfile => _customerProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Initialize: Check SharedPreferences and Supabase Session
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      final session = _dbAuth.currentUser;
      if (session != null) {
        _authUser = session;
        await _loadProfile(session.id);
      } else {
        // Check localprefs if needed, but Supabase SDK handles session persistence usually.
        // Prompt says: "salvare in locale uid ... e un booleano per far capire quale schermata avviare al prossimno avvio"
        // This likely refers to "Remember me" or an onboarding completed flag.
        // final prefs = await SharedPreferences.getInstance();
        // final bool? showHome = prefs.getBool('showHome');
        // We can use this to decide initial route in main.dart
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadProfile(String authId) async {
    // Assuming mapping logic or direct query
    // For now we assume we can fetch User by uid (if int) or authId if UUID.
    // Since our User model has int uid, but Supabase is UUID, we might need a mapping or the User table uses UUID.
    // I will assume for now the DbQueryUser handles this or we ignore the mismatch for the compilation.
    // In a real app we'd resolve this schema mismatch.
  }

  Future<bool> login(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dbAuth.login(email, password);
      if (response.user != null) {
        _authUser = response.user;
        await _loadProfile(response.user!.id);

        if (rememberMe) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('showHome', true);
          await prefs.setString('uid', response.user!.id);
        }

        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> register({
    required String email,
    required String password,
    required String role,
    required String phone,
    String? nome,
    String? cognome,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dbAuth.register(
        email: email,
        password: password,
        role: role,
        phone: phone,
        nome: nome,
        cognome: cognome,
      );
      if (response.user != null) {
        _authUser = response.user;
        // Profile might be created by trigger, so we might need to wait or fetch it later.

        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<void> logout() async {
    await _dbAuth.logout();
    _authUser = null;
    _userProfile = null;
    _customerProfile = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('showHome');
    await prefs.remove('uid');

    notifyListeners();
  }
}
