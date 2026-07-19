class Fee {

  final String id;
  final String studentId;
  final double totalFee;
  final double paidFee;
  final double pendingFee;
  final String status;
  final String paymentDate;


  Fee({

    required this.id,
    required this.studentId,
    required this.totalFee,
    required this.paidFee,
    required this.pendingFee,
    required this.status,
    required this.paymentDate,

  });



  factory Fee.fromMap(
      String id,
      Map<String,dynamic> data
      ){

    return Fee(

      id: id,

      studentId:
      data['studentId'] ?? '',


      totalFee:
      (data['totalFee'] ?? 0).toDouble(),


      paidFee:
      (data['paidFee'] ?? 0).toDouble(),


      pendingFee:
      (data['pendingFee'] ?? 0).toDouble(),


      status:
      data['status'] ?? 'Pending',


      paymentDate:
      data['paymentDate'] ?? '',

    );

  }



  Map<String,dynamic> toMap(){

    return {

      "studentId": studentId,

      "totalFee": totalFee,

      "paidFee": paidFee,

      "pendingFee": pendingFee,

      "status": status,

      "paymentDate": paymentDate,

    };

  }

}