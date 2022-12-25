import 'package:flutter/material.dart';

import 'package:todo/screens/todoApp/main_screen.dart';

void main()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp ({Key? key}) : super(key: key);


@override
  Widget build (BuildContext context)
{
    return MaterialApp
      (
      debugShowCheckedModeBanner: false ,
      home: homeLayout(),
     color:  Colors.blue.shade900,
    ) ;
}
}
