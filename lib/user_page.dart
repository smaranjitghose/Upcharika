import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upcharika/auth/pages/auth_screen.dart';
import 'package:upcharika/auth/service/auth_service.dart';
import 'package:upcharika/models/user.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  User user = AuthService().getUser;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  String dob = "";

  @override
  void initState() {
    _nameController.text = user.displayName;
    _emailController.text = user.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Consumer<LocalUser>(builder: (context, localUser, child) {
                  return Row(
                    children: [
                      Hero(
                        tag: "user-image",
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: user.photoURL == null
                              ? AssetImage("assets/default_user.png")
                              : NetworkImage(localUser.user.photoURL),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localUser.user.displayName,
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(localUser.user.email,
                                    style: TextStyle(fontSize: 18)),
                                localUser.user.emailVerified
                                    ? Icon(Icons.verified,
                                        color: Colors.greenAccent)
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }),
                SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RecordContainer(
                            title: "Last heart rate", body: "84"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RecordContainer(
                            title: "Last SpO\u2082 level", body: "43"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Divider(thickness: 2),
                ),
                buildTextField(controller: _nameController, label: "Name"),
                SizedBox(height: 15),
                buildTextField(controller: _emailController, label: "Email"),
                SizedBox(height: 15),
                GestureDetector(
                  child: buildTextField(
                      controller: _dobController,
                      label: "D.O.B",
                      enabled: false),
                  onTap: () async {
                    DateTime dob = await showDatePicker(
                        context: context,
                        initialDate:
                            DateTime.now().add(Duration(days: 365 * -18)),
                        firstDate:
                            DateTime.now().add(Duration(days: 365 * -50)),
                        lastDate:
                            DateTime.now().add(Duration(days: 365 * 100)));

                    setState(() {
                      _dobController.text =
                          "${dob.day} / ${dob.month} / ${dob.year}";
                    });
                  },
                ),
                SizedBox(height: 15),
                buildTextField(
                    controller: _locationController, label: "Location"),
                ElevatedButton(
                  onPressed: (_nameController.text != user.displayName ||
                          _emailController.text != user.email)
                      ? () async {
                          if (AuthService().getUser.email !=
                              _emailController.text) {
                            try {
                              await AuthService()
                                  .getUser
                                  .updateEmail(_emailController.text);
                            } on FirebaseAuthException catch (e) {
                              if (e.code == "requires-recent-login") {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => AuthenticationScreen()));
                              }
                            }
                          }
                          if (AuthService().getUser.displayName !=
                              _nameController.text)
                            await AuthService().getUser.updateProfile(
                                displayName: _nameController.text);

                          FocusScope.of(context).unfocus();
                          Provider.of<LocalUser>(context, listen: false)
                              .updateUser = AuthService().getUser;
                        }
                      : null,
                  child: Text("Save"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      {TextEditingController controller, String label, bool enabled = true}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        filled: true,
        fillColor: Colors.transparent.withOpacity(0.2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.transparent.withOpacity(0.2)),
        ),
      ),
      onChanged: (value) {
        setState(() {});
      },
    );
  }
}

class RecordContainer extends StatelessWidget {
  const RecordContainer({Key key, this.title, this.body}) : super(key: key);

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.transparent.withOpacity(0.2),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20),
          ),
          Spacer(),
          Text(
            body,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
