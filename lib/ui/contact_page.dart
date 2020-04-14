import 'dart:io';
import 'dart:ui';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;
  Contact _editedContact;

  Contact get contact => widget.contact;

  @override
  void initState() {
    super.initState();

    if (contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(contact.toMap());
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text(_editedContact.name ?? "Novo Contato"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          backgroundColor: Colors.indigo,
          onPressed: _onClickSave,
        ),
        body: _body(),
      ),
    );
  }

  SingleChildScrollView _body() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _editedContact.img != null
                        ? FileImage(File(_editedContact.img))
                        : Image.asset("assets/images/person-sem-image.png")
                            .image,
                    fit: BoxFit.cover
                  ),
                ),
              ),
              onTap: () {
                ImagePicker.pickImage(source: ImageSource.camera).then((file) {
                  if(file == null) {
                    return;
                  } else {
                    setState(() {
                      _editedContact.img = file.path;
                    });
                  }
                });
              },
            ),
            TextFormField(
              controller: _nameController,
              validator: (value) {
                if (value.isEmpty || value == null) {
                  return "O nome deve ser informado!";
                }
              },
              focusNode: _nameFocus,
              decoration: InputDecoration(
                labelText: "Nome",
              ),
              onChanged: (text) {
                _userEdited = true;
                setState(() {
                  _editedContact.name = text;
                });
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "E-mail",
              ),
              onChanged: (text) {
                _userEdited = true;
                _editedContact.email = text;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: "Phone",
              ),
              onChanged: (text) {
                _userEdited = true;
                _editedContact.phone = text;
              },
              keyboardType: TextInputType.phone,
            )
          ],
        ),
      ),
    );
  }

  void _onClickSave() {
    if (!_formKey.currentState.validate()) {
      FocusScope.of(context).requestFocus(_nameFocus);
      return;
    }
    Navigator.pop(context, _editedContact);
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Descartar alterações?"),
            content: Text("Se você sair as alterações serão perdidas."),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("Sim"),
              ),
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
