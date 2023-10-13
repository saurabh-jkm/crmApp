// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_demo/themes/function.dart';
import 'package:crm_demo/themes/style.dart';
import 'package:crm_demo/themes/theme_widgets.dart';
import 'package:flutter/material.dart';

Widget themeHeader2(context, headerLable,
    {secondButton: '', refreshBUtton: '', buttonFn: '', widthBack: ''}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
    decoration: BoxDecoration(color: themeBG2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    if (widthBack == '') {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.pop(context, 'updated');
                    }
                  },
                  child: Icon(Icons.arrow_back, color: Colors.white)),
              SizedBox(width: 20.0),
              Text("${headerLable}")
            ],
          ),
        ),
        (secondButton != '')
            ? Container(
                child: themeButton3(context, buttonFn,
                    label: 'Add New', radius: 5.0),
              )
            : SizedBox(),
        (refreshBUtton != '')
            ? Container(
                child: GestureDetector(
                  onTap: () {
                    if (buttonFn != '') {
                      buttonFn();
                    }
                  },
                  child: Icon(Icons.refresh, color: Colors.white),
                ),
              )
            : SizedBox()
      ],
    ),
  );
}

// add new category =====================================
addNewCategory(context, newValue, listCategory, actionFn,
    {label: 'Category', hint: 'Select Parent Category'}) async {
  {
    var newCat = listCategory;
    if (!listCategory.contains('Primary')) {
      newCat.add('Primary');
    }

    var parentCat = 'Primary';

    showModalBottomSheet(
        //isScrollControlled: true, // for full screen
        context: context,
        backgroundColor: Color.fromARGB(0, 232, 232, 232),
        builder: (BuildContext context) {
          return ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              child: Container(
                  //height: MediaQuery.of(context).size.height - 200,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0))),
                  child: Column(children: [
                    Container(
                      decoration: BoxDecoration(
                        color: themeBG2,
                      ),
                      child: ListTile(
                          leading: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ) // the arrow back icon
                                ),
                          ),
                          title: Center(
                              child: Text(
                            '"${newValue}" - ${label}',
                            style: TextStyle(color: Colors.white),
                          ) // Your desired title
                              )),
                    ),
                    themeSpaceVertical(50.0),
                    // dropdown
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 230.0,
                          child: DropdownButtonFormField(
                            value: 'Primary',
                            style: textStyle1,
                            dropdownColor: Colors.white,
                            decoration: inputStyle(hint),
                            onChanged: (String? newValue) {
                              parentCat = newValue.toString();
                            },
                            items: newCat
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),

                    themeSpaceVertical(20.0),
                    ElevatedButton(
                        onPressed: () {
                          actionFn(parentCat, context);
                        },
                        child: Text('Submit'))
                  ])));
        });
  }
}

// add new attribute =====================================
addNewAttrbute(context, controller, addNewAttFn) async {
  {
    showModalBottomSheet(
        //isScrollControlled: true, // for full screen
        context: context,
        backgroundColor: Color.fromARGB(0, 232, 232, 232),
        builder: (BuildContext context) {
          return ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              child: Container(
                  //height: MediaQuery.of(context).size.height - 200,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0))),
                  child: Column(children: [
                    Container(
                      decoration: BoxDecoration(
                        color: themeBG2,
                      ),
                      child: ListTile(
                          leading: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ) // the arrow back icon
                                ),
                          ),
                          title: Center(
                              child: Text(
                            'Add New Attribute',
                            style: TextStyle(color: Colors.white),
                          ) // Your desired title
                              )),
                    ),
                    themeSpaceVertical(50.0),
                    // add atribute
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 330.0,
                            child: formInput(
                                context, "Enter Attribute", controller)),
                      ],
                    ),
                    themeSpaceVertical(20.0),
                    ElevatedButton(
                        onPressed: () {
                          addNewAttFn(context);
                        },
                        child: Text('Submit'))
                  ])));
        });
  }
}

// single product  list ==========================
Widget productRow(context, key, data) {
  if (key == 'item_list') {
    return SizedBox();
  } else {
    var val = data;
    if (key == 'date_at') {
      val = formatDate(data);
    } else if (key == 'status') {
      val = (data) ? "Active" : "In-Active";
    }
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Container(
            width: 120.0,
            child: Text("${capitalize(key)}",
                style: TextStyle(
                    color: themeBG2,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.0)),
          ),
          SizedBox(width: 20.0),
          Text(": ${val}",
              style: TextStyle(fontSize: 12.0, color: Colors.black)),
        ],
      ),
    );
  }
}

// single product  list ==========================
Widget productTableRow(context, key, data, headingList, {rowColor: ''}) {
  data = (data[key] == null) ? {} : data[key];

  return Container(
    margin: EdgeInsets.only(bottom: 1.0),
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    decoration: BoxDecoration(color: (rowColor == '') ? themeBG : rowColor),
    child: Row(
      children: [
        for (String k in headingList)
          valueWid(k, data[k], qnt: data['quantity'])
      ],
    ),
  );
}

Widget valueWid(k, value, {qnt: 1}) {
  //value = (value )
  // if (k == 'unit' && qnt != null && value != '') {
  //   var total = int.parse(qnt.toString()) * int.parse(value.toString());
  //   value = '$value x $qnt = ${total}';
  // }
  return Expanded(
    child: Container(
      child: Text(
          "${(value == null || value == '' || value == '0') ? '-' : value}",
          style: TextStyle(fontSize: 12.0, color: Colors.black)),
    ),
  );
}

// single product  list ==========================
Widget productTableHeading(context, data) {
  return Container(
    margin: EdgeInsets.only(bottom: 1.0),
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    decoration: BoxDecoration(color: themeBG2),
    child: Row(
      children: [
        for (String k in data)
          Expanded(
            child: Container(
              child: Text("${capitalize(k)}",
                  style: TextStyle(
                      fontSize: 12.0,
                      color: const Color.fromARGB(255, 201, 201, 201))),
            ),
          ),
      ],
    ),
  );
}

// log row widgets ===================================
Widget logTableRow(context, i, data, headingList) {
  var lotList = new List.from(data['log'].reversed);

  return (data['log'] == 'null')
      ? SizedBox()
      : Container(
          //padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),

          child: Column(
            children: [
              for (var k in lotList) SecondrRowForLog(context, k, headingList)
            ],
          ),
        );
}

Widget SecondrRowForLog(context, data, headingList) {
  var newData = data['item_list'];
  var oldSubData = data['oldSubData'];
  //newData = (newData[key] == null) ? {} : data[key];

  //var tData = data['$k'];

  return (newData == null)
      ? SizedBox()
      : Container(
          margin: EdgeInsets.only(bottom: 4.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: BoxDecoration(color: themeBG3),
                child: Row(
                  children: [
                    Expanded(
                        child:
                            Text("Update At: ${formatDate(data['log_date'])}")),
                    Expanded(
                        child: Text("Updated By: ${data['updatedByName']}"))
                  ],
                ),
              ),
              for (String key in newData.keys)
                log_TableRow(context, key, newData, headingList, oldSubData,
                    rowColor: Color.fromARGB(255, 101, 178, 209))
            ],
          ),
        );
}

Widget log_TableRow(context, key, dataArr, headingList, oldSubData,
    {rowColor: ''}) {
  var arr = {};
  if (dataArr[key] != null) {
    dataArr[key].forEach((k, v) {
      arr[k] = v;
    });
  }
  //arr = (dataArr[key] == null) ? {} : dataArr[key];
  print(oldSubData);
  if (oldSubData != null && oldSubData[key] != null) {
    print("yess");
    var odata = oldSubData[key];
    arr['price'] = (odata['price'] != null)
        ? '${odata['price']} -> ${arr['price']}'
        : arr['price'];

    arr['location'] = (odata['location'] != null)
        ? '${odata['location']} -> ${arr['location']}'
        : arr['location'];

    arr['quantity'] = (odata['quantity'] != null)
        ? '${odata['quantity']} -> ${arr['quantity']}'
        : arr['quantity'];
  }

  if (arr['quantity'] != null && arr['qnt_added'] != null) {
    arr['quantity'] = arr['qnt_added'];
  }

  return Container(
    margin: EdgeInsets.only(bottom: 1.0),
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    decoration: BoxDecoration(color: (rowColor == '') ? themeBG : rowColor),
    child: Row(
      children: [
        for (String k in headingList)
          logValueWid(k, arr[k], qnt: arr['quantity'])
      ],
    ),
  );
}

Widget logValueWid(k, value, {qnt: 1}) {
  return Expanded(
    child: Container(
      child: Text(
          "${(value == null || value == '' || value == '0') ? '-' : value}",
          style: TextStyle(fontSize: 12.0, color: Colors.black)),
    ),
  );
}
