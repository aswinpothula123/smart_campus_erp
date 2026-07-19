import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/attendance_service.dart';
import '../../services/voice_service.dart';


class AttendanceScreen extends StatefulWidget {

  const AttendanceScreen({
    super.key,
  });


  @override
  State<AttendanceScreen> createState() =>
      _AttendanceScreenState();

}



class _AttendanceScreenState extends State<AttendanceScreen> {


  final AttendanceService _attendanceService =
      AttendanceService();


  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;



  String? selectedStudentId;

  Map<String,dynamic>? selectedStudent;


  String attendanceStatus = "Present";



  late Stream<QuerySnapshot> studentStream;



  @override
  void initState(){

    super.initState();

    studentStream =
        firestore
        .collection("students")
        .snapshots();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VoiceService.instance.speak('Attendance.');
    });

  }





  Future<void> saveAttendance() async {


    if(selectedStudentId == null){


      if (!mounted) return;

      ScaffoldMessenger.of(context)
      .showSnackBar(

        const SnackBar(
          content:
          Text(
            "Please select student first",
          ),

          backgroundColor:
          Colors.red,
        ),

      );


      return;

    }




    final messenger = ScaffoldMessenger.of(context);

    try{


      await _attendanceService.recordAttendance(

        selectedStudentId!,

        DateTime.now()
        .toString()
        .split(" ")[0],

        attendanceStatus,

      );



      if (!mounted) return;

      messenger
      .showSnackBar(

        const SnackBar(

          content:
          Text(
            "Attendance Saved Successfully",
          ),

          backgroundColor:
          Colors.green,

        ),

      );



    }
    catch(e){


      if (!mounted) return;

      messenger
      .showSnackBar(

        SnackBar(

          content:
          Text(
            e.toString(),
          ),

          backgroundColor:
          Colors.red,

        ),

      );


    }


  }





  @override
  Widget build(BuildContext context){


    return Scaffold(


      backgroundColor:
      Colors.grey.shade100,



      appBar: AppBar(

        title:
        const Text(
          "Attendance",
        ),

        backgroundColor:
        Colors.indigo,

        foregroundColor:
        Colors.white,

      ),




      body:

      Padding(

        padding:
        const EdgeInsets.all(16),


        child:

        Column(

          children:[




            StreamBuilder<QuerySnapshot>(

              stream:
              studentStream,


              builder:
              (context,snapshot){


                if(!snapshot.hasData){

                  return const CircularProgressIndicator();

                }



                final students =
                snapshot.data!.docs;



                return DropdownButtonFormField<String>(


                  initialValue:
                  selectedStudentId,


                  decoration:
                  const InputDecoration(

                    labelText:
                    "Select Student",

                    border:
                    OutlineInputBorder(),

                  ),




                  items:

                  students.map((doc){


                    final data =
                    doc.data()
                    as Map<String,dynamic>;



                    return DropdownMenuItem(

                      value:
                      doc.id,


                      child:
                      Text(

                        "${data["name"]} - ${data["rollNo"]}",

                      ),

                    );


                  }).toList(),




                  onChanged:(value){


                    final doc =
                    students.firstWhere(
                    (d)=>d.id==value);



                    setState((){


                      selectedStudentId =
                      value;



                      selectedStudent =
                      doc.data()
                      as Map<String,dynamic>;


                    });


                  },


                );


              },


            ),




            const SizedBox(height:20),




            DropdownButtonFormField<String>(


              initialValue:
              attendanceStatus,


              decoration:
              const InputDecoration(

                labelText:
                "Status",

                border:
                OutlineInputBorder(),

              ),



              items:
              const [


                DropdownMenuItem(

                  value:
                  "Present",

                  child:
                  Text(
                    "Present",
                  ),

                ),



                DropdownMenuItem(

                  value:
                  "Absent",

                  child:
                  Text(
                    "Absent",
                  ),

                ),


              ],



              onChanged:(value){

                setState((){

                  attendanceStatus=value!;

                });

              },


            ),




            const SizedBox(height:20),




            SizedBox(


              width:
              double.infinity,


              height:
              55,



              child:

              ElevatedButton.icon(


                onPressed:
                saveAttendance,


                icon:
                const Icon(
                  Icons.save,
                ),



                label:
                const Text(
                  "Save Attendance",
                ),



                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  Colors.indigo,

                  foregroundColor:
                  Colors.white,

                ),


              ),

            ),




            const SizedBox(height:20),




            Expanded(


              child:

              StreamBuilder<QuerySnapshot>(


                stream:
                _attendanceService
                .getAttendanceStream(),



                builder:
                (context,snapshot){


                  if(!snapshot.hasData){

                    return const Center(

                      child:
                      CircularProgressIndicator(),

                    );

                  }



                  final records =
                  snapshot.data!.docs;




                  return ListView.builder(


                    itemCount:
                    records.length,



                    itemBuilder:(context,index){


                      final data =
                      records[index].data()
                      as Map<String,dynamic>;



                      return Card(


                        child:
                        ListTile(


                          title:
                          Text(
                            data["studentName"] ?? "",
                          ),


                          subtitle:
                          Text(

                            "Roll : ${data["rollNo"]}\n"
                            "Status : ${data["status"]}\n"
                            "Date : ${data["date"]}",

                          ),


                        ),

                      );


                    },


                  );


                },


              ),


            )



          ],


        ),


      ),



    );


  }


}
