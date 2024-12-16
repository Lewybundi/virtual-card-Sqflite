// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_card/models/contact_model.dart';
import 'package:virtual_card/pages/home_page.dart';
import 'package:virtual_card/providers/contact_provider.dart';
import 'package:virtual_card/utils/constants.dart';
import 'package:virtual_card/utils/helper_functions.dart';

class FormPage extends ConsumerStatefulWidget {
  static const String routeName ='form';
  final ContactModel contactModel;
  const FormPage({super.key,required this.contactModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FormPageState();
}

class _FormPageState extends ConsumerState<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final mobileController = TextEditingController();
  final desgnationController = TextEditingController();
  final emailController = TextEditingController();
  final companyController = TextEditingController();
  final websiteController = TextEditingController();

  @override
  void initState() {
    nameController.text =widget.contactModel.name;
    emailController.text =widget.contactModel.email;
    mobileController.text =widget.contactModel.mobile;
    addressController.text =widget.contactModel.address;
    companyController.text =widget.contactModel.company;
    websiteController.text =widget.contactModel.website;
    desgnationController.text =widget.contactModel.desgnation;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Form Page'),
        actions: [
          IconButton.filled(
            onPressed: saveContact,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: nameController,
              decoration:  const InputDecoration(
                labelText: 'Name'
              ),
              validator: (value){
                if (value==null || value.isEmpty) {
                  return emptyFieldErrMsg;
                }
                return null;
              }
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: mobileController,
              decoration:  const InputDecoration(
                labelText: 'Mobile'
              ),
              validator: (value){
                if (value==null || value.isEmpty) {
                  return emptyFieldErrMsg;
                }
                return null;
              }
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration:  const InputDecoration(
                labelText: 'Email'
              ),
              validator: (value){
                return null;
              }
            ),
            TextFormField(
              controller: addressController,
              decoration:  const InputDecoration(
                labelText: 'Address'
              ),
              validator: (value){
                return null;
              }
            ),
            TextFormField(
              controller: companyController,
              decoration:  const InputDecoration(
                labelText: 'Company'
              ),
              validator: (value){
                return null;
              }
            ),
            TextFormField(
              controller: desgnationController,
              decoration:  const InputDecoration(
                labelText: 'Desgnation'
              ),
              validator: (value){
                return null;
              }
            ),
            TextFormField(
              controller: websiteController,
              decoration:  const InputDecoration(
                labelText: 'Website'
              ),
              validator: (value){
                return null;
              }
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    websiteController.dispose();
    desgnationController.dispose();
    mobileController.dispose();
    companyController.dispose();
    super.dispose();
  }

  void saveContact() async {
    try {
      if (_formKey.currentState!.validate()) {
        widget.contactModel.name = nameController.text;
        widget.contactModel.mobile = mobileController.text;
        widget.contactModel.email = emailController.text;
        widget.contactModel.website = websiteController.text;
        widget.contactModel.company = companyController.text;
        widget.contactModel.desgnation = desgnationController.text;
        widget.contactModel.address = addressController.text;
        
        await ref.read(contactProvider.notifier).insertContact(widget.contactModel);
        showMsg(context, 'Contact saved successfully');
        if (mounted) {
          context.goNamed(HomePage.routeName);
        }
      }
    } catch (error) {
      showMsg(context, 'Failed to save contact: $error');
    }
  }
}