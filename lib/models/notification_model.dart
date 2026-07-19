class NotificationModel {

  final String id;
  final String title;
  final String message;
  final String date;


  NotificationModel({

    required this.id,
    required this.title,
    required this.message,
    required this.date,

  });


  factory NotificationModel.fromMap(
      String id,
      Map<String,dynamic> data
      ){

    return NotificationModel(

      id: id,

      title: data['title'] ?? '',

      message: data['message'] ?? '',

      date: data['date'] ?? '',

    );

  }



  Map<String,dynamic> toMap(){

    return {

      "title": title,
      "message": message,
      "date": date,

    };

  }

}