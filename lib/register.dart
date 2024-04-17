import 'package:flutter/material.dart';
import './colors.dart';
import './constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String designation = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  // Image.asset(
                  //   bgimage,
                  //   height: height * 0.27,
                  //   width: width,
                  //   fit: BoxFit.cover,
                  // ),
                  Container(
                    height: height * 0.37,
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        stops: [0.3, 0.75],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.white],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        appName,
                        style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Text(
                  slogan,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 20),
                child: Container(
                  child: Text(
                    "  $signupString",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor.withOpacity(0.3), Colors.transparent],
                    ),
                    border: Border(
                      left: BorderSide(color: primaryColor, width: 5),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your name';
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    prefixIcon: Icon(Icons.person, color: primaryColor),
                    labelText: "NAME",
                    labelStyle: TextStyle(color: primaryColor, fontSize: 16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your designation';
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      designation = value;
                    });
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    prefixIcon: Icon(Icons.work, color: primaryColor),
                    labelText: "DESIGNATION",
                    labelStyle: TextStyle(color: primaryColor, fontSize: 16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your email';
                    else if (!RegExp("^[a-zA-Z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}\$").hasMatch(value)) return "Invalid email";
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    prefixIcon: Icon(Icons.email, color: primaryColor),
                    labelText: "EMAIL ADDRESS",
                    labelStyle: TextStyle(color: primaryColor, fontSize: 16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your password';
                    else if (value.length < 8 || value.length > 15) return 'Password must be 8 to 15 characters long';
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    prefixIcon: Icon(Icons.lock_open, color: primaryColor),
                    labelText: "PASSWORD",
                    labelStyle: TextStyle(color: primaryColor, fontSize: 16),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: width * 0.7,
                  child: FloatingActionButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        print('Success');
                        // Call the register function to store user info in Firebase Auth
                        // await _register();
                      }
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
                    ),
                    backgroundColor: Color.fromARGB(255, 230, 18, 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
