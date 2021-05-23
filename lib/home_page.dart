import 'dart:io';

import 'package:agenda_de_contatos_palhoca/contact.dart';
import 'package:agenda_de_contatos_palhoca/utils/contact.dart';
import 'package:agenda_de_contatos_palhoca/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ContactUtils utils = ContactUtils();
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _getAllContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[600],
        title: Text("Meu diário 📕"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContact();
        },
        backgroundColor: Colors.pink[600],
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
      ),
    );
  }

  void _getAllContacts() {
    utils.getAllContacts().then((value) => {
          setState(() {
            _contacts = value;
          })
        });
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _showOptions(context, index);
      },
      child: Card(
        child: Row(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: _contacts[index].img != null
                        ? FileImage(File(_contacts[index].img))
                        : AssetImage("images/default-image.png")),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextDefault("Data: " +_contacts[index].date, true),
                    TextDefault("Dia de "+ _contacts[index].name, true),
                    TextDefault("Mood: " +_contacts[index].mood, false),
                    TextDefault(_contacts[index].description, false),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  void _showContact({Contact contact}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));
    if (recContact != null) {
      if (contact != null) {
        await utils.update(recContact);
      } else {
        await utils.saveContact(recContact);
      }
    }
    _getAllContacts();
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showContact(contact: _contacts[index]);
                        },
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.pink[600], fontSize: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        onPressed: () {
                          utils.delete(_contacts[index].id);
                          setState(() {
                            _getAllContacts();
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Excluir",
                          style: TextStyle(color: Colors.green, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
