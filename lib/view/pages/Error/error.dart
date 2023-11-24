

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/styles/colors.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            children: [
            ],
          ),
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(),
              Image.asset("assets/gifs/nointernet.gif",width: 200,),
              tcn('Connection Lost !!!', grey, 15),
              gapHC(10),
              Bounce(
                duration: const Duration(milliseconds: 110),
                onPressed: (){
                  Get.back();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                  decoration: boxBaseDecoration(greyLight, 5),
                  child: tcn('Close', Colors.black.withOpacity(0.9), 10),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
