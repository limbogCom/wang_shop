import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:wang_shop/database_helper.dart';
import 'package:wang_shop/member_model.dart';
import 'package:shared_preferences/shared_preferences.dart';



class MemberPage extends StatefulWidget {
  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {

  DatabaseHelper databaseHelper = DatabaseHelper.internal();

  var userID;

  List <Member>memberAll = [];
  bool isLoading = true;
  int perPage = 30;
  String act = "Member";

  getUser() async{

    var resUser = await databaseHelper.getList();
    setState(() {
      userID = resUser[0]['idUser'];
    });

    print(userID);

    final res = await http.get('https://wangpharma.com/API/member.php?userID=$userID&act=$act');

    if(res.statusCode == 200){

      setState(() {
        isLoading = false;

        var jsonData = json.decode(res.body);

        jsonData.forEach((products) => memberAll.add(Member.fromJson(products)));

        print(memberAll);

        return memberAll;

      });


    }else{
      throw Exception('Failed load Json');
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  _clearDB() async{
    //SharedPreferences preferences = await SharedPreferences.getInstance();
    //preferences.clear();
    await databaseHelper.removeAll();
    await databaseHelper.removeAllOrderFree();
    await databaseHelper.removeAllMember();
  }

  void _showDialogExit() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("แจ้งเตือน"),
          content: new Text("ยืนยันออกจากระบบ"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                _clearDB();
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                //Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? CircularProgressIndicator()
          : Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.green
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.account_circle, size: 60, color: Colors.white,),
                            Text('${memberAll[0].memberName}', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Text('ที่อยู่ร้าน : ${memberAll[0].memberAddress}', style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Text('สถานะรายการ', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Icon(Icons.beenhere, size: 40, color: Colors.grey,),
                                Text('ยืนยันรายการ')
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Icon(Icons.check_circle, size: 40, color: Colors.grey,),
                                Text('เตรียมจัดส่ง')
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Icon(Icons.local_shipping, size: 40, color: Colors.grey,),
                                Text('ระหว่างขนส่ง')
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Icon(Icons.comment, size: 40, color: Colors.grey,),
                                Text('ข้อเสนอแนะ')
                              ],
                            )
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      MaterialButton(
                        color: Colors.red,
                        textColor: Colors.white,
                        minWidth: double.infinity,
                        height: 50,
                        child: Text(
                          "ออกจากระบบ",
                          style: new TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        //onPressed: (){Navigator.pushReplacementNamed(context, '/Home');},
                        onPressed: () {
                          _showDialogExit();
                          //addToOrder();
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
