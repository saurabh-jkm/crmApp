// ignore_for_file: prefer_const_constructors, prefer_equal_for_default_values, avoid_unnecessary_containers, deprecated_member_use, no_leading_underscores_for_local_identifiers, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps, sort_child_properties_last, sized_box_for_whitespace, non_constant_identifier_names, deprecated_colon_for_default_value, unnecessary_string_interpolations

import 'package:crm_demo/themes/function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../responsive.dart';
import 'style.dart';

// Button
Widget themeButton3(BuildContext context, fn,
    {label = 'Submit',
    fontSize = 16.0,
    arg = 0,
    buttonColor = '',
    radius = 32.0,
    borderColor = '',
    btnWidthSize = 100.0,
    btnHeightSize = 40.0}) {
  buttonColor = (buttonColor == '') ? themeBG : buttonColor;
  return Container(
    child: Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: buttonColor,
          onPrimary: buttonColor,
          shadowColor: Color.fromARGB(255, 165, 165, 165),
          elevation: 3,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: (borderColor == '') ? buttonColor : borderColor),
              borderRadius: BorderRadius.circular(radius)),
          minimumSize: Size(btnWidthSize, btnHeightSize), //////// HERE
        ),
        onPressed: () {
          if (arg == 0) {
            fn();
          } else {
            fn(arg);
          }
        },
        child: Text(
          '$label',
          style: themeTextStyle(
              color: Colors.white, size: fontSize, ftFamily: 'ms'),
        ),
      ),
    ),
  );
}

Widget themeBtnSm(BuildContext context,
    {label = 'Submit',
    dynamic arg,
    dynamic arg2,
    dynamic arg3,
    buttonColor = '',
    fn = '',
    buttonWidth = '',
    icon = '',
    borderRadius = '',
    btnSize = ''}) {
  return Container(
    width: (buttonWidth == '') ? null : buttonWidth,
    child: Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // primary: buttonColor,
          // onPrimary: buttonColor,
          backgroundColor: (buttonColor == '') ? themeBG2 : buttonColor,
          shadowColor: Color.fromARGB(255, 165, 165, 165),
          elevation: 3,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  (borderRadius == '') ? 32.0 : borderRadius)),
          minimumSize: (btnSize != '') ? btnSize : Size(80, 30), //////// HERE
        ),
        onPressed: () {
          if (fn != '' && arg == null) {
            fn();
          } else if (fn != '' && arg != null && arg2 != null && arg3 != null) {
            fn(arg, arg2, arg3);
          } else if (fn != '' && arg != null && arg2 != null) {
            fn(arg, arg2);
          } else if (fn != '' && arg != null) {
            fn(arg);
          }
        },
        child: Row(
          children: [
            Text(
              '$label',
              style: themeTextStyle(
                  color: Colors.white, size: 14.0, ftFamily: 'ms'),
            ),
            (icon == '')
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.only(top: 2.0, left: 5.0),
                    child: Icon(
                      icon,
                      size: 10.0,
                    ),
                  )
          ],
        ),
      ),
    ),
  );
}

Widget themeListRow(BuildContext context, label, desc,
    {fontsize = 14,
    bottomSpace = 4.0,
    double labelWidth = 100.0,
    double decWidth = 0.0,
    decFontWait = FontWeight.normal,
    headColor = Colors.white,
    descColor = Colors.white}) {
  return Padding(
    padding: EdgeInsets.only(bottom: bottomSpace),
    child: Row(
      children: [
        // SizedBox(
        //   width: 5,
        // ),
        SizedBox(
          width: labelWidth,
          child: Text(
            "$label",
            style: themeTextStyle(
                size: 12.0,
                color: headColor,
                ftFamily: 'ms',
                fw: FontWeight.bold),
          ),
        ),
        // SizedBox(
        //   width: 5,
        // ),
        (decWidth == 0.0)
            ? Text(
                ": $desc",
                overflow: TextOverflow.ellipsis,
                style: themeTextStyle(
                    size: fontsize,
                    color: descColor,
                    ftFamily: 'ms',
                    fw: decFontWait),
              )
            : SizedBox(
                width: decWidth,
                child: Text(": $desc",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.alike(
                      fontSize: fontsize,
                      color: descColor,
                    )),
              )
      ],
    ),
  );
}
///////  My Payment Row

Widget themePayListRow(BuildContext context, label, desc,
    {fontsize = 13,
    bottomSpace = 4.0,
    double labelWidth = 100.0,
    double decWidth = 0.0,
    decFontWait = FontWeight.normal,
    descColor = Colors.black}) {
  return Padding(
    padding: EdgeInsets.only(bottom: bottomSpace),
    child: Row(
      children: [
        SizedBox(
          width: 5,
        ),
        SizedBox(
          width: labelWidth,
          child: Text(
            "$label",
            style: themeTextStyle(
                size: 13.0,
                color: themeBG2,
                ftFamily: 'ms',
                fw: FontWeight.bold),
          ),
        ),
        // SizedBox(
        //   width: 5,
        // ),
        (decWidth == 0.0)
            ? Text(
                ": $desc",
                overflow: TextOverflow.ellipsis,
                style: themeTextStyle(
                    size: fontsize,
                    color: descColor,
                    ftFamily: 'ms',
                    fw: decFontWait),
              )
            : SizedBox(
                width: decWidth,
                child: Text(
                  ": $desc",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: themeTextStyle(
                      size: fontsize, color: descColor, ftFamily: 'ms'),
                ),
              )
      ],
    ),
  );
}

///
// theme navigation tab

Widget themeNavigationTab(BuildContext context, _tabController,
    {allList = false,
    pendingList = false,
    allListWidget = '',
    pendingListWidget = '',
    screenHeight = '',
    label = 'data',
    tab1 = "All",
    tab2 = "Pending",
    no_have_message = ''}) {
  return Container(
    child: Column(
      children: [
        SizedBox(
          height: (screenHeight == '')
              ? MediaQuery.of(context).size.height
              : screenHeight,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: TabBar(
                  unselectedLabelColor: Color.fromARGB(255, 126, 126, 126),
                  labelColor: Color.fromARGB(255, 32, 32, 32),
                  tabs: [
                    Tab(
                      child: Text(
                        "$tab1",
                        style: themeTextStyle(
                            size: 14.0,
                            ftFamily: 'ms',
                            fw: FontWeight.bold,
                            color: Color.fromARGB(255, 46, 46, 46)),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "$tab2",
                        style: themeTextStyle(
                            size: 14.0,
                            ftFamily: 'ms',
                            fw: FontWeight.bold,
                            color: Color.fromARGB(255, 46, 46, 46)),
                      ),
                    ),
                  ],
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    (allList)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: (allListWidget == '')
                                ? SizedBox()
                                : allListWidget,
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 150.0),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    // child: Icon(
                                    //     Icons.hourglass_empty,
                                    //     size: 40.0,
                                    //     color:
                                    //         Color.fromARGB(255, 168, 168, 168),
                                    //   ),
                                    radius: 42,
                                    backgroundColor:
                                        Color.fromARGB(255, 250, 224, 212),
                                  ),
                                  SizedBox(height: 20.0),
                                  Text(
                                      "${(no_have_message != '') ? no_have_message : 'No have data'}"),
                                  // Text("No have data", //No have ${tab1}",
                                  //     style: TextStyle(
                                  //         fontWeight: FontWeight.bold,
                                  //         fontSize: 16.0)),

                                  // Text(
                                  //     "If you want create new ${(label == 'data') ? 'request' : label} Click request button",
                                  //     style: TextStyle(fontSize: 11.0)),
                                ],
                              ),
                            ),
                          ),

                    // Send Tab Screen
                    Center(
                      child: (pendingList)
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: (pendingListWidget == '')
                                  ? SizedBox()
                                  : pendingListWidget,
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 150.0),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      // child: Icon(
                                      //   Icons.hourglass_empty,
                                      //   size: 40.0,
                                      //   color:
                                      //       Color.fromARGB(255, 168, 168, 168),
                                      // ),
                                      radius: 42,
                                      backgroundColor:
                                          Color.fromARGB(255, 250, 224, 212),
                                    ),
                                    SizedBox(height: 20.0),
                                    // Text("No have  ${tab2}",
                                    //     style: TextStyle(
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 16.0)),
                                    Text(
                                        "${(no_have_message != '') ? no_have_message : 'No have data'}"),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ],
                  controller: _tabController,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// flot button
Widget themeFloatButton(BuildContext context, label,
    {fn = '', myIcon = '', myColor = '', fontsize = ''}) {
  return FloatingActionButton.extended(
    icon: Icon((myIcon == '') ? Icons.add_circle_outline_outlined : myIcon),
    label: Text(
      "$label",
      style: themeTextStyle(
          size: (fontsize == '') ? 14.0 : fontsize,
          ftFamily: 'ms',
          color: Colors.white),
    ),
    backgroundColor: (myColor == '') ? themeBG2 : myColor,
    foregroundColor: Color.fromARGB(255, 243, 243, 243),
    onPressed: () {
      //fnNewRequest();
      if (fn != '') {
        fn();
      }
    },
  );
}

// Top Progress Bar
Widget liniearProgressCon(BuildContext context, value, label1, label2) {
  return Container(
    padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$label1",
              style: themeTextStyle(size: 14.0, ftFamily: 'ms'),
            ),
            Text(
              "$label2",
              style: themeTextStyle(size: 14.0, ftFamily: 'ms'),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Color.fromARGB(255, 197, 197, 197),
          color: themeBG3,
          semanticsLabel: 'Linear progress indicator',
        ),
      ],
    ),
  );
}

themeHeading(BuildContext context, text) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Container(
      width: MediaQuery.of(context).size.width - 20,
      color: themeBG2,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Text(
        '$text',
        style: themeTextStyle(
            size: 16.0,
            ftFamily: 'ms',
            fw: FontWeight.bold,
            color: Colors.white),
      ),
    ),
    Divider(
      thickness: 1.0,
      height: 3.0,
      color: themeBG,
    ),
    SizedBox(height: 10.0),
  ]);
}

// Pleas wait progress

pleaseWait(BuildContext context, {containerHeight = 300.0}) {
  return Container(
    height: containerHeight,
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [progress(), SizedBox(height: 20.0), Text("wait")]),
  );
}

HeadLine(BuildContext context, icon_def, head_text, Sub_text, fn,
    {arg = 0, buttonColor = '', Buttonlabel = "Update", iconColor = ""}) {
  return Container(
    height: 100,
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(icon_def, color: iconColor, size: 30),
            SizedBox(
              width: 10,
            ),
            Text(
              '$head_text',
              style: themeTextStyle(
                  size: 18.0,
                  ftFamily: 'ms',
                  fw: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              '$Sub_text',
              style: themeTextStyle(
                  size: 12.0,
                  ftFamily: 'ms',
                  fw: FontWeight.normal,
                  color: Colors.black45),
            ),
          ],
        ),
        ElevatedButton.icon(
          style: TextButton.styleFrom(
            backgroundColor: buttonColor,
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding * 1.5,
              vertical: defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
            ),
          ),
          onPressed: () {
            if (arg == 0) {
              fn();
            } else {
              fn(arg);
            }
          },
          icon: Icon(Icons.add),
          label: Text("Add New"),
        ),
      ],
    ),
  );
}

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFee7b64), width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFee7b64), width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFee7b64), width: 2),
  ),
);

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 14),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
        textColor: Colors.white,
      ),
    ),
  );
}

// form input field ===========================
Widget formInput(BuildContext context, label, controller,
    {padding: 5.0,
    suggationList,
    editComplete: '',
    focusNode: '',
    currentController: '',
    isNumber: false,
    isFloat: false,
    method: '',
    methodArg: '',
    readOnly: false,
    isPreloadInput: false}) {
  return Container(
      height: 55,
      padding: EdgeInsets.all(padding),
      child: (editComplete == '')
          ? TextFormField(
              controller: controller,
              style: textStyle1,
              decoration: inputStyle(label),
              keyboardType:
                  (isNumber) ? TextInputType.number : TextInputType.text,

              //inputFormatters: [DecimalTextInputFormatter(decimalRange: 1)],

              // inputFormatters: (isNumber)
              //     ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
              //     : <TextInputFormatter>[
              //         FilteringTextInputFormatter.singleLineFormatter
              //       ],
              readOnly: readOnly,
              inputFormatters: (isNumber && isFloat)
                  ? <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9]+[,.]{0,1}[0-9]*'))
                    ]
                  : (isNumber)
                      ? <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ]
                      : <TextInputFormatter>[
                          FilteringTextInputFormatter.singleLineFormatter
                        ],
              onChanged: (value) {
                if (method != '') {
                  if (methodArg != '') {
                    method(methodArg);
                  } else {
                    method();
                  }
                }
              },
            )
          : TextFormField(
              // this is for auto complete
              controller: (isPreloadInput) ? currentController : controller,
              style: textStyle1,
              onEditingComplete: editComplete,
              focusNode: focusNode,
              decoration: inputStyle(label),
              onChanged: (value) {
                currentController.text = value;
              },
            ));
}

// space
Widget themeSpaceVertical(height) {
  return SizedBox(height: height);
}

// auto complete =================================
autoCompleteFormInput(suggationList, label, myController,
    {padding: 10.0,
    myFocusNode: '',
    method: '',
    methodArg: '',
    strinFilter: '',
    isPreloadInput: false}) {
  return Autocomplete(
    fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
      controller.text = myController.text;
      return formInput(context, "$label", controller,
          editComplete: onEditingComplete,
          focusNode: (myFocusNode == '') ? focusNode : myFocusNode,
          currentController: myController,
          padding: padding,
          isPreloadInput: isPreloadInput);
    },
    optionsBuilder: (TextEditingValue textEditingValue) {
      if (textEditingValue.text == '') {
        return const Iterable<String>.empty();
      } else {
        List<String> matches = <String>[];
        matches.addAll(suggationList);
        matches.retainWhere((s) {
          return s.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
        return matches;
      }
    },
    onSelected: (String selection) {
      myController.text = selection;
      // if method call
      if (method != '') {
        if (methodArg != '') {
          method(methodArg);
        } else {
          method();
        }
      }
    },
  );
}

// dropdown ===============================================
// form input field ===========================
Widget inpuDropdDown(BuildContext context, label, itemList, value,
    {padding: 5.0,
    suggationList,
    editComplete: '',
    focusNode: '',
    currentController: '',
    isNumber: false,
    isFloat: false,
    method: '',
    methodArg: '',
    readOnly: false,
    style: 1}) {
  // if (editComplete != '' && currentController.text == '') {
  //   controller.text = currentController.text;
  // }

  return Container(
      padding: EdgeInsets.all(padding),
      child: DropdownButtonFormField(
        style: textStyle1,
        dropdownColor: Colors.white,
        value: '${value}',
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black, // <-- SEE HERE
        ),
        decoration: (style == 2) ? inputStyle2(value) : inputStyle(label),
        onChanged: (String? newValue) {
          if (method == '') {
            value = newValue;
          } else {
            method(newValue);
          }
        },
        items: itemList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ));
}

// search input
Widget inputSearch(context, controller, label, {method: ''}) {
  return TextFormField(
    controller: controller,
    style: textStyle1,
    onChanged: (value) {
      if (method != '') {
        method(value);
      }
    },
    decoration: InputDecoration(
      contentPadding: EdgeInsets.only(left: 6.0),
      hintText: 'Search',
      hintStyle: themeTextStyle(
          color: const Color.fromARGB(255, 156, 156, 156), size: 14.0),
      enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: themeBG4, width: 3.0)),
    ),
  );
}

// theme heading
Widget themeHeading2(label) {
  return Padding(
    padding: EdgeInsets.only(left: 10.0),
    child: Text("$label",
        style: themeTextStyle(color: themeBG, fw: FontWeight.bold, size: 16.0)),
  );
}

// Search box
Widget SearchBox(BuildContext context, {searchFn: '', label: 'Search'}) {
  return TextField(
    style: TextStyle(color: Color.fromARGB(255, 27, 27, 27)),
    onChanged: (value) {
      if (searchFn != '') {
        searchFn(value);
      }
    },
    decoration: InputDecoration(
      hintText: "$label",
      hintStyle: TextStyle(color: Colors.black),
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      // suffixIcon: InkWell(
      //   onTap: () {},
      //   child: Container(
      //     padding: EdgeInsets.all(defaultPadding * 0.75),
      //     margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
      //     decoration: BoxDecoration(
      //       color: primaryColor,
      //       borderRadius: const BorderRadius.all(Radius.circular(10)),
      //     ),
      //     child: Icon(Icons.search),
      //   ),
      // ),
    ),
  );
}

// Time Input
Widget formTimeInput(BuildContext context, controller,
    {method: '', arg: '', label: 'Name'}) {
  return TextField(
    style: TextStyle(color: Color.fromARGB(255, 27, 27, 27)),
    onTap: () {
      if (method != '') {
        if (arg == '') {
          method();
        } else if (arg != '') {
          method(arg);
        }
      }
    },
    controller: controller,
    decoration: InputDecoration(
      hintText: "$label",
      hintStyle: TextStyle(color: Colors.black),
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
    ),
  );
}

// Table Heading ==========================
Widget TableHeading(context, data, {rowColor: '', textColor: ''}) {
  return Container(
    margin: EdgeInsets.only(bottom: 1.0),
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    decoration: BoxDecoration(color: (rowColor == '') ? themeBG2 : rowColor),
    child: Row(
      children: [
        for (String k in data)
          (k == '#')
              ? Container(
                  width: 40.0,
                  child: Container(
                    child: Text("${capitalize(k)}",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: (textColor == '')
                                ? Color.fromARGB(255, 201, 201, 201)
                                : textColor)),
                  ),
                )
              : Expanded(
                  child: Container(
                    child: Text("${capitalize(k)}",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: (textColor == '')
                                ? Color.fromARGB(255, 201, 201, 201)
                                : textColor)),
                  ),
                ),
      ],
    ),
  );
}

Widget myFormField(BuildContext context, controller, label,
    {readOnly = false,
    onlyNumber = false,
    icon = '',
    fn = '',
    maxLine = 1,
    maxLength = 100}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.comment,
              color: Colors.blue,
              size: 30,
            ),
            SizedBox(width: 10),
            GoogleText(
                text: "$label",
                fweight: FontWeight.bold,
                color: Colors.black,
                fsize: 15.0),
          ],
        ),
        SizedBox(height: 5.0),
        Container(
          padding: EdgeInsets.symmetric(
              vertical: (maxLine == 1) ? 0.0 : 7.0, horizontal: 10.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 1.0, color: Color.fromARGB(255, 206, 206, 206)),
              borderRadius: BorderRadius.circular(10.0)),
          child: TextFormField(
            textInputAction:
                (maxLine == 1) ? TextInputAction.go : TextInputAction.newline,

            onChanged: (value) {
              if (value.length == maxLength) {
                FocusScope.of(context).nextFocus();
              }
            },

            style: TextStyle(fontSize: 16.0, color: Colors.black),
            // onTap: () {
            //   if (fn == 'date_of_admission') {
            //     datePick('date_of_admission');
            //   } else if (fn == 'date_of_discharge') {
            //     datePick('date_of_discharge');
            //   }
            // },
            controller: controller,

            readOnly: (readOnly) ? true : false,
            maxLength: (maxLength == 100) ? 200 : maxLength,
            maxLines: (maxLine == 1) ? 1 : maxLine,
            keyboardType: (onlyNumber)
                ? TextInputType.number
                : (maxLine == 1)
                    ? TextInputType.text
                    : TextInputType.multiline,

            obscureText: (label == 'Change PIN - (Optional)') ? true : false,
            decoration: InputDecoration(
              // fillColor: Colors.grey,
              // focusColor: Colors.grey,
              counterText: "",
              hintText: label,
              filled: true,
              // fillColor: Color.fromARGB(255, 255, 255, 255),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              suffixIcon: (icon == '')
                  ? Text("")
                  : Icon(
                      icon,
                      color: themeBG2,
                    ),
            ),
          ),
        ),
        SizedBox(height: 15.0),
      ],
    ),
  );
}

Widget GoogleText(
    {text = "",
    color = Colors.black,
    fsize = 15.0,
    fweight = FontWeight.normal,
    fstyle = FontStyle.normal}) {
  return Text("$text",
      style: GoogleFonts.alike(
          color: color,
          fontSize: fsize,
          fontWeight: fweight,
          fontStyle: fstyle));
}
