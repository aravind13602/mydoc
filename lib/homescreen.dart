import 'package:flutter/material.dart';
import 'package:mydoc/ScanQRScreen.dart';
import 'package:mydoc/TrackScreen.dart';
import 'package:mydoc/login_page.dart';
import 'package:mydoc/new_request.dart';
// import 'package:doctrack/new_request.dart';
// import 'login.dart'; // Assuming you have a login screen named LoginScreen
// import 'package:doctrack/ScanQRScreen.dart'; // Import the ScanQRScreen
// import 'package:doctrack/TrackScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog when the back button is pressed
        bool confirm = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Logout'),
            content: Text('Are you sure you want to logout?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // Return false when 'No' is pressed
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  // Navigate back to the login screen
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
                  );
                }, // Return true when 'Yes' is pressed
                child: Text('Yes'),
              ),
            ],
          ),
        );

        // Return true to allow back navigation if 'Yes' is pressed, otherwise false
        return confirm ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                // Navigate back to the login screen
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
                    CircleAvatar(
                      backgroundImage: AssetImage('profile_photo.png'), // Set your profile photo here
                      radius: 30,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'John Doe', // Set user name here
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'john.doe@example.com', // Set user email here
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
                      builder: (context) => NewRequestScreen(userName: "John"),
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
                      builder: (context) => NewRequestScreen(userName: "John"),
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
