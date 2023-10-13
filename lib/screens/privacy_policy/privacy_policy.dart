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
                "Privacy Policy for JKM CRM APP\n\n\n\n\nEffective Date: 13/10/2023\n\n1. Introduction\n\nWelcome to JKM CRM (we, us, or our). This Location Tracking Privacy Policy explains how we collect, use, and safeguard location information when you use our app for tracking salesmen.\n\n2. Collection of Location Information\n\nUser Consent: We collect location information solely for the purpose of tracking the movements of our salesmen. Users are not required to register in the app. Location tracking only occurs with the consent of the salesmen whose devices have the app installed.\n\nTypes of Location Data: Our app collects precise location information, including GPS coordinates, to provide accurate tracking services for salesmen.\n\n3. How We Use Location Data\n\nWe use the location information we collect for the following purposes:\n\nSalesman Tracking: To provide real-time location tracking of our salesmen, facilitating route optimization and management.\n\nImprovements: To enhance the performance and accuracy of our tracking features.\n\nSecurity: To ensure the safety and security of our salesmen while they are on duty.\n\n4. Data Sharing and Disclosure\n\nWe do not share location data with third parties :\n\nConsent: Salesmen give their explicit consent for location tracking.\n\nLegal Requirement: We may share location data when required by law or legal process.\n\n5. Data Security\n\nWe take the security of location data seriously and implement industry-standard security measures to protect it from unauthorized access, disclosure, alteration, or destruction.\n\n6. Your Rights\n\nSalesmen have the right to:\n\nControl location services through device settings.\n\nOpt-out of location tracking by uninstalling the app, although this may affect their ability to be tracked for work-related purposes.\n\n7. Changes to This Policy\n\nWe may update this Location Tracking Privacy Policy to reflect changes in our practices or for legal, regulatory, or operational reasons. Any significant changes will be communicated to salesmen using the app.\n\n8. Personal and Sensitive User Data \n\nWe Don't Take any User Personal information Because User (Salesmen) no have any Regsitration option in my App. Only they Salesmen can login in JKM CRM app who is already registerd in Organization Website. \n\n\n8. Contact Us\n\nIf you have questions or concerns about this Location Tracking Privacy Policy or your location data, please contact us at +91-999-000-5441 OR email insaaf99.com@gmail.com."),
          ],
        ),
      ),
    );
  }
}
