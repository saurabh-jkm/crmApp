
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_returning_null_for_void, no_leading_underscores_for_local_identifiers, avoid_print, non_constant_identifier_names, unnecessary_string_interpolations, sized_box_for_whitespace


import 'package:flutter/material.dart';
import '../../constants.dart';
import 'components/header.dart';
import 'components/my_fields.dart';
import 'components/recent_files.dart';


class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  //////Crosss file picker
  final GlobalKey exportKey = GlobalKey();

var hhh ;

@override
void initState() {
    super.initState();
  }


  /////
  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      body: 
      Container(
        padding: EdgeInsets.all(defaultPadding),
        child: ListView(
          children: [
            Header(title: "Dashboard",),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      MyFiles(),
                      SizedBox(height: defaultPadding),
                      RecentFiles(),
                      // if (Responsive.isMobile(context))
                      //   SizedBox(height: defaultPadding),
                      // if (Responsive.isMobile(context)) 
                      // StarageDetails(),
                    ],
                  ),
                ),
                // if (!Responsive.isMobile(context))
                //   SizedBox(width: defaultPadding),
                // // On Mobile means if the screen is less than 850 we dont want to show it
                // if (!Responsive.isMobile(context))
                //   Expanded(
                //     flex: 2,
                //     child: 
                //     StarageDetails(),
                //   ),
              ],
            ),



      //     ElevatedButton(onPressed: ()async{
      //         pickFile();
      //  //  listFiles();
      //          }, child: Text("Upload ImAGE")),



          ],
        ),
      ),
    );
  }

  // pickFile() async {
  //  if(!kIsWeb){
  //   final results = await FilePicker.platform.pickFiles(
  //         allowMultiple: false,
  //         type: FileType.custom,
  //         allowedExtensions: ['png','jpg'],
  //              );
  //         if(results == null){
  //           themeAlert(context, 'Not find selected', type: "error");
  //           return null;
  //         }    
  //         final path = results.files.single.path;
  //         final fileName = results.files.single.name;
  //         setState(() {
  //         print("$path+++++");
  //         print("$fileName------");
  //          UploadFile(path!,fileName).then((value) => themeAlert(context, "Upload Successfully ")); 
  //         });
  //  }
  //  else if (kIsWeb){

  //     // final ImagePicker _picker = ImagePicker();
  //     // XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //     //     if(image != null){
  //     //     String filePath = path.dirname(image.path);
  //     //     String filename = path.basename(image.name); 
  //     //     setState(() 
  //     //     {
           
  //     //      UploadFile(filePath,filename).then((value) => themeAlert(context, "Upload Successfully ")); 
  //     //     });
  //     //     }   
  //     //     else{  
  //     //     themeAlert(context, 'Not find selected', type: "error");
  //     //       return null;
  //     //     }
    
  //   //  final ImagePicker _picker = ImagePicker();
  //   //   XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   //   if (image != null) {
  //   //     var f = await image.readAsBytes();

  //   //       String filePath = path.dirname(image.path);
  //   //       String filename = path.basename(image.name); 
  //   //       String imgPath = image.path;
          
  //   //     setState(() {
  //   //       // print("$filePath+++++");
  //   //       // print("$filename------");
  //   //       // print("${image.path}oo");
  //   //      // print("$f*******");
  //   //        UploadFile(imgPath,filename).then((value) => themeAlert(context, "Upload Successfully ")); 
  //   //     });
  //   //   }
     
  //    final results = await FilePicker.platform.pickFiles(
  //         allowMultiple: false,
  //         type: FileType.custom,
  //         allowedExtensions: ['png','jpg'],
  //              );
  //         if(results != null){
  //            Uint8List? UploadImage =  results.files.single.bytes;
  //            String fileName = results.files.single.name;
  //            Reference reference = FirebaseStorage.instance
  //            .ref('media/$fileName');
  //            final UploadTask uploadTask = reference.putData(UploadImage!);
  //            uploadTask.whenComplete(() =>  themeAlert(context, "Upload Successfully "));
  //         //    String? filePath = results.files.single.path;
  //         // setState(() {
  //         // print("$fileName+++++");
  //         // print("$filePath------");
  //         //  UploadFile(filePath!,fileName).then((value) => themeAlert(context, "Upload Successfully ")); 
  //         // });

  //         }
  //         else{
  //               themeAlert(context, 'Not find selected', type: "error");
  //           return null;

  //         }    

  //   }

   // }
}
 