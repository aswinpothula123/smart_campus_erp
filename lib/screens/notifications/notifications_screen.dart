import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/notification_service.dart';
import '../../services/voice_service.dart';


class NotificationsScreen extends StatefulWidget {

  const NotificationsScreen({super.key});


  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();

}



class _NotificationsScreenState
    extends State<NotificationsScreen> {



  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VoiceService.instance.speak('Notifications.');
    });
  }



  final titleController =
      TextEditingController();



  final messageController =
      TextEditingController();





  @override
  void dispose() {

    titleController.dispose();

    messageController.dispose();

    super.dispose();

  }





  // ADD NOTIFICATION

  Future<void> addNotification() async {


    if(titleController.text.trim().isEmpty ||
       messageController.text.trim().isEmpty){

      return;

    }



    await _notificationService.addNotification(
      title: titleController.text.trim(),
      message: messageController.text.trim(),
    );



    titleController.clear();

    messageController.clear();


    if (!mounted) return;
    Navigator.pop(context);



  }






  // UPDATE NOTIFICATION

  Future<void> updateNotification(

      String id,

      ) async {


    await _notificationService.updateNotification(id, {
      'title': titleController.text.trim(),
      'message': messageController.text.trim(),
    });


    titleController.clear();

    messageController.clear();


    if (!mounted) return;
    Navigator.pop(context);


  }






  // DELETE NOTIFICATION

  Future<void> deleteNotification(

      String id

      ) async {


    await _notificationService.deleteNotification(id);


  }







  // ADD + EDIT DIALOG

  void showNotificationDialog({

    String? id,

    String? oldTitle,

    String? oldMessage,

  }) {



    titleController.text =
        oldTitle ?? "";


    messageController.text =
        oldMessage ?? "";




    showDialog(

        context: context,

        builder:(context){


          return AlertDialog(


            title: Text(

              id == null

                  ? "Add Notification"

                  : "Edit Notification",

            ),



            content:

            Column(

              mainAxisSize:
              MainAxisSize.min,


              children:[


                TextField(

                  controller:
                  titleController,


                  decoration:
                  const InputDecoration(

                    labelText:
                    "Title",

                  ),

                ),




                TextField(

                  controller:
                  messageController,


                  maxLines:
                  3,


                  decoration:
                  const InputDecoration(

                    labelText:
                    "Message",

                  ),

                ),



              ],


            ),





            actions:[



              TextButton(

                onPressed:(){

                  Navigator.pop(context);

                },


                child:
                const Text("Cancel"),


              ),





              ElevatedButton(


                onPressed:() async{


                  if(id == null){


                    await addNotification();


                  }

                  else{


                    await updateNotification(id);


                  }


                },


                child:

                Text(

                  id == null

                      ? "Save"

                      : "Update",

                ),


              )



            ],



          );


        }


    );

  }









  @override
  Widget build(BuildContext context) {


    return Scaffold(



      appBar: AppBar(


        title:
        const Text(
            "Notifications"
        ),



        backgroundColor:
        Colors.indigo,


        foregroundColor:
        Colors.white,


      ),





      floatingActionButton:


      FloatingActionButton(


        backgroundColor:
        Colors.indigo,


        foregroundColor:
        Colors.white,


        child:
        const Icon(Icons.add),



        onPressed:(){


          showNotificationDialog();


        },


      ),








      body:


      StreamBuilder<QuerySnapshot>(


        stream:

        firestore

            .collection("notifications")

            .orderBy(
            "createdAt",
            descending:true
        )

            .snapshots(),




        builder:(context,snapshot){





          if(snapshot.connectionState ==
              ConnectionState.waiting){


            return const Center(

              child:
              CircularProgressIndicator(),

            );


          }







          if(!snapshot.hasData ||
              snapshot.data!.docs.isEmpty){


            return const Center(


              child:

              Column(

                mainAxisAlignment:
                MainAxisAlignment.center,


                children:[


                  Icon(

                    Icons.notifications_off,

                    size:70,

                    color:Colors.grey,

                  ),



                  SizedBox(height:10),



                  Text(

                    "No Notifications",

                    style:
                    TextStyle(

                      fontSize:18,

                    ),

                  )


                ],


              ),


            );


          }








          return ListView.builder(


              padding:
              const EdgeInsets.all(12),



              itemCount:
              snapshot.data!.docs.length,



              itemBuilder:(context,index){



                final doc =
                snapshot.data!.docs[index];



                final data =
                doc.data()
                as Map<String,dynamic>;





                return Card(


                  elevation:4,


                  child:

                  ListTile(



                    leading:

                    const CircleAvatar(

                      child:
                      Icon(
                          Icons.notifications
                      ),

                    ),





                    title:

                    Text(

                      data["title"] ??
                          "",

                      style:
                      const TextStyle(

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),





                    subtitle:

                    Text(

                      data["message"] ??
                          "",

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



                            showNotificationDialog(


                              id:
                              doc.id,


                              oldTitle:
                              data["title"],


                              oldMessage:
                              data["message"],


                            );



                          },


                        ),





                        IconButton(


                          icon:

                          const Icon(

                              Icons.delete,

                              color:
                              Colors.red

                          ),



                          onPressed:(){



                            deleteNotification(

                                doc.id

                            );


                          },

                        )




                      ],


                    ),




                  ),



                );



              }


          );




        },


      ),


    );


  }


}
