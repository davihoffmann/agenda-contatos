import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact;

  Contact get contact => widget.contact;

  @override
  void initState() {
    super.initState();

    if (contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(contact.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(_editedContact.name ?? "Novo Contato"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        backgroundColor: Colors.indigo,
        onPressed: () {},
      ),
    );
  }
}
