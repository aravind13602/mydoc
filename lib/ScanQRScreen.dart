// import 'package:flutter/material.dart';
// import 'package:mongo_dart/mongo_dart.dart' as mongo;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'QRScanningScreen.dart';
//
// class ScanQRScreen extends StatefulWidget {
//   @override
//   _ScanQRScreenState createState() => _ScanQRScreenState();
// }
//
// class _ScanQRScreenState extends State<ScanQRScreen> {
//   TextEditingController documentNumberController = TextEditingController();
//   TextEditingController toController = TextEditingController();
//
//   // MongoDB connection settings
//   final String connectionString =
//       'mongodb+srv://chandirasegaran:25032002@myangadi.bxernfz.mongodb.net/?retryWrites=true&w=majority&appName=MyAngadi';
//   mongo.Db? db;
//   mongo.DbCollection? collection;
//
//   String? _userName; // Variable to store username
//
//   @override
//   void initState() {
//     super.initState();
//     initDb();
//     fetchUserName(); // Fetch username when screen initializes
//   }
//
//   void initDb() async {
//     db = await mongo.Db.create(connectionString);
//     await db!.open();
//     collection = db!.collection('mydoc');
//   }
//
//   void fetchUserName() async {
//     // Get the current user from FirebaseAuth
//     User? user = FirebaseAuth.instance.currentUser;
//
//     if (user != null) {
//       // If user is signed in, set the username without '@'
//       setState(() {
//         _userName = user.displayName?.split('@')[0] ?? user.email?.split('@')[0] ?? 'Unknown User';
//       });
//     } else {
//       // If user is not signed in, handle accordingly
//       // For now, let's set it as 'Unknown User'
//       setState(() {
//         _userName = 'Unknown User';
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     db?.close();
//     super.dispose();
//   }
//
//   Future<void> handleIncomingAction() async {
//     String documentNumber = documentNumberController.text;
//
//     // Check if username is null
//     if (_userName != null) {
//       // Find the document by its number and get the last intermediate
//       var document = await collection?.findOne(mongo.where.eq('documentNumber', documentNumber));
//       if (document != null) {
//         // Get the last intermediate user
//         String? lastIntermediate = document['intermediate_counter'] != null
//             ? document['intermediate_${document['intermediate_counter']}']
//             : null;
//         // Check if the last intermediate is the same as the current user
//         if (lastIntermediate == _userName) {
//           // Update the status to true for incoming
//           await collection?.update(
//             mongo.where.eq('_id', document['_id']),
//             mongo.modify.set('status', true), // Set status to true for incoming
//           );
//         } else {
//           // Increment the intermediate counter
//           int counter = document['intermediate_counter'] ?? 0;
//           counter++;
//           // Update the current document's intermediate field and status
//           await collection?.update(
//             mongo.where.eq('_id', document['_id']),
//             mongo.modify
//                 .set('intermediate_$counter', _userName)
//                 .set('intermediate_counter', counter)
//                 .set('status', true), // Set status to true for incoming
//           );
//         }
//
//         // Show dialog
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text("File Status Updated"),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text("OK"),
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     } else {
//       // Show error message or handle accordingly if username is null
//       print('Username is null');
//     }
//   }
//
//   Future<void> handleOutgoingAction() async {
//     String documentNumber = documentNumberController.text;
//
//     // Find the document by its number
//     var document = await collection?.findOne(mongo.where.eq('documentNumber', documentNumber));
//     if (document != null) {
//       // Get the main "to" and check if it's the same as the login user
//       String mainTo = document['to'];
//       if (mainTo == _userName) {
//         // Show options for accepted and rejected
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text("Outgoing Form"),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () async {
//                       // Update status to accepted
//                       await collection?.update(
//                         mongo.where.eq('_id', document['_id']),
//                         mongo.modify.set('status', 'accepted'),
//                       );
//                       Navigator.of(context).pop();
//                     },
//                     child: Text("Accept"),
//                   ),
//                   ElevatedButton(
//                     onPressed: () async {
//                       // Update status to rejected
//                       await collection?.update(
//                         mongo.where.eq('_id', document['_id']),
//                         mongo.modify.set('status', 'rejected'),
//                       );
//                       Navigator.of(context).pop();
//                     },
//                     child: Text("Reject"),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       } else {
//         // Increment the intermediate counter
//         int counter = document['intermediate_counter'] ?? 0;
//         counter++;
//         // Update the current document's intermediate field and status
//         await collection?.update(
//           mongo.where.eq('_id', document['_id']),
//           mongo.modify
//               .set('intermediate_$counter', _userName)
//               .set('intermediate_counter', counter)
//               .set('status', false), // Set status to false for outgoing
//         );
//
//         // Show dialog
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text("Outgoing Form Sent"),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text("OK"),
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     } else {
//       // Handle case when document is not found
//       print('Document not found');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Scan QR Code'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: documentNumberController,
//               decoration: InputDecoration(
//                 labelText: 'Enter Document Number',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.qr_code_scanner),
//                   onPressed: () async {
//                     // Navigate to QR scanning screen and get the scanned data
//                     String scannedData = await Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => QRScanningScreen()),
//                     );
//                     // Set the scanned data to the text field
//                     if (scannedData != null) {
//                       documentNumberController.text = scannedData;
//                     }
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: () async {
//                       await handleIncomingAction();
//                     },
//                     icon: Icon(Icons.arrow_downward),
//                     label: Text('Incoming'),
//                   ),
//                 ),
//                 SizedBox(width: 16.0),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: () async {
//                       await handleOutgoingAction();
//                     },
//                     icon: Icon(Icons.arrow_upward),
//                     label: Text('Outgoing'),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: ScanQRScreen(),
//   ));
// }
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:firebase_auth/firebase_auth.dart';
import 'QRScanningScreen.dart';

class ScanQRScreen extends StatefulWidget {
  @override
  _ScanQRScreenState createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  TextEditingController documentNumberController = TextEditingController();
  TextEditingController toController = TextEditingController();

  // MongoDB connection settings
  final String connectionString =
      'mongodb+srv://chandirasegaran:25032002@myangadi.bxernfz.mongodb.net/?retryWrites=true&w=majority&appName=MyAngadi';
  mongo.Db? db;
  mongo.DbCollection? collection;

  String? _userName; // Variable to store username

  @override
  void initState() {
    super.initState();
    initDb();
    fetchUserName(); // Fetch username when screen initializes
  }

  void initDb() async {
    db = await mongo.Db.create(connectionString);
    await db!.open();
    collection = db!.collection('mydoc');
  }

  void fetchUserName() async {
    // Get the current user from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // If user is signed in, set the username without '@'
      setState(() {
        _userName = user.displayName?.split('@')[0] ?? user.email?.split('@')[0] ?? 'Unknown User';
      });
    } else {
      // If user is not signed in, handle accordingly
      // For now, let's set it as 'Unknown User'
      setState(() {
        _userName = 'Unknown User';
      });
    }
  }

  @override
  void dispose() {
    db?.close();
    super.dispose();
  }

  Future<void> handleIncomingAction() async {
    String documentNumber = documentNumberController.text;

    // Check if username is null
    if (_userName != null) {
      // Find the document by its number and get the last intermediate
      var document = await collection?.findOne(mongo.where.eq('documentNumber', documentNumber));
      if (document != null) {
        // Get the last intermediate user
        String? lastIntermediate = document['intermediate_counter'] != null
            ? document['intermediate_${document['intermediate_counter']}']
            : null;
        // Check if the last intermediate is the same as the current user
        if (lastIntermediate == _userName) {
          // Update the status to true for incoming
          await collection?.update(
            mongo.where.eq('_id', document['_id']),
            mongo.modify.set('status', true), // Set status to true for incoming
          );
        } else {
          // Increment the intermediate counter
          int counter = document['intermediate_counter'] ?? 0;
          counter++;
          // Update the current document's intermediate field and status
          await collection?.update(
            mongo.where.eq('_id', document['_id']),
            mongo.modify
                .set('intermediate_$counter', _userName)
                .set('intermediate_counter', counter)
                .set('status', true), // Set status to true for incoming
          );
        }

        // Show dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("File Status Updated"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Show error message or handle accordingly if username is null
      print('Username is null');
    }
  }

  Future<void> handleOutgoingAction() async {
    String documentNumber = documentNumberController.text;
    String to = toController.text;

    // Find the document by its number
    var document = await collection?.findOne(mongo.where.eq('documentNumber', documentNumber));
    if (document != null) {
      // Get the last intermediate user
      String? lastIntermediate = document['intermediate_counter'] != null
          ? document['intermediate_${document['intermediate_counter']}']
          : null;

      // Check if the "To" field matches either the current user, the last intermediate user, or the main "To" user
      if (_userName == to || _userName == lastIntermediate || to == lastIntermediate) {
        // Increment the intermediate counter
        int counter = document['intermediate_counter'] ?? 0;
        counter++;
        // Update the current document's intermediate field and status
        await collection?.update(
          mongo.where.eq('_id', document['_id']),
          mongo.modify
              .set('intermediate_$counter', to)
              .set('intermediate_counter', counter)
              .set('status', false), // Set status to false for outgoing
        );

        // Show dialog for successful outgoing form sent
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Outgoing Form Sent"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        // Show options for accepting or rejecting the outgoing request
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Outgoing Form"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Do you want to accept or reject the outgoing request?'),
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    // Update the status to accepted
                    await collection?.update(
                      mongo.where.eq('_id', document['_id']),
                      mongo.modify
                          .set('status', 'accepted'),
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text("Accept"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Update the status to rejected
                    await collection?.update(
                      mongo.where.eq('_id', document['_id']),
                      mongo.modify
                          .set('status', 'rejected'),
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text("Reject"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Handle case when document is not found
      print('Document not found');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Scan QR Code'),
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    TextField(
    controller: documentNumberController,
    decoration: InputDecoration(
    labelText: 'Enter Document Number',
    suffixIcon: IconButton(
    icon: Icon(Icons.qr_code_scanner),
    onPressed: () async {
    // Navigate to QR scanning screen and get the scanned data
    String scannedData = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => QRScanningScreen()),
    );
    // Set the scanned data to the text field
    if (scannedData != null) {
    documentNumberController.text = scannedData;
    }
    },
    ),
    ),
    ),
    SizedBox(height: 16.0),
    Row(
    children: [
    Expanded(
    child: ElevatedButton.icon(
    onPressed: () async {
      await handleIncomingAction();
    },
      icon: Icon(Icons.arrow_downward),
      label: Text('Incoming'),
    ),
    ),
      SizedBox(width: 16.0),
      Expanded(
        child: ElevatedButton.icon(
          onPressed: () async {
            // Show the outgoing form dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Outgoing Form"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: toController,
                        decoration: InputDecoration(
                          labelText: 'To:',
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await handleOutgoingAction();
                        Navigator.of(context).pop();
                      },
                      child: Text("Send"),
                    ),
                  ],
                );
              },
            );
          },
          icon: Icon(Icons.arrow_upward),
          label: Text('Outgoing'),
        ),
      ),
    ],
    ),
    ],
    ),
        ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ScanQRScreen(),
  ));
}
