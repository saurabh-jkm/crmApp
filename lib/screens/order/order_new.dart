import 'package:flutter/material.dart';
import '../../responsive.dart';
import '../dashboard/components/header.dart';
import '../../themes/style.dart';
import '../../themes/theme_widgets.dart';

class orderNewSreen extends StatefulWidget {
  const orderNewSreen({super.key});

  @override
  State<orderNewSreen> createState() => _orderNewSreenState();
}

class _orderNewSreenState extends State<orderNewSreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Order"),
          backgroundColor: themeBG2,
        ),
        body: ListView(
          children: [
            // Header(
            //   title: "Order",
            // ),
            wd_buyer_details(context),
            SizedBox(height: 20.0),
            wd_add_product(context),
          ],
        ));
  }

  // buyer details ======================================================
  // buyer details ======================================================
  Widget wd_buyer_details(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      //decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Buyer Details"),

          // dropdown
          SizedBox(height: 10.0),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 200,
                child: Container(
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Select Company",
                        labelText: 'Select Company'),
                    onChanged: (String? newValue) {},
                    items: <String>['One', 'Two', 'Free', 'Four']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Text("OR"),
              SizedBox(width: 10.0),
              themeBtnSm(context,
                  label: 'New',
                  icon: Icons.add,
                  buttonColor: themeBG,
                  borderRadius: 2.0,
                  btnSize: Size(100, 40)),
            ],
          ),
        ],
      ),
    );
  }

  // Add Product Cib ======================================================
  // Add Product Cib ======================================================
  Widget wd_add_product(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      //decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Add Product"),
          SizedBox(height: 20.0),
          // dropdown
          SizedBox(height: 10.0),
          wd_added_product_list(context),
          SizedBox(height: 10.0),
          Center(
            child: Container(
              child: Icon(
                Icons.add_circle_outline,
                size: 40.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

// added product list ======================================================
// added product list ======================================================
  Widget wd_added_product_list(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          wd_rows(context, 'Product', 'Quantity', 'Price', 'GST', 'Discount',
              'total',
              bg: true),
        ],
      ),
    );
  }

//PRODUCT ROW ======================================================
//PRODUCT ROW ======================================================
  Widget wd_rows(BuildContext context, td1, td2, td3, td4, td5, td6,
      {bg: false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 3.0),
      decoration: BoxDecoration(
          color: (!bg) ? Colors.transparent : themeBG,
          border: Border(bottom: BorderSide(width: 1.0, color: Colors.white))),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Text(
              "$td1",
              style: themeTextStyle(size: 10.0, color: Colors.white),
            ),
          ),
          // quntity
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Text(
              "$td3",
              style: themeTextStyle(size: 10.0, color: Colors.white),
            ),
          ),
          // price
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Text(
              "$td3",
              style: themeTextStyle(size: 10.0, color: Colors.white),
            ),
          ),
          // gst
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Text(
              "$td4",
              style: themeTextStyle(size: 10.0, color: Colors.white),
            ),
          ),
          // Discount
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Text(
              "$td5",
              style: themeTextStyle(size: 8.0, color: Colors.white),
            ),
          ),
          // Total
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Text(
              "$td6",
              style: themeTextStyle(size: 10.0, color: Colors.white),
            ),
          ),
          // Action
          SizedBox(
            child: Text(
              "Action",
              style: themeTextStyle(size: 10.0, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
} // end main build
