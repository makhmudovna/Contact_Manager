import 'package:contact_manager/models/contact.dart';
import 'package:contact_manager/repositories/contact_repository.dart';
import 'package:flutter/material.dart';

class ContactFromWidget extends StatefulWidget {
  final Contact? contact;
  const ContactFromWidget({super.key, this.contact});

  @override
  State<ContactFromWidget> createState() => _ContactFromWidgetState();
}

class _ContactFromWidgetState extends State<ContactFromWidget> {
  final _fromKey = GlobalKey<FormState>();
  String name = "", email = "", phone = "", address = "";

  @override
  void initState() {
    super.initState();
    name = widget.contact?.name ?? "";
    email = widget.contact?.email ?? "";
    phone = widget.contact?.phone ?? "";
    address = widget.contact?.address ?? "";
  }

  void _save() async {
    if (_fromKey.currentState!.validate()) {
      _fromKey.currentState!.save();
      final contact = Contact(
          id: widget.contact?.id,
          name: name,
          email: email,
          phone: phone,
          address: address);

      if (widget.contact == null) {
        await ContactRepository.addContact(contact);
      } else {
        await ContactRepository.updateContact(contact);
      }

      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
          key: _fromKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onSaved: (v) => name = v ?? " ",
              ),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onSaved: (v) => email = v ?? " ",
              ),
              TextFormField(
                initialValue: phone,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onSaved: (v) => phone = v ?? " ",
              ),
              TextFormField(
                initialValue: address,
                decoration: const InputDecoration(
                  labelText: 'Address',
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onSaved: (v) => address = v ?? " ",
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(onPressed: _save, child: const Text('Save'))
                ],
              )
            ],
          )),
    );
  }
}
