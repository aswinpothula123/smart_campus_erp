import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../models/student.dart';


class StudentIdCardScreen extends StatelessWidget {

  final Student student;


  const StudentIdCardScreen({
    super.key,
    required this.student,
  });



  @override
  Widget build(BuildContext context) {


    final String qrData = '''
SMART CAMPUS ERP
PACE Autonomous College Ongole

Name : ${student.name}
Roll No : ${student.rollNo}
Department : ${student.department}
Semester : ${student.semester}
Email : ${student.email}
Phone : ${student.phone}
CGPA : ${student.cgpa}
''';



    return Scaffold(


      backgroundColor:
      Colors.grey.shade100,


      appBar:

      AppBar(

        title:
        const Text(
          "Student ID Card",
        ),


        centerTitle:true,


        backgroundColor:
        Colors.indigo,


        foregroundColor:
        Colors.white,

      ),




      body:

      Center(


        child:

        SingleChildScrollView(


          child:

          Card(


            elevation:10,


            margin:
            const EdgeInsets.all(20),



            shape:

            RoundedRectangleBorder(

              borderRadius:
              BorderRadius.circular(25),

            ),




            child:

            Container(


              width:350,


              padding:
              const EdgeInsets.all(20),



              child:

              Column(


                mainAxisSize:
                MainAxisSize.min,



                children:[




                  // COLLEGE LOGO


                  CircleAvatar(

                    radius:35,


                    backgroundColor:
                    Colors.indigo.shade100,


                    child:

                    Image.asset(

                      "assets/images/pace_logo.png",


                      width:60,


                      height:60,


                      errorBuilder:
                      (context,error,stack){


                        return const Icon(

                          Icons.school,

                          size:40,

                          color:
                          Colors.indigo,

                        );

                      },


                    ),


                  ),




                  const SizedBox(height:10),





                  const Text(

                    "PACE INSTITUTE OF TECHNOLOGY AND SCIENCES",

                    textAlign:
                    TextAlign.center,


                    style:

                    TextStyle(

                      fontSize:14,

                      fontWeight:
                      FontWeight.bold,

                      color:
                      Colors.indigo,

                    ),

                  ),



                  const Text(

                    "Ongole, Andhra Pradesh",

                    style:

                    TextStyle(

                      color:
                      Colors.grey,

                    ),

                  ),



                  const Divider(),





                  // STUDENT PHOTO


                  student.photoUrl.isNotEmpty

                      ?

                  CircleAvatar(

                    radius:50,


                    backgroundImage:

                    NetworkImage(

                      student.photoUrl,

                    ),


                  )


                      :

                  CircleAvatar(

                    radius:50,


                    backgroundColor:
                    Colors.indigo,


                    child:

                    Text(

                      student.name.isEmpty
                          ?
                      "?"
                          :
                      student.name[0]
                          .toUpperCase(),


                      style:

                      const TextStyle(

                        color:
                        Colors.white,

                        fontSize:40,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),

                  ),





                  const SizedBox(height:15),




                  Text(

                    student.name,


                    style:

                    const TextStyle(

                      fontSize:22,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),





                  const SizedBox(height:8),




                  Chip(

                    backgroundColor:
                    Colors.indigo,


                    label:

                    Text(

                      student.department,


                      style:

                      const TextStyle(

                        color:
                        Colors.white,

                      ),

                    ),

                  ),





                  const SizedBox(height:15),





                  buildDetail(

                    Icons.badge,

                    "Roll Number",

                    student.rollNo,

                  ),




                  buildDetail(

                    Icons.school,

                    "Semester",

                    student.semester,

                  ),




                  buildDetail(

                    Icons.email,

                    "Email",

                    student.email,

                  ),




                  buildDetail(

                    Icons.phone,

                    "Phone",

                    student.phone,

                  ),





                  const SizedBox(height:20),





                  // QR CODE


                  Container(

                    padding:
                    const EdgeInsets.all(15),


                    decoration:

                    BoxDecoration(

                      color:
                      Colors.white,


                      borderRadius:
                      BorderRadius.circular(15),


                      border:

                      Border.all(

                        color:
                        Colors.indigo,

                      ),

                    ),



                    child:

                    QrImageView(

                      data:
                      qrData,


                      size:180,


                    ),


                  ),




                  const SizedBox(height:15),





                  const Text(

                    "Scan QR to verify student details",

                    style:

                    TextStyle(

                      color:
                      Colors.grey,

                      fontSize:13,

                    ),

                  ),





                  const SizedBox(height:10),




                  const Text(

                    "SMART CAMPUS ERP",

                    style:

                    TextStyle(

                      color:
                      Colors.indigo,


                      fontSize:16,


                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),



                ],


              ),


            ),


          ),


        ),


      ),


    );

  }





  Widget buildDetail(
      IconData icon,
      String title,
      String value,
      ){

    return Padding(

      padding:

      const EdgeInsets.symmetric(
        vertical:5,
      ),


      child:

      Row(

        children:[


          Icon(

            icon,

            color:
            Colors.indigo,

            size:20,

          ),



          const SizedBox(width:10),




          Expanded(

            child:

            Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,


              children:[


                Text(

                  title,


                  style:

                  const TextStyle(

                    color:
                    Colors.grey,

                    fontSize:12,

                  ),

                ),




                Text(

                  value.isEmpty
                      ?
                  "Not Available"
                      :
                  value,


                  style:

                  const TextStyle(

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),



              ],


            ),

          )

        ],


      ),


    );

  }

}
