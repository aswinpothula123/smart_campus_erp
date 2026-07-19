import 'package:flutter/material.dart';

import '../../services/voice_service.dart';


class DashboardScreen extends StatelessWidget {

  const DashboardScreen({super.key});


  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      VoiceService.instance.speak('Dashboard.');
    });


    return Scaffold(


      appBar: AppBar(

        title: const Text(
          "Smart Campus ERP",
        ),

        centerTitle: true,

        backgroundColor:
            Colors.indigo,

        foregroundColor:
            Colors.white,

      ),



      drawer: Drawer(

        child: ListView(

          padding:
              EdgeInsets.zero,


          children: [


            const DrawerHeader(

              decoration:
                  BoxDecoration(

                color:
                    Colors.indigo,

              ),


              child:

              Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,


                children: [


                  CircleAvatar(

                    radius:30,

                    child:
                        Icon(Icons.school),

                  ),


                  SizedBox(height:10),


                  Text(

                    "PACE Smart Campus",

                    style:
                    TextStyle(

                      color:
                      Colors.white,

                      fontSize:
                      18,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),


                  Text(

                    "ERP Management System",

                    style:
                    TextStyle(

                      color:
                      Colors.white70,

                    ),

                  )


                ],

              ),

            ),



            _drawerItem(
              context,
              Icons.dashboard,
              "Dashboard",
              "/dashboard",
            ),



            _drawerItem(
              context,
              Icons.people,
              "Students",
              "/students",
            ),



            _drawerItem(
              context,
              Icons.person,
              "Teachers",
              "/teachers",
            ),



            _drawerItem(
              context,
              Icons.fact_check,
              "Attendance",
              "/attendance",
            ),



            _drawerItem(
              context,
              Icons.currency_rupee,
              "Fees",
              "/fees",
            ),



            _drawerItem(
              context,
              Icons.menu_book,
              "Courses",
              "/courses",
            ),



            _drawerItem(
              context,
              Icons.description,
              "Reports",
              "/reports",
            ),



            _drawerItem(
              context,
              Icons.notifications,
              "Notifications",
              "/notifications",
            ),



            _drawerItem(
              context,
              Icons.person_outline,
              "Profile",
              "/profile",
            ),



            _drawerItem(
              context,
              Icons.settings,
              "Settings",
              "/settings",
            ),


          ],


        ),

      ),





      body:

      SingleChildScrollView(


        padding:
        const EdgeInsets.all(16),



        child:

        Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children: [



                  const Text(

              "Welcome Admin 👋",

              style:
              TextStyle(

                fontSize:
                24,

                fontWeight:
                FontWeight.bold,

              ),

            ),



            const SizedBox(height:5),



            Text(

              "Manage your complete campus digitally",

              style:

              TextStyle(

                color:
                Colors.grey[600],

              ),

            ),




            const SizedBox(height:25),




            GridView.count(

              shrinkWrap:
              true,

              physics:
              const NeverScrollableScrollPhysics(),


              crossAxisCount:
              2,


              crossAxisSpacing:
              15,


              mainAxisSpacing:
              15,



              children: [



                _dashboardCard(

                  context,

                  Icons.people,

                  "Students",

                  Colors.blue,

                  "/students",

                ),




                _dashboardCard(

                  context,

                  Icons.person,

                  "Teachers",

                  Colors.green,

                  "/teachers",

                ),





                _dashboardCard(

                  context,

                  Icons.fact_check,

                  "Attendance",

                  Colors.orange,

                  "/attendance",

                ),





                _dashboardCard(

                  context,

                  Icons.currency_rupee,

                  "Fees",

                  Colors.red,

                  "/fees",

                ),





                _dashboardCard(

                  context,

                  Icons.menu_book,

                  "Courses",

                  Colors.purple,

                  "/courses",

                ),





                _dashboardCard(

                  context,

                  Icons.description,

                  "Reports",

                  Colors.teal,

                  "/reports",

                ),





                _dashboardCard(

                  context,

                  Icons.notifications,

                  "Notifications",

                  Colors.amber,

                  "/notifications",

                ),





                _dashboardCard(

                  context,

                  Icons.settings,

                  "Settings",

                  Colors.grey,

                  "/settings",

                ),



              ],


            ),



          ],


        ),


      ),



    );


  }






  Widget _dashboardCard(

      BuildContext context,

      IconData icon,

      String title,

      Color color,

      String route,

      ) {


    return InkWell(


      onTap: (){

        VoiceService.instance.speak('Opening $title.');


        Navigator.pushNamed(
          context,
          route,
        );


      },


      child:

      Card(


        elevation:
        5,


        shape:
        RoundedRectangleBorder(

          borderRadius:
          BorderRadius.circular(18),

        ),



        child:

        Column(

          mainAxisAlignment:
          MainAxisAlignment.center,


          children: [



            Icon(

              icon,

              size:
              45,

              color:
              color,

            ),



            const SizedBox(height:12),



            Text(

              title,

              style:
              const TextStyle(

                fontSize:
                16,

                fontWeight:
                FontWeight.bold,

              ),

            ),


          ],


        ),


      ),


    );


  }






  Widget _drawerItem(

      BuildContext context,

      IconData icon,

      String title,

      String route,

      ){


    return ListTile(


      leading:
      Icon(icon),


      title:
      Text(title),


      onTap: (){

        VoiceService.instance.speak(
          title == 'Dashboard' ? 'Dashboard.' : 'Opening $title.',
        );


        Navigator.pop(context);


        Navigator.pushNamed(
            context,
            route
        );


      },


    );


  }



}
