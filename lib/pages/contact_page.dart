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
    print("CONTACTS: $contacts");
    setState(() {
      this.contacts = contacts;
    });
  }

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Contacts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: contacts.isEmpty
            ? const Center(child: Text("No contacts"))
            : ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return Card(
                    elevation: 6,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          contact.name[0].toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                      title: Text(
                        contact.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text(
                        contact.email,
                        style: const TextStyle(fontSize: 12),
                      ),
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
      ),
    );
  }
}
