import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/student.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  Student myStudent = Student(fname: '', lname: '', email: '', score: '');

  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final CollectionReference _studentCollection = FirebaseFirestore.instance.collection("student");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Error")),
            body: Center(child: Text("${snapshot.error}")),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("แบบฟอร์มบันทึกคะแนนสอบ"),
            ),
            body: Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("ชื่อ", style: TextStyle(fontSize: 20)),
                      TextFormField(
                        // เพิ่ม .call ต่อท้าย
                        validator: RequiredValidator(errorText: "กรุณาป้อนชื่อด้วยครับ").call,
                        onSaved: (fname) {
                          myStudent.fname = fname!;
                        },
                      ),
                      const SizedBox(height: 15),
                      const Text("นามสกุล", style: TextStyle(fontSize: 20)),
                      TextFormField(
                        // เพิ่ม .call ต่อท้าย
                        validator: RequiredValidator(errorText: "กรุณาป้อนนามสกุลด้วยครับ").call,
                        onSaved: (lname) {
                          myStudent.lname = lname!;
                        },
                      ),
                      const SizedBox(height: 15),
                      const Text("อีเมล์", style: TextStyle(fontSize: 20)),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        // เพิ่ม .call ต่อท้าย MultiValidator
                        validator: MultiValidator([
                          RequiredValidator(errorText: "กรุณาป้อนอีเมล์ด้วยครับ"),
                          EmailValidator(errorText: "รูปแบบอีเมล์ไม่ถูกต้อง"),
                        ]).call,
                        onSaved: (email) {
                          myStudent.email = email!;
                        },
                      ),
                      const SizedBox(height: 15),
                      const Text("คะแนน", style: TextStyle(fontSize: 20)),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        // เพิ่ม .call ต่อท้าย
                        validator: RequiredValidator(errorText: "กรุณาป้อนคะแนนสอบด้วยครับ").call,
                        onSaved: (score) {
                          myStudent.score = score!;
                        },
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState?.save();
                              
                              // บันทึกลง Firebase
                              await _studentCollection.add({
                                "fname": myStudent.fname,
                                "lname": myStudent.lname,
                                "email": myStudent.email,
                                "score": myStudent.score,
                              });
                              
                              formKey.currentState?.reset();
                            }
                          },
                          child: const Text("บันทึก", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}