// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, unnecessary_string_interpolations, prefer_final_fields, prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unnecessary_null_comparison, sort_child_properties_last, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, depend_on_referenced_packages, avoid_print, unnecessary_new, equal_keys_in_map

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_demo/themes/theme_widgets.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

import '../../themes/firebase_functions.dart';
import '../../themes/style.dart';
import '../dashboard/components/header.dart';
import 'package:intl/intl.dart';

class privacyPolicy extends StatelessWidget {
  const privacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 140.0, vertical: 80.0),
        child: ListView(
          children: [
            Text(
                "Privacy Policy for JKM CRM APP\n\n\n\n\n1. Introduction\n\nWelcome to JKM CRM APP ('we,' 'us,' or 'our'). We are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our CRM app.\n\n2. Information We Collect\n\nPersonal Information: We may collect personal information that you provide when creating an account or using our app, such as your name, email address, phone number, and other contact details by my website only not from app, for login purpus only.\n\n Usage Information: We collect information about how you use our CRM app, including log data, device information, and analytics data.\n\nCustomer Data: In the course of using our CRM app, you may input and store customer information, including names, contact details, and other relevant data. This data is stored securely and is only accessible by authorized users.\n\n3. How We Use Your Information\n\nWe use the information we collect for the following purposes:\n\nTo provide and maintain the CRM app's functionality.\n\nTo communicate with you and respond to your inquiries.\n\nTo improve our app's performance, features, and user experience.\n\nTo ensure the security of your data and our app.\n\n4. Data Sharing and Disclosure\n\nWe may share your information in the following circumstances:\n\nWith your consent.\n\nWith our trusted service providers who assist us in app development, hosting, and maintenance.\n\nWhen required by law or legal process.\n\n5. Data Security\n\nWe take the security of your data seriously and implement industry-standard security measures to protect your information from unauthorized access, disclosure, alteration, or destruction.\n\n6. Your Rights\n\nYou have the right to:\n\nAccess, correct, or delete your personal information.\n\nOpt-out of marketing communications.\n\nRequest data portability.\n\n7. Changes to This Privacy Policy\n\nWe may update this Privacy Policy to reflect changes in our practices or for legal, regulatory, or operational reasons. We will notify you of any significant changes through the app or via email.\n\n8. Contact Us\n\nIf you have questions or concerns about this Privacy Policy or your personal information, please contact us at +91-999-000-5441 OR email insaaf99.com@gmail.com.\n\nRemember to customize this template to accurately reflect your CRM app's features, data collection practices, and contact information. Also, seek legal advice to ensure compliance with applicable privacy laws and regulations."),
          ],
        ),
      ),
    );
  }
}
