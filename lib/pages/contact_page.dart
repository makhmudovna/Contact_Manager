import 'package:contact_manager/models/contact.dart';
import 'package:contact_manager/repositories/contact_repository.dart';
import 'package:contact_manager/widgets/contact_from_widget.dart';
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

  void _showContactFromDialog({Contact? contact}) async {
    final title = contact == null ? 'Add Contact' : 'Edit Contact';
    final result = await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            content: ContactFromWidget(
              contact: contact,
            ),
          );
        });

    if (result != null) {
      await loadContacts();
    }
  }

  void _deleteContact(int id) async {
    await ContactRepository.deleteContact(id);
    await loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Contacts'),
      ),
      body: contacts.isEmpty
          ? const Center(child: Text("No contacts"))
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.lightBlueAccent, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomLeft)),
              child: ListView.builder(
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
                          _showContactFromDialog(contact: contact);
                        },
                        trailing: IconButton(
                            onPressed: () {
                              //delete contact
                              _deleteContact(contact.id!);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ),
                    );
                  }),
            ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            //add new contact
            _showContactFromDialog();
          }),
    );
  }
}
