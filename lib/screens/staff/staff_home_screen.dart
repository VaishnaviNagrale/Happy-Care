// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:happycare/screens/staff/add_patient.dart';

class StaffHomeScreen extends StatelessWidget {
  final String staff_name;
  const StaffHomeScreen({super.key, required this.staff_name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Staff Name: $staff_name',
           style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Image(
                image: AssetImage('assets/images/hospital_logo.jpg'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddPatientScreen(staff_name: staff_name),
                  ),
                );
              },
              child: const Text(
                'Add New Patient',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Discharge Patient',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
