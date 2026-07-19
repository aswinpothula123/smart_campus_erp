import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/fee_service.dart';
import '../../services/student_service.dart';
import '../../services/voice_service.dart';



class FeesScreen extends StatefulWidget {

  const FeesScreen({super.key});


  @override
  State<FeesScreen> createState() =>
      _FeesScreenState();

}





class _FeesScreenState extends State<FeesScreen> {


  final FeeService _feeService =
      FeeService();


  final StudentService _studentService =
      StudentService();



  String department = "All";



  String? selectedStudentId;


  Map<String,dynamic>? selectedStudent;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VoiceService.instance.speak('Fees Management.');
    });
  }





  void openFeeDialog(
      {
        DocumentSnapshot? doc
      }

      ){



    final data =
    doc?.data()
    as Map<String,dynamic>?;




    final total =
    TextEditingController(
        text:data?["totalAmount"]?.toString() ?? ""
    );



    final paid =
    TextEditingController(
        text:data?["amountPaid"]?.toString() ?? ""
    );



    if(doc!=null){

      selectedStudentId =
      data?["studentId"];

      selectedStudent={

        "name":
        data?["studentName"],

        "rollNo":
        data?["rollNo"],

        "department":
        data?["department"],

        "semester":
        data?["semester"],

      };

    }





    showDialog(

        context:context,

        builder:(context){


          return AlertDialog(



            title:

            Text(

              doc==null

                  ?

              "Create Fee"

                  :

              "Update Fee",

            ),





            content:

            SingleChildScrollView(

              child:

              Column(

                children:[




                  if(doc==null)

                    StreamBuilder<QuerySnapshot>(


                      stream:

                      _studentService
                          .getStudents(),



                      builder:(context,snapshot){



                        if(!snapshot.hasData){

                          return const CircularProgressIndicator();

                        }




                        return DropdownButtonFormField<String>(



                          hint:

                          const Text(
                              "Select Student"
                          ),



                          items:


                          snapshot.data!.docs.map((student){


                            final data =
                            student.data()
                            as Map<String,dynamic>;



                            return DropdownMenuItem(


                              value:
                              student.id,


                              child:

                              Text(

                                "${data["name"]} - ${data["rollNo"]}"

                              ),


                            );


                          }).toList(),





                          onChanged:(value){


                            selectedStudentId=value;



                            final selectedDoc =

                            snapshot.data!.docs.firstWhere(

                                    (e)=>e.id==value

                            );



                            selectedStudent =

                            selectedDoc.data()

                            as Map<String,dynamic>;



                            setState((){});


                          },



                        );


                      },

                    ),





                  if(selectedStudent!=null)

                    Card(

                      child:

                      ListTile(

                        title:

                        Text(

                          selectedStudent!["name"] ?? ""

                        ),


                        subtitle:

                        Text(

                          "Roll: ${selectedStudent!["rollNo"]}\nDepartment: ${selectedStudent!["department"]}"

                        ),


                      ),

                    ),





                  TextField(

                    controller:total,


                    keyboardType:
                    TextInputType.number,


                    decoration:

                    const InputDecoration(

                      labelText:
                      "Total Fee",

                    ),

                  ),





                  TextField(

                    controller:paid,


                    keyboardType:
                    TextInputType.number,


                    decoration:

                    const InputDecoration(

                      labelText:
                      "Paid Amount",

                    ),

                  ),



                ],


              ),


            ),





            actions:[



              TextButton(

                  onPressed:(){

                    Navigator.pop(context);

                  },

                  child:

                  const Text("Cancel")

              ),





              ElevatedButton(


                  onPressed:() async{

                    VoiceService.instance.speak('Saving data.');



                    double totalAmount =

                    double.tryParse(
                        total.text
                    ) ?? 0;



                    double paidAmount =

                    double.tryParse(
                        paid.text
                    ) ?? 0;




                    double pending =

                    totalAmount-paidAmount;




                    String status;



                    if(pending<=0){

                      status="Paid";

                    }

                    else if(paidAmount>0){

                      status="Partial";

                    }

                    else{

                      status="Pending";

                    }





                    Map<String,dynamic> feeData={


                      "studentId":
                      selectedStudentId,


                      "studentName":

                      selectedStudent?["name"],



                      "rollNo":

                      selectedStudent?["rollNo"],



                      "department":

                      selectedStudent?["department"],



                      "semester":

                      selectedStudent?["semester"],



                      "totalAmount":

                      totalAmount,



                      "amountPaid":

                      paidAmount,



                      "pendingAmount":

                      pending,



                      "status":

                      status,


                    };






                    if(doc==null){



                      await _feeService
                          .recordFeePayment(
                          feeData
                      );



                    }

                    else{



                      await _feeService
                          .updateFeePayment(

                          doc.id,

                          feeData

                      );


                    }






                    if(context.mounted){

                      Navigator.pop(context);

                    }



                  },



                  child:

                  Text(

                      doc==null

                          ?

                      "Save"

                          :

                      "Update"

                  )



              )



            ],



          );


        }

    );


  }









  @override
  Widget build(BuildContext context) {



    return Scaffold(



      appBar:

      AppBar(

        title:

        const Text(
            "Fees Management"
        ),


        backgroundColor:
        Colors.indigo,


        foregroundColor:
        Colors.white,


      ),







      floatingActionButton:

      FloatingActionButton.extended(


        onPressed:(){

          VoiceService.instance.speak('Add fee record.');

          openFeeDialog();

        },


        label:

        const Text(
            "Add Fee"
        ),


        icon:

        const Icon(
            Icons.add
        ),


      ),







      body:

      StreamBuilder<QuerySnapshot>(


          stream:

          _feeService
              .getFeesByDepartment(
              department
          ),



          builder:(context,snapshot){



            if(!snapshot.hasData){


              return const Center(

                child:
                CircularProgressIndicator(),

              );


            }





            final docs =
            snapshot.data!.docs;



            if(docs.isEmpty){


              return const Center(

                child:

                Text(
                    "No Fee Records"
                ),

              );


            }





            return ListView.builder(



              itemCount:
              docs.length,



              itemBuilder:(context,index){



                final doc =
                docs[index];



                final data =

                doc.data()

                as Map<String,dynamic>;





                return Card(



                  child:

                  ListTile(



                    title:

                    Text(

                        data["studentName"] ?? ""

                    ),




                    subtitle:

                    Text(

                        "Paid ₹${data["amountPaid"]}\nPending ₹${data["pendingAmount"]}"

                    ),





                    trailing:

                    Row(

                      mainAxisSize:
                      MainAxisSize.min,

                      children:[



                        IconButton(

                          icon:

                          const Icon(
                              Icons.edit
                          ),


                          onPressed:(){

                            VoiceService.instance.speak('Opening editor.');

                            openFeeDialog(
                                doc:doc
                            );

                          },

                        ),





                        IconButton(

                          icon:

                          const Icon(
                              Icons.delete,
                              color:Colors.red
                          ),



                          onPressed:() async{

                            VoiceService.instance.speak('Deleting record.');


                            await _feeService
                                .deleteFeePayment(
                                doc.id
                            );


                          },


                        ),



                      ],


                    ),




                  ),



                );


              },


            );




          }


      ),



    );


  }


}
