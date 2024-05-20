// import 'package:flutter/material.dart';
// import 'package:mydoc/QRDisplayScreen.dart';
//
//
// class NewRequestScreen extends StatelessWidget {
//   final String userName;
//
//   NewRequestScreen({required this.userName});
//
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController toController = TextEditingController();
//     TextEditingController documentNumberController = TextEditingController();
//     TextEditingController subController = TextEditingController();
//
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
//               'From: $userName',
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
//               onPressed: () {
//                 String documentNumber = documentNumberController.text;
//                 String sub = subController.text;
//                 String to = toController.text;
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
//                 backgroundColor: Color.fromRGBO(230, 18, 14, 1), // Set button color
//               ),
//               child: Text('Generate QR', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:mydoc/QRDisplayScreen.dart';

class NewRequestScreen extends StatelessWidget {
  final String userName;

  NewRequestScreen({required this.userName});

  @override
  Widget build(BuildContext context) {
    TextEditingController toController = TextEditingController();
    TextEditingController documentNumberController = TextEditingController();

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
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () async {
                String documentNumber = documentNumberController.text;
                String to = toController.text;

                // Correct MongoDB URI
                const mongoUri = "mongodb+srv://chandirasegaran:25032002@myangadi.bxernfz.mongodb.net/?retryWrites=true&w=majority&appName=MyAngadi";

                try {
                  // Connect to MongoDB
                  var db = await mongo.Db.create(mongoUri);
                  await db.open();

                  var collection = db.collection('mydoc');

                  // Save data to MongoDB
                  await collection.insert({
                    'from': userName,
                    'to': to,
                    'documentNumber': documentNumber,
                  });

                  await db.close();

                  // Generate QR code data
                  String qrData = 'Document Number: $documentNumber';

                  // Navigate to QRDisplayScreen and pass qrData
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QRDisplayScreen(qrData: qrData),
                    ),
                  );
                } catch (e) {
                  print('MongoDB Error: $e');
                  // Handle error (e.g., show a snackbar or alert)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to save request: $e'))
                  );
                }
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
