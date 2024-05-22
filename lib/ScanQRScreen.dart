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
//   TextEditingController commentController = TextEditingController();
//
//   // MongoDB connection settings
//   final String connectionString = 'mongodb+srv://chandirasegaran:25032002@myangadi.bxernfz.mongodb.net/?retryWrites=true&w=majority&appName=MyAngadi';
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
//       // Find the document by its number
//       var document = await collection?.findOne(mongo.where.eq('documentNumber', documentNumber));
//       if (document != null) {
//         // Check if intermediate and current user are the same
//         if (document['intermediate'] == _userName) {
//           // Show error dialog
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text("Action Not Allowed"),
//                 content: Text("Incoming and Outgoing actions are not allowed as you are the current intermediate."),
//                 actions: <Widget>[
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text("OK"),
//                   ),
//                 ],
//               );
//             },
//           );
//         } else {
//           // Update the status of the last intermediate step to true
//           int intermediateCounter = document['intermediate_counter'] ?? 0;
//           String lastIntermediateStatusField = 'status_${intermediateCounter == 0 ? "" : intermediateCounter}';
//
//           await collection?.update(
//             mongo.where.eq('documentNumber', documentNumber),
//             mongo.modify
//                 .set('status', false)
//                 .set(lastIntermediateStatusField, true)
//                 .set('intermediate', _userName),
//           );
//
//           // Show dialog
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text("File Status Updated"),
//                 actions: <Widget>[
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text("OK"),
//                   ),
//                 ],
//               );
//             },
//           );
//         }
//       }
//     } else {
//       // Show error message or handle accordingly if username is null
//       print('Username is null');
//     }
//   }
//
//   Future<void> handleOutgoingAction() async {
//     String documentNumber = documentNumberController.text;
//     String to = toController.text;
//
//     // Find the document by its number
//     var document = await collection?.findOne(mongo.where.eq('documentNumber', documentNumber));
//     if (document != null) {
//       // Check if intermediate and to fields are the same
//       if (document['intermediate'] == to) {
//         // Show Accept/Reject dialog with comment
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text("Review Document"),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text("Please provide your comment:"),
//                   TextField(
//                     controller: commentController,
//                     decoration: InputDecoration(
//                       labelText: 'Comment',
//                     ),
//                   ),
//                 ],
//               ),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text("Cancel"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     await handleAcceptAction(documentNumber);
//                     Navigator.of(context).pop();
//                   },
//                   child: Text("Accept"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     await handleRejectAction(documentNumber);
//                     Navigator.of(context).pop();
//                   },
//                   child: Text("Reject"),
//                 ),
//               ],
//             );
//           },
//         );
//       } else {
//         // Check if intermediate field already exists
//         if (document.containsKey('intermediate')) {
//           // Increment the intermediate counter
//           int counter = document['intermediate_counter'] ?? 1;
//           counter++;
//
//           // Update the current document's intermediate field
//           await collection?.update(
//             mongo.where.eq('_id', document['_id']),
//             mongo.modify
//                 .set('intermediate_$counter', to)
//                 .set('intermediate_counter', counter)
//                 .set('status_$counter', false) // New intermediate step should have status as false
//                 .unset('outgoing'), // Remove outgoing field if it exists
//           );
//         } else {
//           // Create a new intermediate field
//           await collection?.update(
//             mongo.where.eq('_id', document['_id']),
//             mongo.modify
//                 .set('intermediate', to)
//                 .set('intermediate_counter', 1)
//                 .set('status', false) // New intermediate step should have status as false
//                 .unset('outgoing'), // Remove outgoing field if it exists
//           );
//         }
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
//   Future<void> handleAcceptAction(String documentNumber) async {
//     String comment = commentController.text;
//     await collection?.update(
//       mongo.where.eq('documentNumber', documentNumber),
//       mongo.modify.set('accepted', true).set('comment', comment),
//     );
//     // Show dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Document Accepted"),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> handleRejectAction(String documentNumber) async {
//     String comment = commentController.text;
//     await collection?.update(
//       mongo.where.eq('documentNumber', documentNumber),
//       mongo.modify.set('accepted', false).set('comment', comment),
//     );
//     // Show dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Document Rejected"),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
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
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: Text("Outgoing Form"),
//                             content: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 TextFormField(
//                                   controller: toController,
//                                   decoration: InputDecoration(
//                                     labelText: 'To:',
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             actions: <Widget>[
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                 },
//                                 child: Text("Cancel"),
//                               ),
//                               ElevatedButton(
//                                 onPressed: () async {
//                                   await handleOutgoingAction();
//                                   Navigator.of(context).pop();
//                                 },
//                                 child: Text("Send"),
//                               ),
//                             ],
//                           );
//                         },
//                       );
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
  TextEditingController commentController = TextEditingController();

  // MongoDB connection settings
  final String connectionString =
      'mongodb+srv://chandirasegaran:25032002@myangadi.bxernfz.mongodb.net/?retryWrites=true&w=majority&appName=MyAngadi';
  mongo.Db? db;
  mongo.DbCollection? collection;

  String? _userName; // Variable to store username
  int intermediateCounter = 0; // Intermediate counter variable

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
      // Find the document by its number
      var document = await collection?.findOne(mongo.where.eq('documentNumber', documentNumber));
      if (document != null) {
        // Update the intermediate counter
        intermediateCounter = document['intermediate_counter'] ?? 0;

        // Check if intermediate and current user are the same
        if (document['intermediate'] == _userName) {
          // Show error dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Action Not Allowed"),
                content: Text("Incoming and Outgoing actions are not allowed as you are the current intermediate."),
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
          // Update the status of the last intermediate step to true
          String lastIntermediateStatusField = 'status_${intermediateCounter == 0 ? "" : intermediateCounter}';

          await collection?.update(
            mongo.where.eq('documentNumber', documentNumber),
            mongo.modify
                .set('status', false)
                .set(lastIntermediateStatusField, true)
                .set('intermediate', _userName),
          );

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
      // Update the intermediate counter
      intermediateCounter = document['intermediate_counter'] ?? 0;

      // Check if intermediate and to fields are the same
      if (document['intermediate'] == to || document['intermediate'] == _userName) {
        // Show Accept/Reject dialog with comment
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Review Document"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Please provide your comment:"),
                  TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      labelText: 'Comment',
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
                    await handleAcceptAction(documentNumber);
                    Navigator.of(context).pop();
                  },
                  child: Text("Accept"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await handleRejectAction(documentNumber);
                    Navigator.of(context).pop();
                  },
                  child: Text("Reject"),
                ),
              ],
            );
          },
        );
      } else {
        // Increment the intermediate counter
        intermediateCounter++;

        // Update the current document's intermediate field
        await collection?.update(
          mongo.where.eq('_id', document['_id']),
          mongo.modify
              .set('intermediate_$intermediateCounter', to)
              .set('intermediate_counter', intermediateCounter)
              .set('status_$intermediateCounter', false) // New intermediate step should have status as false
              .unset('outgoing'), // Remove outgoing field if it exists
        );

        // Show dialog
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
      }
    } else {
      // Handle case when document is not found
      print('Document not found');
    }
  }

  Future<void> handleAcceptAction(String documentNumber) async {
    String comment = commentController.text;
    await collection?.update(
      mongo.where.eq('documentNumber', documentNumber),
      mongo.modify.set('accepted', true).set('comment', comment),
    );
    // Show dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Document Accepted"),
          content: Text("Document has been accepted"),
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

  Future<void> handleRejectAction(String documentNumber) async {
    String comment = commentController.text;
    await collection?.update(
      mongo.where.eq('documentNumber', documentNumber),
      mongo.modify.set('rejected', true).set('comment', comment),
    );
    // Show dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Document Rejected"),
          content: Text("Document has been rejected."),
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
                    onPressed: () {
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
