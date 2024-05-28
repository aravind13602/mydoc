import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mydoc/ScanQRScreen.dart';
import 'package:mydoc/TrackScreen.dart';
import 'package:mydoc/login_page.dart';
import 'package:mydoc/new_request.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User? user;
  String? userName;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userName = user!.email!.split('@')[0]; // Extracting username from email
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool confirm = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Logout'),
            content: Text('Are you sure you want to logout?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
                  );
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );
        return confirm ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 230, 18, 14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      userName ?? 'John Doe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      user!.email!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('New Request'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewRequestScreen(userName: userName ?? "John"),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.qr_code_scanner),
                title: Text('Scan QR Code'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScanQRScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.track_changes),
                title: Text('Track'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TrackScreen()),
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewRequestScreen(userName: userName ?? "John"),
                    ),
                  );
                },
                label: Text('New Request'),
                icon: Icon(Icons.add),
                backgroundColor: Color.fromARGB(255, 230, 18, 14),
              ),
              SizedBox(height: 16.0),
              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScanQRScreen()),
                  );
                },
                label: Text('Scan QR Code'),
                icon: Icon(Icons.qr_code_scanner),
                backgroundColor: Color.fromARGB(255, 230, 18, 14),
              ),
              SizedBox(height: 16.0),
              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TrackScreen()),
                  );
                },
                label: Text('Track'),
                icon: Icon(Icons.track_changes),
                backgroundColor: Color.fromARGB(255, 230, 18, 14),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
