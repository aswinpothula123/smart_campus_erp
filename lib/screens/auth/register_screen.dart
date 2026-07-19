import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/voice_service.dart';
import 'login_screen.dart';


class RegisterScreen extends StatefulWidget {

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();

}



class _RegisterScreenState extends State<RegisterScreen> {


  final _formKey = GlobalKey<FormState>();

  final _authService = AuthService();


  final _nameController =
      TextEditingController();


  final _emailController =
      TextEditingController();


  final _passwordController =
      TextEditingController();



  String _role = "Admin";

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VoiceService.instance.speak('Registration.');
    });
  }




  @override
  void dispose() {

    _nameController.dispose();

    _emailController.dispose();

    _passwordController.dispose();

    super.dispose();

  }




  Future<void> _register() async {


    if (!_formKey.currentState!.validate()) {
      return;
    }


    VoiceService.instance.speak('Registering account.');
    setState(() {

      _isLoading = true;

    });



    try {


      await _authService.registerWithEmailAndPassword(

        email:
            _emailController.text.trim(),

        password:
            _passwordController.text.trim(),

        fullName:
            _nameController.text.trim(),

        role:
            _role,

      );



      if (!mounted) return;



      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content:
              Text("Registration successful"),

        ),

      );



      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) =>
              const LoginScreen(),

        ),

      );



    }



    catch (e) {


      if (!mounted) return;



      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:
              Text(e.toString()),

        ),

      );


    }



    finally {


      if (mounted) {


        setState(() {

          _isLoading = false;

        });


      }


    }


  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(

        title:
            const Text("Create Account"),

        backgroundColor:
            Colors.indigo,

        foregroundColor:
            Colors.white,

      ),



      body:

      Center(

        child:

        SingleChildScrollView(

          padding:
              const EdgeInsets.all(24),



          child:

          Form(

            key:
                _formKey,



            child:

            Column(

              children: [



                const Icon(

                  Icons.person_add,

                  size: 70,

                  color:
                      Colors.indigo,

                ),



                const SizedBox(height:20),



                TextFormField(

                  controller:
                      _nameController,


                  decoration:
                      const InputDecoration(

                    labelText:
                        "Full Name",

                    prefixIcon:
                        Icon(Icons.person),

                  ),


                  validator:(value){

                    if(value == null ||
                       value.trim().isEmpty){

                      return "Enter name";

                    }

                    return null;

                  },

                ),




                const SizedBox(height:12),




                TextFormField(

                  controller:
                      _emailController,


                  decoration:
                      const InputDecoration(

                    labelText:
                        "Email",

                    prefixIcon:
                        Icon(Icons.email),

                  ),


                  validator:(value){

                    if(value == null ||
                       value.trim().isEmpty){

                      return "Enter email";

                    }

                    return null;

                  },

                ),





                const SizedBox(height:12),




                TextFormField(

                  controller:
                      _passwordController,


                  obscureText:true,


                  decoration:
                      const InputDecoration(

                    labelText:
                        "Password",

                    prefixIcon:
                        Icon(Icons.lock),

                  ),



                  validator:(value){

                    if(value == null ||
                       value.length < 6){

                      return
                      "Minimum 6 characters";

                    }

                    return null;

                  },

                ),




                const SizedBox(height:12),




                DropdownButtonFormField<String>(


                  initialValue:
                      _role,


                  decoration:
                      const InputDecoration(

                    labelText:
                        "Role",

                    prefixIcon:
                        Icon(Icons.badge),

                  ),



                  items:


                  const [


                    DropdownMenuItem(

                      value:"Admin",

                      child:
                          Text("Admin"),

                    ),



                    DropdownMenuItem(

                      value:"Faculty",

                      child:
                          Text("Faculty"),

                    ),



                    DropdownMenuItem(

                      value:"Student",

                      child:
                          Text("Student"),

                    ),


                  ],




                  onChanged:(value){


                    setState(() {


                      _role =
                          value ?? "Admin";


                    });


                  },


                ),




                const SizedBox(height:25),





                SizedBox(


                  width:
                      double.infinity,

                  height:
                      50,



                  child:


                  ElevatedButton(


                    onPressed:

                    _isLoading
                    ? null
                    : _register,



                    child:


                    _isLoading

                    ?

                    const CircularProgressIndicator()

                    :

                    const Text(
                      "Register"
                    ),


                  ),


                )



              ],


            ),


          ),


        ),


      ),


    );


  }



}
