import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:virtual_card/db/db_helper.dart';
import 'package:virtual_card/models/contact_model.dart';

part 'favorite_provider.g.dart';

@Riverpod(keepAlive: true)
class Favorite extends _$Favorite {
  final db = DbHelper();

  @override
  List<ContactModel> build() {
    return [];
  }

  Future<void> getFavoriteContacts() async {
    final contacts = await db.getFavoriteContacts();
    state = contacts;
  }

  Future<void> toggleFavorite(ContactModel contact) async {
    contact.favorite = !contact.favorite;
    final rowsAffected = await db.updateContact(contact);
    if (rowsAffected > 0) {
      if (contact.favorite) {
        state = [...state, contact];
      } else {
        state = state.where((c) => c.id != contact.id).toList();
      }
    }
  }

}
