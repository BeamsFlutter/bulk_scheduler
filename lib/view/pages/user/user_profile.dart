

import 'package:flutter/material.dart';
import 'package:scheduler/controller/global/globalValues.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/styles/colors.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  //Global
  var g = Global();


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Row(),
            Container(
              decoration: boxBaseDecoration(white, 30),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(),
                  Icon(Icons.account_circle_sharp,color: subColor,size: g.wstrHeadFont+50,),
                  gapHC(10),
                  th(g.wstrUserCd.toString(),txtSubColor,g.wstrHeadFont),
                  tcn(g.wstrUserName.toString(),txtSubColor,g.wstrHeadFont),
                  lineS(),
                  Row(
                    children: [
                      Icon(Icons.account_balance,color: txtSubColor,size: g.wstrSubFont,),
                      gapWC(20),
                      tcn(g.wstrCompany +" | "+g.wstrYearcode, txtSubColor, g.wstrSubFont),
                    ],
                  ),
                  lineSC(5.0),
                  Row(
                    children: [
                      Icon(Icons.dashboard,color: txtSubColor,size: g.wstrSubFont,),
                      gapWC(20),
                      tcn("Beams Gas", txtSubColor, g.wstrSubFont),
                    ],
                  ),
                  lineSC(5.0),
                  Row(
                    children: [
                      Icon(Icons.mobile_friendly,color: txtSubColor,size: g.wstrSubFont,),
                      gapWC(20),
                      tcn("Version  ${g.wstrVersionName.toString()}", txtSubColor, g.wstrSubFont),
                    ],
                  ),
                  lineSC(5.0),
                  Row(
                    children: [
                      Icon(Icons.date_range_rounded,color: txtSubColor,size: g.wstrSubFont,),
                      gapWC(20),
                      tcn("30 09 2022", txtSubColor, g.wstrSubFont),
                    ],
                  ),
                  lineS(),
                  gapHC(30),
                  tcn('BEAMS', txtSubColor, g.wstrSubIconSize)
                ],
              ),
            )

        ],
      ),
    );
  }
}
