import 'package:contact_manager/models/contact.dart';
import 'package:contact_manager/repositories/contact_repository.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Contact> contacts = [];

  Future<void> loadContacts() async {
    final contacts = await ContactRepository.getContacts();
    setState(() {
      this.contacts = contacts;
    });
  }

  @override
  void initState() {
    loadContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    contact.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  contact.name[0],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(contact.email),
                onTap: () {
                  //edit contact
                },
                trailing: IconButton(
                    onPressed: () {
                      //delete contact
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              ),
            );
          }),
    );
  }
}
