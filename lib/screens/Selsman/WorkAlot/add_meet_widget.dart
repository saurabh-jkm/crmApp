// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, avoid_unnecessary_containers, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, sized_box_for_whitespace, deprecated_colon_for_default_value

import "package:jkm_crm_admin/themes/function.dart";
import "package:jkm_crm_admin/themes/global.dart";
import "package:jkm_crm_admin/themes/style.dart";
import "package:jkm_crm_admin/themes/theme_widgets.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

Widget addNewMeet_widget(context, controller, fnFetchCutomerDetails, selectDate,
    ListShow, fn_change_state, fn_setstate) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: (!is_mobile) ? 20 : 10),
          child: Row(
            children: [
              IconButton(
                  onPressed: () async {
                    await controller.resetController();
                    fn_change_state('ListShow', true);
                  },
                  icon: Icon(Icons.arrow_back_rounded,
                      color: Colors.black, size: 35)),
              SizedBox(width: 10),
              GoogleText(
                  text: 'Meeting Assign for ',
                  fweight: FontWeight.normal,
                  color: Colors.black,
                  fsize: (is_mobile) ? 15.0 : 20.0),
              GoogleText(
                  text:
                      '${(controller.selectedSeller != null) ? controller.selectedSeller['name'] : ''}',
                  fweight: FontWeight.bold,
                  color: Colors.blue,
                  fsize: (is_mobile) ? 15.0 : 20.0),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all((!is_mobile) ? 20 : 10),
          decoration: BoxDecoration(
              color: Color.fromARGB(15, 0, 0, 0),
              borderRadius: BorderRadius.circular(10)),
          child: Form(
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
                        (is_mobile)
                            ? Row(
                                children: [
                                  Expanded(
                                      child: autoCompleteFormInput(
                                          controller.ListCustomer,
                                          "Customer Name *",
                                          controller.Customer_nameController,
                                          method: fnFetchCutomerDetails)),
                                ],
                              )
                            : Row(
                                children: [
                                  // fireld 1 ==========================
                                  Expanded(
                                      child: autoCompleteFormInput(
                                          controller.ListCustomer,
                                          "Customer Name *",
                                          controller.Customer_nameController,
                                          method: fnFetchCutomerDetails)),

                                  Expanded(
                                    child: formInput(
                                      context,
                                      "Mobile No.",
                                      controller.Customer_MobileController,
                                      padding: 8.0,
                                      isNumber: true,
                                    ),
                                  ),
                                  if (!is_mobile)
                                    Expanded(
                                      child: formInput(context, "Email Id",
                                          controller.Customer_emailController,
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
                            if (!is_mobile)
                              Expanded(
                                child: Text(""),
                              ),
                            if (is_mobile)
                              Expanded(
                                child: formInput(
                                  context,
                                  "Mobile No.",
                                  controller.Customer_MobileController,
                                  padding: 8.0,
                                  isNumber: true,
                                ),
                              )
                          ],
                        ),
                        if (is_mobile)
                          Row(children: [
                            Expanded(
                                child: formInput(context, "Email Id",
                                    controller.Customer_emailController,
                                    padding: 8.0)),
                            Expanded(
                              child: formInput(context, "Address *",
                                  controller.Customer_addressController,
                                  padding: 8.0),
                            ),
                          ]),
                        Row(
                          children: [
                            if (!is_mobile)
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

                        // Header End ============================
                        Divider(
                          thickness: 2.0,
                          color: Colors.black12,
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 5, bottom: 10),
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
                                                        ? "Select date * "
                                                        : "${change_date_time("${controller.selectedDate}")}", // controller.Next_date,
                                                    style: GoogleFonts.alike(
                                                        fontSize: 13.0,
                                                        color: (controller
                                                                    .Next_date ==
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
              ],
            ),
          ),
        ),
        themeSpaceVertical(5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            themeButton3(context,
                label: "Submit",
                // btnHeightSize: 45.0,
                // btnWidthSize: 250.0,
                buttonColor: Colors.green,
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
            SizedBox(width: 20),
            themeButton3(context,
                label: "Reset",
                // btnHeightSize: 45.0,
                // btnWidthSize: 250.0,
                buttonColor: Colors.black,
                radius: 10.0,
                fontSize: 20, () async {
              await controller.resetController();
              fn_setstate();
            }),
          ],
        ),
        themeSpaceVertical(20.0),
      ],
    ),
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

Widget tableLablee(context, i, label, tableColum) {
  return Container(
    width: tableColum[i],
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text('$label',
          style: themeTextStyle(
              size: 12.0, color: Colors.white, fw: FontWeight.bold)),
    ),
  );
}

Widget tableDetails(context, i, label, tableColum) {
  return Container(
    width: tableColum,
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text('$label',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: themeTextStyle(
              size: 12.0, color: Colors.black, fw: FontWeight.bold)),
    ),
  );
}
