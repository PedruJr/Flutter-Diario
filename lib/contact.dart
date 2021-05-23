import 'package:agenda_de_contatos_palhoca/utils/contact.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact;
  ContactUtils utils = ContactUtils();
  final _nameFocus = FocusNode();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _moodController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  bool _edited = false;

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = widget.contact;
      _nameController.text = _editedContact.name;
      _moodController.text = _editedContact.mood;
      _descriptionController.text = _editedContact.description;
      _dateController.text = _editedContact.date;
    }
  }


  @override
  Widget build(BuildContext context) {
    var _values = ['😭','😢','😐','🙂','😁'];
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink[600],
          title: Text(_editedContact.name != null
              ? _editedContact.name
              : "Conte sobre seu dia!(ﾉ◕ヮ◕)ﾉ*:･ﾟ"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink[600],
          child: Icon(Icons.save),
          onPressed: () {
            if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  ImagePicker.pickImage(source: ImageSource.camera)
                      .then((value) {
                    if (value == null) return;
                    setState(() {
                      _editedContact.img = value.path;
                    });
                    _edited = true;
                  });
                },
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _editedContact.img != null
                              ? FileImage(File(_editedContact.img))
                              : AssetImage("images/default-image.png"))),
                ),
              ),
              TextField(
                focusNode: _nameFocus,
                controller: _nameController,
                decoration: InputDecoration(labelText: "Descreva seu dia em uma palavra:"),
                onChanged: (text) {
                  _edited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
              ),
             TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Descrição"),
                onChanged: (text) {
                  _edited = true;
                  _editedContact.description = text;
                },
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(labelText: "Data"),
                onChanged: (text) {
                  _edited = true;
                  _editedContact.date = text;
                },
                keyboardType: TextInputType.datetime,
              ),
              DropdownButton<String>(
                items: _values.map((String dropDownStringItem){
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem));
                }).toList(),
                onChanged: (text) {
                  _edited = true;
                  _editedContact.mood = text;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_edited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.pink[700],
              buttonPadding: EdgeInsets.all(10),
              title: Text(
                "Descartar Alterações?",
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                "Se sair as alterações serão perdidas",
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                FlatButton(
                  minWidth: 100,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.check_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                FlatButton(
                  minWidth: 100,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            );
          });
    }
    return Future.value(true);
  }
}
