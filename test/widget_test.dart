import 'package:flutter_test/flutter_test.dart';

import 'package:smart_campus_erp/app.dart';


void main() {

  testWidgets(
    'Smart Campus ERP test',
    (WidgetTester tester) async {


      await tester.pumpWidget(

        const SmartCampusApp(),

      );


      expect(

        find.text("Smart Campus ERP"),

        findsOneWidget,

      );


    },
  );

}