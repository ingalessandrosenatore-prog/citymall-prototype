import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../Model/UserModel.dart';
import 'dbConfig.dart';

class DbQueryUser {
  final SupabaseClient _client = DbConfig.client;

  // Get User Profile from public.users (or equivalent view)
  Future<User?> getUserProfile(String uid) async {
    final response = await _client
        .from(
          'USERS',
        ) // Assuming 'USERS' is the public table as per mermaid, though usually lowercase in Supabase
        .select()
        .eq(
          'uid',
          uid,
        ) // Assuming mapping from Auth UID (UUID) to Int UID or handled by trigger/view.
        // Note: Mermaid says 'uid PK int'. Supabase Auth is UUID.
        // If there is a discrepancy, we might need to query by 'auth_id' if it exists, or assume the Trigger handles it.
        // For now, I'll assume we query by the ID we have.
        .maybeSingle();

    if (response == null) return null;
    return User.fromJson(response);
  }

  Future<Customer?> getCustomerProfile(int userId) async {
    final response = await _client
        .from('CUSTOMERS')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return Customer.fromJson(response);
  }

  Future<List<Address>> getCustomerAddresses(int customerId) async {
    final response = await _client
        .from('ADDRESS_CUSTOMERS')
        .select()
        .eq('customer_id', customerId);

    return (response as List).map((e) => Address.fromJson(e)).toList();
  }

  Future<void> addAddress(int customerId, Address address) async {
    await _client.from('ADDRESS_CUSTOMERS').insert({
      'customer_id': customerId,
      'regione': address.regione,
      'provincia': address.provincia,
      'via': address.via,
      'civico': address.civico,
      'cap': address.cap,
      'descrizione': address.descrizione,
      'lat': address.lat,
      'lng': address.lng,
    });
  }
}
