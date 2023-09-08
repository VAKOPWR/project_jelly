import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:project_jelly/logic/permissions.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  Future<void> _getContacts() async {
    bool contactsPermission = await requestContactsPermission();

    if (contactsPermission) {
      final contacts = await ContactsService.getContacts();
      setState(() {
        _contacts = contacts.toList();
      });
    } else {
      print('No contacts permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          // Display contact information and add friend button if applicable
          // Handle the logic for adding friends or sending invitations
        },
      ),
    );
  }
}
