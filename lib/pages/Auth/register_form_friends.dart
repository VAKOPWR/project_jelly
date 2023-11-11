// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:project_jelly/logic/permissions.dart';

// class AddFriendsPage extends StatefulWidget {
//   const AddFriendsPage({super.key});

//   @override
//   State<AddFriendsPage> createState() => _AddFriendsPageState();
// }

// class _AddFriendsPageState extends State<AddFriendsPage> {
//   List<Contact> _contacts = [];

//   @override
//   void initState() {
//     super.initState();
//     _getContacts();
//   }

//   Future<void> _getContacts() async {
//     bool contactsPermission = await requestContactsPermission();

//     if (contactsPermission) {
//       final contacts = await ContactsService.getContacts();
//       setState(() {
//         _contacts = contacts.toList();
//       });
//     } else {
//       log('No contacts permission');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Contacts'),
//       ),
//       body: ListView.builder(
//         itemCount: _contacts.length,
//         itemBuilder: (context, index) {
//           final contact = _contacts[index];
//         },
//       ),
//     );
//   }
// }
