// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoctorsHomeScreen extends StatelessWidget {
  final String userEmail;
  const DoctorsHomeScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    Future<List<String>> fetchPatientData(String doctor_name) async {
      final firestore = FirebaseFirestore.instance;
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('patient_assign_to_doctor')
          .where('doctorName', isEqualTo: doctor_name)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<String> patients = [];

        for (QueryDocumentSnapshot<Map<String, dynamic>> doc
            in querySnapshot.docs) {
          final userData = doc.data();
          final patientname = userData['patientName'];
          patients.add(patientname);
        }

        return patients;
      } else {
        // No patients assigned to the doctor
        return [];
      }
    }

    Future<List<String>> fetchDoctorData(String userEmail) async {
      final firestore = FirebaseFirestore.instance;
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        final doctor_name = userData['name'];

        // Now you can check the userType and take appropriate actions.
        try {
          return fetchPatientData(doctor_name);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.blueGrey,
              content: Text(
                'User with $doctor_name not found for that email',
                style: const TextStyle(fontSize: 18.0, color: Colors.amber),
              ),
            ),
          );
        }
      }
      return [''];
    }

    return FutureBuilder<List<String>>(
        future: fetchDoctorData(userEmail),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Display a loading indicator.
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No patient assigned yet.');
          } else {
            List<String>? patients = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Patients Assigned',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                centerTitle: true,
              ),
              body: ListView.builder(
                itemCount: patients!.length,
                itemBuilder: (context, index) {
                  return Patient_List(
                    patient_name: patients[index],
                  );
                },
              ),
            );
          }
        });
  }
}

class Patient_List extends StatelessWidget {
  final String patient_name;
  const Patient_List({
    super.key,
    required this.patient_name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          border: Border.all(
        width: 2,
        color: Colors.black,
      )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: Image.asset('assets/images/child.png'),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              patient_name,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
