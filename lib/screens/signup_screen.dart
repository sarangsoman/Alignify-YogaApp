import 'package:alignify/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import '../widgets/customized_button.dart';
import '../widgets/customized_textfield.dart';
import 'login_screen.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _goalWeightController = TextEditingController();
  File? _imageFile;
  String _imageUrl= "https://picsum.photos/id/237/200/300";

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_sharp),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Hello !  Register to get \nStarted",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: CustomizedTextfield(
                        myController: _nameController,
                        hintText: "Name",
                        isPassword: false,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _getImage,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[200],
                      backgroundImage:
                          _imageFile != null ? FileImage(_imageFile!) : null,
                      child: _imageFile == null
                          ? Icon(Icons.camera_alt,
                              size: 30, color: Colors.grey[800])
                          : null,
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomizedTextfield(
                  myController: _emailController,
                  hintText: "Email",
                  isPassword: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomizedTextfield(
                  myController: _passwordController,
                  hintText: "Password",
                  isPassword: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomizedTextfield(
                  myController: _bioController,
                  hintText: "Enter a short Bio",
                  isPassword: false,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 3),
                      child: CustomizedTextfield(
                        myController: _goalWeightController,
                        hintText: "Goal Weight",
                        isPassword: false,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 3),
                      child: CustomizedTextfield(
                        myController: _ageController,
                        hintText: "Age",
                        isPassword: false,
                      ),
                    ),
                  ),
                ],
              ),
              CustomizedButton(
                buttonText: "Register",
                buttonColor: Colors.black,
                textColor: Colors.white,
                onPressed: _register,
              ),
              /*
              const Padding(
                padding: EdgeInsets.all(1.0),
                child: Row(
                  children: [
                    // Container(
                    //   height: 1,
                    //   width: MediaQuery.of(context).size.height * 0.15,
                    //   color: Colors.grey,
                    // ),
                    /*
                    const Text("Or Register with"),
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.height * 0.16,
                      color: Colors.grey,
                    ),*/
                  ],
                ),
              ),
            
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.facebookF,
                            color: Colors.blue,
                          ),
                          onPressed: () {},
                        )),
                    Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.google,
                          // color: Colors.blue,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.apple,
                            // color: Colors.blue,
                          ),
                          onPressed: () {},
                        ))
                  ],
                ),
              ),
              */
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(48, 8, 8, 8.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("Already have an account?",
                        style: TextStyle(
                          color: Color(0xff1E232C),
                          fontSize: 15,
                        )),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()));
                      },
                      child: const Text("  Login Now",
                          style: TextStyle(
                            color: Color(0xff35C2C1),
                            fontSize: 15,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _register() async {
    try {
      if (_imageFile != null) {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${_nameController.text}_avatar.jpg');
        await ref.putFile(_imageFile!);
        _imageUrl = await ref.getDownloadURL();
      }

      await FirebaseAuthService().signup(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _bioController.text.trim(),
        int.parse(_ageController.text.trim()),
        int.parse(_goalWeightController.text.trim()),
        _imageUrl, 
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }
}
