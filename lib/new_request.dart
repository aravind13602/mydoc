import 'package:flutter/material.dart';
import 'package:mydoc/QRDisplayScreen.dart';


class NewRequestScreen extends StatelessWidget {
  final String userName;

  NewRequestScreen({required this.userName});

  @override
  Widget build(BuildContext context) {
    TextEditingController toController = TextEditingController();
    TextEditingController documentNumberController = TextEditingController();
    TextEditingController subController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('New Request'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'From: $userName',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: toController,
              decoration: InputDecoration(labelText: 'To'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: documentNumberController,
              decoration: InputDecoration(labelText: 'Document Number'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: subController,
              decoration: InputDecoration(labelText: 'Sub:'),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                String documentNumber = documentNumberController.text;
                String sub = subController.text;
                String to = toController.text;

                // Generate QR code data
                String qrData = 'Document Number: $documentNumber';

                // Navigate to QRDisplayScreen and pass qrData
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRDisplayScreen(qrData: qrData),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(230, 18, 14, 1), // Set button color
              ),
              child: Text('Generate QR', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:mongo_dart/mongo_dart.dart';
// import 'package:mydoc/QRDisplayScreen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class NewRequestScreen extends StatefulWidget {
//   final String userName;
//
//   NewRequestScreen({required this.userName});
//
//   @override
//   _NewRequestScreenState createState() => _NewRequestScreenState();
// }
//
// class _NewRequestScreenState extends State<NewRequestScreen> {
//   final TextEditingController toController = TextEditingController();
//   final TextEditingController documentNumberController = TextEditingController();
//   final TextEditingController subController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   late Db db;
//
//   @override
//   void initState() {
//     super.initState();
//     _connectToDb();
//   }
//
//   _connectToDb() async {
//     db = Db('mongodb+srv://aravindbs001:<XMexpuSLDQ6Tk9Ym>@cluster0.juuxnxc.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0');
//     try {
//       await db.open();
//       print('Connected to MongoDB');
//     } catch (e) {
//       print('Error connecting to MongoDB: $e');
//     }
//   }
//
//   @override
//   void dispose() {
//     db.close();
//     super.dispose();
//   }
//
//   Future<void> _insertData(String documentNumber, String to, String sub) async {
//     await db.open();
//
//     try {
//       await db.collection('userdetails').insert({
//         'documentNumber': documentNumber,
//         'from': widget.userName,
//         'to': to,
//         'sub': sub,
//       });
//       print('Data inserted successfully into userdetails');
//     } catch (e) {
//       print('Error inserting data into userdetails: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('New Request'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'From: ${widget.userName}',
//               style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16.0),
//             TextFormField(
//               controller: toController,
//               decoration: InputDecoration(labelText: 'To'),
//             ),
//             SizedBox(height: 16.0),
//             TextFormField(
//               controller: documentNumberController,
//               decoration: InputDecoration(labelText: 'Document Number'),
//             ),
//             SizedBox(height: 16.0),
//             TextFormField(
//               controller: subController,
//               decoration: InputDecoration(labelText: 'Sub:'),
//             ),
//             SizedBox(height: 32.0),
//             ElevatedButton(
//               onPressed: () async {
//                 String documentNumber = documentNumberController.text;
//                 String sub = subController.text;
//                 String to = toController.text;
//
//                 // Insert data into MongoDB
//                 await _insertData(documentNumber, to, sub);
//
//                 // Generate QR code data
//                 String qrData = 'Document Number: $documentNumber';
//
//                 // Navigate to QRDisplayScreen and pass qrData
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => QRDisplayScreen(qrData: qrData),
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color.fromRGBO(230, 18, 14, 1),
//               ),
//               child: Text('Generate QR', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
