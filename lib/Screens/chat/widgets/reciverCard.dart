import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pgmp4u/Screens/chat/controller/chatProvider.dart';
import 'package:pgmp4u/Screens/chat/model/chatModel.dart';
import 'package:pgmp4u/Screens/chat/widgets/profileUrl.dart';
import 'package:pgmp4u/Screens/chat/widgets/reaction_on_message.dart';
import 'package:pgmp4u/Screens/chat/widgets/senderCard.dart';
import 'package:pgmp4u/utils/extensions.dart';
import 'package:provider/provider.dart';

class RecivedMessageCard extends StatefulWidget {
  RecivedMessageCard({key, this.chatModel, this.animationController});
  ChatModel chatModel;
  AnimationController animationController;

  @override
  State<RecivedMessageCard> createState() => _RecivedMessageCardState();
}

class _RecivedMessageCardState extends State<RecivedMessageCard> with SingleTickerProviderStateMixin {
  final layerLink = LayerLink();

  // Animation<double> _animation;
  @override
  void initState() {
    print("image:::::${widget.chatModel.image}");
    super.initState();

    // widget.animationController = AnimationController(
    //   duration: Duration(seconds: 1),
    //   vsync: this,
    // );

    // _animation = CurvedAnimation(
    //   parent: widget.animationController,
    //   curve: Curves.easeInOut,
    // );
  }

  @override
  void dispose() {
    // widget.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return CompositedTransformTarget(
      link: layerLink,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: GestureDetector(
              onLongPress: () {
                showOverLay(
                  context,
                  widget.chatModel,
                  layerLink,
                  false,
                );

                context.read<ChatProvider>().updateSelectedMessage(widget.chatModel);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 4.0, bottom: 8.0),
                    child: SizedBox(width: 24, height: 24, child: ProfilePic(image: widget.chatModel.profileUrl)),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          topRight: Radius.circular(16)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.chatModel.senderName.capitalizeFirstLetter() ?? '',
                                style: Theme.of(context).textTheme.titleSmall.copyWith(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    )),
                            Text(widget.chatModel.sentAt.toTimeOfDay().format(context) ?? '',
                                style: Theme.of(context).textTheme.titleSmall.copyWith(
                                      color: Colors.black,
                                      fontSize: 12,
                                    )),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        // Text(widget.chatModel.text ?? '',
                        //     style: Theme.of(context).textTheme.titleSmall.copyWith(
                        //           color: Color(0xff63697B),
                        //         )),
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          width: width - (width * (35 / 420) * 5),
                          child: Html(
                            data: widget.chatModel.question == null || widget.chatModel.question == ""
                                ? widget.chatModel.text
                                : widget.chatModel.question,
                            style: {
                              "body": Style(
                                padding: EdgeInsets.only(top: 5),
                                margin: EdgeInsets.zero,
                                color: Color(0xff63697B),
                                textAlign: TextAlign.left,
                                fontSize: FontSize(18),
                              )
                            },
                          ),
                        ),

                        widget.chatModel.image == null || widget.chatModel.image == ""
                            ? SizedBox()
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.chatModel.image,
                                    // mockQuestion[_quetionNo].questionDetail.image,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 78.0, vertical: 28),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                        height: MediaQuery.of(context).size.width * .4,
                                        child: Center(child: Icon(Icons.error))),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 8,
                        ),

                        widget.chatModel.options.isEmpty
                            ? SizedBox()
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.chatModel.options.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Container(
                                        width: width * (25 / 420),
                                        height: width * 25 / 420,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0xff63697B),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            width * (25 / 420),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                              index == 0
                                                  ? 'A'
                                                  : index == 1
                                                      ? 'B'
                                                      : index == 2
                                                          ? 'C'
                                                          : index == 3
                                                              ? 'D'
                                                              : 'E',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  .copyWith(color: Color(0xff63697B), fontSize: 15)),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 8),
                                        width: width - (width * (35 / 420) * 5),
                                        child: Html(
                                          data: widget.chatModel.options[index],
                                          style: {
                                            "body": Style(
                                              padding: EdgeInsets.only(top: 5),
                                              margin: EdgeInsets.zero,
                                              color: Color(0xff63697B),
                                              textAlign: TextAlign.left,
                                              fontSize: FontSize(18),
                                            )
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 2,
            left: 50,
            child: ReactionsOnMessage(chatModel: widget.chatModel),
          ),
        ],
      ),
    );
  }
}
