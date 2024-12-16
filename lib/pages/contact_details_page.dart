// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:virtual_card/models/contact_model.dart';
import 'package:virtual_card/providers/contact_provider.dart';
import 'package:virtual_card/utils/helper_functions.dart';

class ContactDetailsPage extends ConsumerStatefulWidget {
  static const String routeName = 'details';
  final int id;
  const ContactDetailsPage({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ContactDetailsPageState();
}

class _ContactDetailsPageState extends ConsumerState<ContactDetailsPage> {
  late int id;
  @override
  void initState() {
    id = widget.id;
    print(id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Consumer(
        builder: (context, WidgetRef ref, child) => FutureBuilder<ContactModel>(
            future: ref.read(contactProvider.notifier).getContactById(id),
            builder: (c, snapshot) {
              if (snapshot.hasData) {
                final contact = snapshot.data!;
                return ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    Image.file(
                      File(contact.image),
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                    ListTile(
                      title: Text(contact.mobile),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                callContact(contact.mobile);
                              },
                              icon: const Icon(Icons.call)),
                          IconButton(
                            onPressed: () {
                              smsContact(contact.mobile);
                            },
                            icon: const Icon(Icons.sms),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Text(contact.email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              emlContact(contact.email);
                            },
                            icon: const Icon(Icons.email),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Text(contact.address),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              adressContact(contact.address);
                            },
                            icon: const Icon(Icons.map),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Text(contact.website),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              webContact(contact.website);
                            },
                            icon: const Icon(Icons.web),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Failed to load data'),
                );
              }
              return const Center(
                child: Text('Please wait....'),
              );
            }),
      ),
    );
  }

  void smsContact(String mobile) async {
    final url = 'sms:$mobile';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Cannot perform this task');
    }
  }

  void callContact(String mobile) async {
    final url = 'tel:$mobile';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Cannot perform this task');
    }
  }

  void emlContact(String email) async {
    print('Attempting to launch email: $email');
    final url = 'mailto:$email';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Cannot perform this task');
    }
  }

  void adressContact(String address) async {
    String url = '';
    if (Platform.isAndroid) {
      url = 'geo:0,0?q=$address';
    } else {
      url = 'https://maps.apple.com/?q=$address';
    }
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }else {
      showMsg(context, 'Cannot perform this task');
    }
  }

  void webContact(String website) async {
    final url = 'https://$website';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Cannot perform this task');
    }
  }
}
