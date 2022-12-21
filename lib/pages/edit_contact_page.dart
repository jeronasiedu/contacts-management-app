// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_cli/theme/theme.dart';
import 'package:firebase_cli/utils/my_firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class EditContactPage extends StatefulWidget {
  const EditContactPage({
    Key? key,
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  }) : super(key: key);
  final String id;
  final String name;
  final String phone;
  final String email;

  @override
  State<EditContactPage> createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.phone);
    emailController = TextEditingController(text: widget.email);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
  }

  void editContact() async {
    if (_formKey.currentState!.validate()) {
      try {
        await MyFirebase.contactsCollection.doc(widget.id).update({
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
          'email': emailController.text.trim(),
        });
        Navigator.pop(context);
      } on FirebaseException {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to edit contact'),
            backgroundColor: Colors.red[300],
          ),
        );
      }
    } else {
      // show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all the fields'),
          backgroundColor: Colors.red[300],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Contact"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // display avatar
          Center(
            child: Hero(
              tag: widget.id,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  "https://avatars.dicebear.com/api/avataaars/${widget.name}.png",
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: "Name",
                    contentPadding: inputPadding,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: phoneController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a phone number";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Phone",
                    contentPadding: inputPadding,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter an email";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    contentPadding: inputPadding,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton.icon(
                      onPressed: editContact,
                      icon: const Icon(IconlyBroken.edit),
                      label: const Text("Edit Contact")),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
