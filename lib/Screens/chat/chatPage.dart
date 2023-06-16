import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'chatModel.dart';

class ChatPage extends StatefulWidget {
    var v1;
   ChatPage({Key key,this.v1}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  TextEditingController chatController = TextEditingController();
  ScrollController chatListController=ScrollController();

  Widget build(BuildContext context) {
        final Size size = MediaQuery.of(context).size;
    return Scaffold(
    appBar:  AppBar(
        title: Text(
          widget.v1,  style: TextStyle(
                                    //  fontSize: width * (18 / 420),
                                    fontFamily:  'Roboto Medium',
                                     color: Colors.white,
                                    ),
        ),
flexibleSpace: Container(
  decoration: BoxDecoration(
gradient:  LinearGradient(
                               colors: [
                                                       _colorfromhex("#3A47AD"),
                                                        _colorfromhex("#5163F3"),
                                                        ],
                                                        begin: const FractionalOffset(
                                                        0.0, 0.0),
                                                       end: const FractionalOffset( 1.0, 0.0),
                                                       stops: [0.0, 1.0],
                                                        tileMode: TileMode.clamp),

   ),
),

      ),


body: SingleChildScrollView(

child: Column(children: [
  Container(
     height: size.height / 1.25,
              width: size.width,
              // color: Colors.amber,
  ),

Container(
 height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              // color: Colors.blue,
              child: Container(
                 height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                       height: size.height / 17,
                      width: size.width / 1.3,
child: TextField(
  controller: chatController,
  decoration: InputDecoration(
       hintText: "Send Message",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
  ),
),

    

            IconButton(
                        icon: Icon(Icons.send), onPressed: (){}),  

                  ],
                ),
              ),

)




]),

),

    );
  }


     Widget senderChatWidget(ChatModel chatModel) {
        final Size size = MediaQuery.of(context).size;
         var d = DateTime.fromMillisecondsSinceEpoch(chatModel.messageDate ?? 0);
     return Container(width: size.width,
     alignment: chatModel.sendBy==1?Alignment.centerRight
                : Alignment.centerLeft,
                child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue,
                ),
                child: Text(chatModel.message,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                ),
                ),
     );
     
     
     }








  
 Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}