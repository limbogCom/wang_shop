import 'package:flutter/material.dart';
import 'package:wang_shop/database_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  DatabaseHelper databaseHelper = DatabaseHelper.internal();

  List orders = [];

  List units = [];
  String _currentUnit;

  int selectedRadioTileShip;
  int selectedRadioTilePay;

  getOrderAll() async{
    var res = await databaseHelper.getOrder();
    print(res);

    setState(() {
      orders = res;
    });
  }

  showToastRemove(){
    Fluttertoast.showToast(
        msg: "ลบรายการแล้ว",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3
    );
  }

  saveEditOrderDialog(id, unit, amount) async {
    Map order = {
      'id': id,
      'unit': unit,
      'amount': amount,
    };
    await databaseHelper.updateOrder(order);
    getOrderAll();
  }

  editOrderDialog(order){

    units = [];

    //if(_currentUnit.isEmpty){
      _currentUnit = order['unit'].toString();
    //}else{
      //_currentUnit = this._currentUnit;
    //}

    if(order['unit1'].toString() != "NULL"){
      units.add(order['unit1'].toString());
    }
    if(order['unit2'].toString() != "NULL"){
      units.add(order['unit2'].toString());
    }
    if(order['unit3'].toString() != "NULL"){
      units.add(order['unit3'].toString());
    }

    print(_currentUnit);
    print(units);

    TextEditingController editAmount = TextEditingController();

    editAmount.text = order['amount'].toString();

    return showDialog(context: context, builder: (context) {
        return SimpleDialog(
          title: Text('แก้ไขรายการ'),
          children: <Widget>[
            //Text('จำนวน'),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "จำนวน",
              ),
              keyboardType: TextInputType.number,
              controller: editAmount,
            ),

            Padding(
              padding: EdgeInsets.all(10),
              child: DropdownButton(
                hint: Text("เลือกหน่วยสินค้า",style: TextStyle(fontSize: 18)),
                items: units.map((dropDownStringItem){
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem, style: TextStyle(fontSize: 18)),
                  );
                }).toList(),
                onChanged: (newValueSelected){
                  _onDropDownItemSelected(newValueSelected);
                  print(this._currentUnit);

                },
                value: _currentUnit,

              ),
            ),

            SimpleDialogOption(
              onPressed: (){

                    saveEditOrderDialog(order['id'],this._currentUnit,editAmount.text);
                    //print(order['id']);
                    //print(this._currentUnit);
                    //print(editAmount.text);
                    Navigator.pop(context);

              },
              child: Text(
                  'ตกลง',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold
                  )
              ),
            ),
          ],


        );
    });
  }

  selectShip(){
    return showDialog(context: context, builder: (context) {
      return SimpleDialog(
        title: Text('เลือกวิธีการรับสินค้า'),
        children: <Widget>[
          //Text('จำนวน'),
          RadioListTile(
            title: Text('คุณลูกค้ามารับสินค้าด้วยตัวเอง'),
            activeColor: Colors.green,
            value: 1,
            groupValue: selectedRadioTileShip,
            //selected: true,
            onChanged: (val){
              setState(() {});
              setSelectRadioTileShap(val);
            },
          ),
          RadioListTile(
            title: Text('ทางร้านวังจัดส่งให้โดยฝาก(รถตู้)'),
            activeColor: Colors.green,
            value: 3,
            groupValue: selectedRadioTileShip,
            //selected: false,
            onChanged: (val){
              setState(() {});
              setSelectRadioTileShap(val);
            },
          ),
          RadioListTile(
            title: Text('ทางร้านวังจัดส่งให้โดยฝาก(Taxi)'),
            activeColor: Colors.green,
            value: 4,
            groupValue: selectedRadioTileShip,
            //selected: false,
            onChanged: (val){
              setSelectRadioTileShap(val);
            },
          ),
          RadioListTile(
            title: Text('ทางร้านวังจัดส่งให้โดยฝาก(รถทัวร์)'),
            activeColor: Colors.green,
            value: 2,
            groupValue: selectedRadioTileShip,
            //selected: false,
            onChanged: (val){
              setSelectRadioTileShap(val);
            },
          ),
          RadioListTile(
            title: Text('ทางร้านวังจัดส่งให้โดยฝาก(ขนส่งอื่นๆ)'),
            activeColor: Colors.green,
            value: 5,
            groupValue: selectedRadioTileShip,
            //selected: false,
            onChanged: (val){
              setSelectRadioTileShap(val);
            },
          ),
          RadioListTile(
            title: Text('บริการขนส่งของวังเภสัช'),
            activeColor: Colors.green,
            value: 6,
            groupValue: selectedRadioTileShip,
            //selected: false,
            onChanged: (val){
              setSelectRadioTileShap(val);
            },
          ),
          Padding(
            padding: EdgeInsets.all(10),
          ),
          SimpleDialogOption(
            onPressed: (){
              selectPay();
            },
            child: Text(
                'ตกลง',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold
                )
            ),
          ),
        ],


      );
    });
  }

  selectPay(){
    return showDialog(context: context, builder: (context) {
      return SimpleDialog(
        title: Text('เลือกวิธีชำระเงิน'),
        children: <Widget>[
          //Text('จำนวน'),
          RadioListTile(
            title: Text('เครดิต(ลูกหนี้)'),
            activeColor: Colors.green,
            value: 1,
            groupValue: selectedRadioTilePay,
            onChanged: (val){
              setSelectRadioTilePay(val);
            },
          ),
          RadioListTile(
            title: Text('เงินสด'),
            activeColor: Colors.green,
            value: 2,
            groupValue: selectedRadioTilePay,
            onChanged: (val){
              setSelectRadioTilePay(val);
            },
          ),
          RadioListTile(
            title: Text('เช็ค'),
            activeColor: Colors.green,
            value: 3,
            groupValue: selectedRadioTilePay,
            onChanged: (val){
              setSelectRadioTilePay(val);
            },
          ),
          RadioListTile(
            title: Text('บัตรเครดิต'),
            activeColor: Colors.green,
            value: 4,
            groupValue: selectedRadioTilePay,
            onChanged: (val){
              setSelectRadioTilePay(val);
            },
          ),
          Padding(
            padding: EdgeInsets.all(10),
          ),
          SimpleDialogOption(
            onPressed: (){

            },
            child: Text(
                'ตกลง',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold
                )
            ),
          ),
        ],


      );
    });
  }



  _onDropDownItemSelected(newValueSelected){
    //setState(() {
      this._currentUnit = newValueSelected;
      //print('select--${units}');
    //});
  }

  void _confirmDelShowAlert(int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันลบรายการ'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: (){
                removeOrder(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



  removeOrder(int id) async{
    await databaseHelper.removeOrder(id);
    getOrderAll();
    showToastRemove();
    showOverlay();
  }

  void initState(){
    super.initState();
    getOrderAll();
    selectedRadioTileShip = 1;
    selectedRadioTilePay = 1;
  }

  setSelectRadioTileShap(int val){
    setState(() {
      selectedRadioTileShip = val;
    });
  }
  setSelectRadioTilePay(int val){
    setState(() {
      selectedRadioTilePay = val;
    });
  }

  showOverlay() async{

    var countOrder = await databaseHelper.countOrder();
    print(countOrder[0]['countOrderAll']);

    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: 25,
          right: 30,
          child: CircleAvatar(
            radius: 15,
            backgroundColor: Colors.red,
            child: Text("${countOrder[0]['countOrderAll']}",style: TextStyle(color: Colors.white)),
          ),
        )
    );

    overlayState.insert(overlayEntry);
    //await Future.delayed(Duration(seconds: 2));
    //overlayEntry.remove();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการสินค้า'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.check_box),
              onPressed: (){
                selectShip();
                //Navigator.pushReplacementNamed(context, '/Order');
              }
          )
        ],
      ),
      body: ListView.builder(
        //separatorBuilder: (context, index) => Divider(
          //color: Colors.black,
        //),
        itemBuilder: (context, int index){
          return ListTile(
              onTap: (){
                //setState(() {
                  editOrderDialog(orders[index]);
                //});
              },
              leading: Image.network('http://www.wangpharma.com/cms/product/${orders[index]['pic']}',width: 70, height: 70,),
              title: Text('${orders[index]['code']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${orders[index]['name']}'),
                  Text('จำนวน ${orders[index]['amount']} : ${orders[index]['unit']}',
                    style: TextStyle(fontSize: 18),),
                ],
              ),
              trailing: IconButton(
                  icon: Icon(Icons.delete_forever, color: Colors.red, size: 30,),
                  onPressed: (){
                    _confirmDelShowAlert(orders[index]['id']);
                  }
              ),
          );
        },
        itemCount: orders != null ? orders.length : 0,
      ),
    );
  }
}
