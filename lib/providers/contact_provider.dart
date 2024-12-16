import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:virtual_card/db/db_helper.dart';
import 'package:virtual_card/models/contact_model.dart';
part 'contact_provider.g.dart';

@Riverpod(keepAlive: true)
class Contact extends _$Contact {
  final db = DbHelper();

  @override
  List<ContactModel> build() {
    return [];
  }

  Future<void> getAllContacts() async {
    final contacts = await db.getAllContacts();
    state = contacts;
  }

  Future<ContactModel> getContactById(int id) {
    return db.getContactById(id);
  }

  Future<void> insertContact(ContactModel contactModel) async {
    final id = await db.insertContact(contactModel);
    if (id > 0) {
      contactModel.id = id;
      state = [...state, contactModel];
    }
  }

  Future<int> deleteContact(int id) {
    return db.deleteContact(id);
  }

  Future<void> toggleFavorite(ContactModel contact) async {
    contact.favorite = !contact.favorite;
    final rowsAffected = await db.updateContact(contact);
    if (rowsAffected > 0) {
      state = state.map((c) => c.id == contact.id ? contact : c).toList();
    }
  }

  Future<void> getAllFavoriteContacts() async {
    final contacts = await db.getAllFavoriteContacts();
    state = contacts;
  }
}
