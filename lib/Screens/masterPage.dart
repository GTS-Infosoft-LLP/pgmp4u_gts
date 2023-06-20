import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pgmp4u/Screens/home_view/application_support.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:pgmp4u/tool/ShapeClipper.dart';
import 'package:provider/provider.dart';

import '../utils/app_color.dart';
import 'MockTest/mockTest.dart';
import 'PracticeTests/practiceTest copy.dart';
import 'home_view/VideoLibrary/RandomPage.dart';
import 'home_view/flash_card_item.dart';
import 'home_view/video_library.dart';

class MasterListPage extends StatefulWidget {
  const MasterListPage({Key key}) : super(key: key);

  @override
  State<MasterListPage> createState() => _MasterListPageState();
}

class _MasterListPageState extends State<MasterListPage> {
  @override

  IconData icon1;


void initState() {
    CourseProvider courseProvider=Provider.of(context,listen: false);
    print("master list===${courseProvider.masterList}");

    if(courseProvider.masterList.isEmpty){
      print("list is empty");  
    }





    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
         body: Container(
        color: Color(0xfff7f7f7),
        
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Stack(
              children: [
                ClipPath(
clipper: ShapeClipper(),
child: Container(
  height: 150,
    decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                        ),

),

                ),
           

            Container(

           child: Padding(
             padding: EdgeInsets.fromLTRB(20, 50, 0, 0),
             child: Row(children: [
              Container(
                   width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                              border:
                                  Border.all(color: Colors.white, width: 1)),

                               child: Center(
                              child: IconButton( 
                                  icon: Icon(Icons.arrow_back,
                                      color: Colors.white),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  })) ),


SizedBox(width: 20,),

                      Center(
                          child: Text(
                        // "Video Library",
                        "Master Content",
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.bold),
                      )),


             ]),
           ),


            )
               ],
            ),


            SizedBox(height: 15,),


SingleChildScrollView(
  child: Column(

    children: [

      Padding(
        padding: const EdgeInsets.only(bottom:18.0),
        child: Consumer<CourseProvider>(
          builder: (context,courseProvider,child) {
            return Container(
              height: MediaQuery.of(context).size.height*.75,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: courseProvider.masterList.length,
                itemBuilder: (context,index){
                  if(courseProvider.masterList[index].type=="Videos"){
                    icon1=FontAwesomeIcons.video; 
                  }else if(courseProvider.masterList[index].type=="Flash Cards"){
                    icon1=FontAwesomeIcons.tableColumns;
                  }else if(courseProvider.masterList[index].type=="Support"){
                     icon1=FontAwesomeIcons.userGraduate;
                  } else if(courseProvider.masterList[index].type=="Mock Test"){
                    icon1= FontAwesomeIcons.bookOpenReader;
                  }else if(courseProvider.masterList[index].type=="Practice Test"){
                      icon1= FontAwesomeIcons.book;
                  }
                  
                  else{
                     icon1=(Icons.edit);
                  }
                    return 
                    courseProvider.masterList.isNotEmpty?
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:18.0,),
                      child: Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: Container(
                                       height: 55,
                                  //  color: Colors.amber,
                                   decoration: BoxDecoration(
                                      // shape: BoxShape.circle,
                                      color: Colors.transparent,
                                      border: Border(
                  bottom: BorderSide(width: 1.5, color: Colors.grey[300]),
                )),
                                          // Border.all(color: Colors.black, width: 1)),
                                     child:InkWell(
                  
                                      onTap: (){
                  
                                        print("id of the master list===${courseProvider.masterList[index].id}");
                                        String page=courseProvider.masterList[index].type;
                                        print("page=====${page}");
                  
                                        if(page=="Videos"){
                  
                                       courseProvider.getVideoCate(courseProvider.masterList[index].id);
                  
                  
                                       Future.delayed( Duration(milliseconds: 400), () {
                                                Navigator.push(context,MaterialPageRoute(builder: (context)=>VideoLibraryPage()));
                  
                                         });
                  
                                        }
                  
                                        if(page=="Support"){
                                          Navigator.push(context,MaterialPageRoute(builder: (context)=>ApplicationSupportPage()));
                                        }
                  
                  
                                        if(page=="Flash Cards"){
                                          courseProvider.getFlashCate(courseProvider.masterList[index].id);


                                            Future.delayed( Duration(milliseconds: 400), () {
                                          Navigator.push(context,MaterialPageRoute(builder: (context)=>FlashCardItem()));

                                                   });
                  
                                        }
                  
                                        if(page=="Mock Test"){
                                          Navigator.push(context,MaterialPageRoute(builder: (context)=>MockTest()));
                                        }
                  
                                        if(page=="Practice Test"){
                                          Navigator.push(context,MaterialPageRoute(builder: (context)=>PracticeTestCopy()));
                                        }
                  
                  
                  
                  
                  
                                        
                  
                  
                   
                  
                  
                  
                                      },
                                       child: Row(children: [
                                     
                                        SizedBox(
                                          width: 15,
                                        ),
                                     
                                        Container(
                                          height: 45,
                                          width: 45,
                  
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: index % 2 == 0
                                              ? AppColor.purpule
                                              : AppColor.green,
                              // gradient: LinearGradient(
                              //     begin: Alignment.topLeft,
                              //     end: Alignment.bottomRight,
                              //     colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                            ),
                  
                  
                  
                                   
                  
                                          // color: Colors.black,
                                          child: 
                                           
                                              
                                        
                                            
                                          
                                          Icon( icon1,color: Colors.white,)
                                            // Icons.edit,color: Colors.white),
                                        ),
                                     
                                     
                                         SizedBox(
                                          width: 15,
                                        ),
                                     
                                        Text(courseProvider.masterList[index].name,
                                        style: TextStyle(
                                                                   fontSize: 18,
                                                                   color: Colors.black,
                                                                 ),
                                        
                                        )
                                     
                                     
                                     
                                     
                                       ],),
                                     )
                                      
                                      
                                      
                           
                                      
                        ),
                      ),
                    ):
                    Center(child: Text("No Data Found",style: TextStyle(color: Colors.black,fontSize: 18)),);  
              }),
            );
          }
        ),
      ),


      // SizedBox(height: 20,)
 
   

    ],
  ),),

    //  SizedBox(height: 20,)
             

          ],
        ),
        
        ),   

    );
  }
}