// ignore_for_file: file_names, deprecated_colon_for_default_value

import 'package:crm_demo/themes/function.dart';
import 'package:crm_demo/themes/style.dart';
import 'package:crm_demo/themes/theme_widgets.dart';
import 'package:flutter/material.dart';

// modal
modalAddInStock(context, controller, {savFun: ''}) async {
  {
    // var controller = new invoiceController();
    // controller.SaleCategoryController[1] = TextEditingController();
    showModalBottomSheet<void>(
        isScrollControlled: true, // for full screen
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
                        color: themeBG3,
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
                            "Find New Product. Do you want to Add product in stock?",
                            style: TextStyle(color: Colors.white),
                          ) // Your desired title
                              )),
                    ),

                    // Price Field
                    SizedBox(height: 10.0),
                    // ===============================================================================================
                    Container(
                      height: MediaQuery.of(context).size.height - 100,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: ListView(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                themeButton3(context, () async {
                                  Navigator.of(context).pop();
                                  await controller
                                      .insertInvoiceDetails(context);
                                },
                                    radius: 7.0,
                                    label: 'Skip',
                                    buttonColor: const Color.fromARGB(
                                        255, 209, 209, 209)),

                                // submit button
                                SizedBox(width: 20.0),
                                themeButton3(context, () async {
                                  //await fnInsertSaleProduct(context);
                                  if (savFun != '') {
                                    savFun();
                                  }
                                }, radius: 7.0, label: 'Save'),
                              ],
                            ),
                          ),
                          for (var i = 1; i <= controller.saleTotalProduct; i++)
                            Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(106, 211, 234, 255),
                                  border: Border.all(color: Colors.black12)),
                              margin: EdgeInsets.only(right: 8.0, bottom: 10.0),
                              child: Column(
                                children: [
                                  Container(
                                      color: themeBG3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [Text("Product No. $i")],
                                      )),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    child: Row(
                                      children: [
                                        // product Name
                                        Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4 -
                                              10,
                                          child: formInput(
                                            context,
                                            "Product Name*",
                                            controller
                                                .SaleProductNameControllers[i],
                                            padding: 8.0,
                                            // method: fnTotalPrice,
                                            // methodArg: i,
                                          ),
                                        ),

                                        Container(
                                          width: 200.0,
                                          child: autoCompleteFormInput(
                                            controller.ListCategory,
                                            "Category*",
                                            controller
                                                .SaleCategoryController[i],
                                            padding: 8.0,
                                          ),
                                        ),

                                        Container(
                                          width: 150.0,
                                          child: formInput(
                                              context,
                                              "Invoice Date",
                                              controller
                                                  .saleProductStockDate[i],
                                              padding: 8.0),
                                        ),

                                        // Price
                                        Expanded(
                                          child: formInput(
                                            context,
                                            "Price*",
                                            controller
                                                .SaleProductPriceControllers[i],
                                            padding: 8.0,
                                            isNumber: true,
                                            isFloat: true,
                                            // method: fnTotalPrice,
                                            // methodArg: i,
                                          ),
                                        ),

                                        // Quantity
                                        Expanded(
                                          child: formInput(
                                            context,
                                            "Quantity",
                                            controller
                                                .SaleProductQuntControllers[i],
                                            padding: 8.0,
                                            isNumber: true,
                                            // method:
                                            //     fnTotalPrice,
                                            // methodArg: i
                                          ),
                                        ),
                                        // Unit
                                        Expanded(
                                          child: formInput(
                                              context,
                                              "Unit/qnt.",
                                              controller
                                                      .SaleProductUnitControllers[
                                                  i],
                                              padding: 8.0,
                                              isNumber: true,
                                              // method:
                                              //     fnTotalPrice,
                                              // methodArg: i,
                                              readOnly:
                                                  (controller.readOnlyField[
                                                                  i] !=
                                                              null &&
                                                          controller
                                                              .readOnlyField[i])
                                                      ? true
                                                      : false),
                                        ),

                                        // Total
                                      ],
                                    ),
                                  ),
                                  // second row
                                  Row(
                                    children: [
                                      // Location
                                      Container(
                                        width: 200,
                                        child: autoCompleteFormInput(
                                            controller.RackList,
                                            "Item Location *",
                                            controller
                                                .productLocationController[i],
                                            padding: 8.0,
                                            isPreloadInput: (controller
                                                                .totalIdentifire[
                                                            i] !=
                                                        null &&
                                                    controller.totalIdentifire[
                                                            i] ==
                                                        true)
                                                ? true
                                                : false),
                                      ),

                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                260,
                                        child:

                                            // attributes ========
                                            (controller.dynamicControllers[
                                                        '$i'] !=
                                                    null)
                                                ? Row(
                                                    children: [
                                                      for (String key
                                                          in controller
                                                              .dynamicControllers[
                                                                  '$i']
                                                              .keys)
                                                        Expanded(
                                                          child: autoCompleteFormInput(
                                                              controller
                                                                      .ListAttribute[
                                                                  key
                                                                      .toLowerCase()],
                                                              "${capitalize(key)}",
                                                              controller
                                                                      .dynamicControllers[
                                                                  '$i'][key],
                                                              padding: 8.0,
                                                              isPreloadInput: (controller.totalIdentifire[
                                                                              i] !=
                                                                          null &&
                                                                      controller
                                                                              .totalIdentifire[i] ==
                                                                          true)
                                                                  ? true
                                                                  : false),
                                                        ),
                                                    ],
                                                  )
                                                : SizedBox(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ])));
        });
  }
}

// =================================================================
