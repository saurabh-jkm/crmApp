// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, avoid_unnecessary_containers, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, sized_box_for_whitespace, deprecated_colon_for_default_value

import "package:crm_demo/themes/function.dart";
import "package:crm_demo/themes/style.dart";
import "package:crm_demo/themes/theme_widgets.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

Widget addNewMeet_widget(context, controller, fnFetchCutomerDetails, selectDate,
    ListShow, fn_change_state, fn_setstate) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Row(
        children: [
          IconButton(
              onPressed: () {
                fn_change_state('ListShow', true);
              },
              icon:
                  Icon(Icons.arrow_back_rounded, color: Colors.black, size: 30))
        ],
      ),
      SizedBox(
        height: 10,
      ),
      Form(
        key: controller.formKeyInvoice,
        child: Column(
          children: <Widget>[
            ///    Add TextFormFields and ElevatedButton here.
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 2,
                child: Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    themeSpaceVertical(5.0),
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.black, size: 30),
                        themeHeading2("Customer Details "),
                      ],
                    ),

                    themeSpaceVertical(4.0),
                    Row(
                      children: [
                        // fireld 1 ==========================
                        Expanded(
                            child: autoCompleteFormInput(
                                controller.ListCustomer,
                                "Customer Name",
                                controller.Customer_nameController,
                                method: fnFetchCutomerDetails)),

                        Expanded(
                          child: formInput(
                            context,
                            "Mobile No.*",
                            controller.Customer_MobileController,
                            padding: 8.0,
                            isNumber: true,
                          ),
                        ),
                        Expanded(
                          child: formInput(context, "Email Id",
                              controller.Customer_emailController,
                              padding: 8.0),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: formInput(context, "Address *",
                              controller.Customer_addressController,
                              padding: 8.0),
                        ),
                        Expanded(
                          child: formInput(context, "Pin Code *",
                              controller.Customer_pincodeController,
                              padding: 8.0, isNumber: true),
                        ),
                        Expanded(
                          child: formInput(context, "Shop No.",
                              controller.Customer_shopNoController,
                              padding: 8.0),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        // fireld 1 ==========================
                        Expanded(
                            child: autoCompleteFormInput(
                                controller.ListType,
                                "Customer Type",
                                controller.Customer_TypeController,
                                method: fnFetchCutomerDetails)),
                        // fireld 2 ==========================
                        Expanded(
                          child: Text(""),
                        ),
                        Expanded(
                          child: Text(""),
                        ),
                      ],
                    ),
                    // 2nd row =============================================
                    // Header End ============================

                    themeSpaceVertical(10.0),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        children: [
                          Icon(Icons.meeting_room,
                              color: Colors.black, size: 30),
                          themeHeading2("Meeting Details"),
                        ],
                      ),
                    ),

                    Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(10, 0, 0, 0),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black)),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10, left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        selectDate(context, '');
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              top: 10, left: 10),
                                          decoration: BoxDecoration(
                                              boxShadow: themeBox,
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          padding: EdgeInsets.all(5),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                size: 30,
                                                color: Colors.blue,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                (controller.Next_date == "")
                                                    ? "     Select date *    "
                                                    : controller.Next_date,
                                                style: GoogleFonts.alike(
                                                    fontSize: 13.0,
                                                    color:
                                                        (controller.Next_date ==
                                                                "")
                                                            ? Colors.blue
                                                            : Colors.green),
                                              ),
                                              SizedBox(width: 10),
                                            ],
                                          ))),
                                  (controller.Next_date == "")
                                      ? SizedBox()
                                      : IconButton(
                                          onPressed: () {
                                            controller.Next_date = "";
                                            fn_setstate();
                                          },
                                          icon: Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                            size: 30,
                                          ))
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            myFormField(
                                context,
                                controller.Customer_NextFollowUp_Controller,
                                "Comments",
                                maxLine: 4),
                          ],
                        ))

                    //field
                  ],
                )),
              ),
            ]),
            // auto complete =================================

            themeSpaceVertical(5.0),

            Divider(
              thickness: 2.0,
              color: Colors.black12,
            ),
          ],
        ),
      ),
      themeSpaceVertical(5.0),
      themeButton3(context,
          label: "Submit",
          btnHeightSize: 45.0,
          btnWidthSize: 250.0,
          buttonColor: themeBG4,
          radius: 10.0,
          fontSize: 20, () async {
        var rData = await controller.insertInvoiceDetails(context);
        if (rData == 'success') {
          // print("setState");
          fn_setstate();
          fn_change_state('ListShow', true);
        }
        // Navigator.of(context).pop();
      }),
      themeSpaceVertical(10.0),
    ],
  );
}

// single product  list ==========================
Widget rowFollowp(context, key, data, {color: ''}) {
  if (key == 'item_list' || key == 'image') {
    return SizedBox();
  } else {
    var val = data;
    if (key == 'date_at') {
      //val = formatDate(data);
    } else if (key == 'status') {
      //val = (data) ? "Active" : "In-Active";
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      color: (color == '') ? Color.fromARGB(255, 171, 220, 226) : color,
      margin: EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Container(
            width: 150.0,
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
