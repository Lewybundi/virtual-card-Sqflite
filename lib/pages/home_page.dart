// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_card/pages/contact_details_page.dart';
import 'package:virtual_card/pages/scan_page.dart';
import 'package:virtual_card/providers/barnav_riv.dart';
import 'package:virtual_card/providers/contact_provider.dart';
import 'package:virtual_card/utils/helper_functions.dart';

// final indexBottomNavbarProvider = StateProvider<int>((ref) {
//  // ref.keepAlive();
//   return 0;
// });

class HomePage extends ConsumerStatefulWidget {
  static const String routeName = '/';
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final indexBottomNavbar = ref.watch(bottomNavProvider);
    final contacts = ref.watch(contactProvider);

    // Refresh data when tab changes
    ref.listen(bottomNavProvider, (previous, next) {
      if (previous != next) {
        _fetchData();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact List"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(ScanPage.routeName);
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        shape: CircularNotchedRectangle(),
        notchMargin: 6.h,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
            backgroundColor: Colors.blue[100],
            onTap: (int value) {
              ref.read(bottomNavProvider.notifier).indexValue(value);
            },
            currentIndex: indexBottomNavbar,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Contacts'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: 'Favorites'),
            ],
            ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          if (contacts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.contact_phone_outlined,
                      size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No contacts yet',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap + to add a new contact',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: const EdgeInsets.only(right: 20),
                    alignment: FractionalOffset.centerRight,
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                  confirmDismiss: _showConfirmationDialog,
                  onDismissed: (_) async {
                    await ref
                        .read(contactProvider.notifier)
                        .deleteContact(contact.id);
                    showMsg(context, 'Deleted');
                  },
                  child: ListTile(
                    onTap: () => context.goNamed(ContactDetailsPage.routeName,extra: contact.id),
                    leading: CircleAvatar(
                      child: Text(contact.name[0].toUpperCase()),
                    ),
                    title: Text(contact.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (contact.mobile.isNotEmpty) Text(contact.mobile),
                        if (contact.email.isNotEmpty)
                          Text(
                            contact.email,
                            style: TextStyle(fontSize: 12),
                          ),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        ref
                            .read(contactProvider.notifier)
                            .toggleFavorite(contact);
                      },
                      icon: Icon(
                        contact.favorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: contact.favorite ? Colors.red : null,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<bool?> _showConfirmationDialog(DismissDirection direction) {
    return showDialog(
        context: context,
        builder: (c) => AlertDialog(
              title: const Text('Delete Contact'),
              content: const Text('Are you sure to delete this contact?'),
              actions: [
                OutlinedButton(
                    onPressed: () {
                      context.pop(false);
                    },
                    child: const Text('NO')),
                OutlinedButton(
                    onPressed: () {
                      context.pop(true);
                    },
                    child: const Text('YES')),
              ],
            ));
  }
  
  void _fetchData() {
    final selectedIndex = ref.read(bottomNavProvider);
    switch (selectedIndex) {
      case 0:
        ref.read(contactProvider.notifier).getAllContacts();
        break;
      case 1:
        ref.read(contactProvider.notifier).getAllFavoriteContacts();
        break;
    }
  }
}
