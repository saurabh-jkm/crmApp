import 'package:crm_demo/themes/style.dart';
import 'package:crm_demo/themes/theme_widgets.dart';
import 'package:flutter/material.dart';

Widget themeHeader2(context, headerLable,
    {secondButton: '', buttonFn: '', widthBack: ''}) {
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
