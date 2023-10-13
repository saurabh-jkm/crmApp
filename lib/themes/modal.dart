// // ignore_for_file: camel_case_types, avoid_print, unused_catch_clause, depend_on_referenced_packages

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// import 'style.dart';

// class themeModal {
//   themeModal._();

//   static fnFindDynamic(context, jsonBody, {action = 'find_dynamic'}) async {
//     var url = Uri.parse('https://insaaf99.com/api');
//     var bodyContent = jsonBody;
//     bodyContent['apikey'] =
//         '80898ajadsfjdsaf89ad456uug444sfsd8f9asfd989df89sfd8a8f9df';
//     bodyContent['action'] = '$action';
//     var response = await http.post(
//       url,
//       body: bodyContent,
//     );
//     //_fnGetPartnerId(_selfId);

//     if (response.statusCode == 200) {
//       try {
//         var tempRetrunData = jsonDecode(response.body) as Map<dynamic, dynamic>;
//         if (tempRetrunData['error'] != null) {
//           // themeAlert(context, 'Error : ${tempRetrunData['error']}',
//           //     type: 'error');
//         }
//         return tempRetrunData;
//       } on FormatException catch (e) {
//         print(response.body);
//         themeAlert(context, 'Error : Api Error', type: 'error');
//       }
//     } else {
//       themeAlert(context, 'Error : ${response.body}', type: 'error');
//       print(response.body);
//     }
//   }
// }
