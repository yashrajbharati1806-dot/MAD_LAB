import 'package:flutter/material.dart';
import 'package:mad_lab/configurations.dart';

class Content extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ContentState();
}

class ContentState extends State<Content> {
  // Helper to calculate totals from the "database"
  int get totalPresent =>
      Configurations.attendance.where((a) => a[1] == 1).length;
  int get totalAbsent =>
      Configurations.attendance.where((a) => a[1] == 0).length;

  Future<void> _showConfirmationDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Change'),
          content: Text(
              'Are you sure you want to change attendance for ${Configurations.attendance[index][0]}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                setState(() {
                  // Live update to the database
                  Configurations.attendance[index][1] =
                      Configurations.attendance[index][1] == 1 ? 0 : 1;
                });
                Navigator.of(context).pop();
              },
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
        leading: const BackButton(),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Attendance Records"),
      ),
      body: Column(
        children: [
          // Live Summary Header
          Container(
            padding: const EdgeInsets.all(15),
            color: Colors.deepPurple.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Present: $totalPresent",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
                Text("Absent: $totalAbsent",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: Configurations.attendance.length,
              itemBuilder: (context, index) {
                String date = Configurations.attendance[index][0].toString();
                bool isPresent = Configurations.attendance[index][1] == 1;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    onTap: () => _showConfirmationDialog(index),
                    title: Text(date, style: const TextStyle(fontSize: 18)),
                    trailing: CircleAvatar(
                      backgroundColor: isPresent ? Colors.green : Colors.red,
                      child: Text(
                        isPresent ? "P" : "A",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
