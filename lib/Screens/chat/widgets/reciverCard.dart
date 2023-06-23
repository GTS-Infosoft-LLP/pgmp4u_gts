import 'package:flutter/material.dart';

class RecivedMessageCard extends StatefulWidget {
  const RecivedMessageCard({key});

  @override
  State<RecivedMessageCard> createState() => _RecivedMessageCardState();
}

class _RecivedMessageCardState extends State<RecivedMessageCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 4.0, bottom: 8.0),
          // child: profileImg(
          //   image: widget.messageModel.profileLink,
          //   width: 20,
          //   height: 20,
          // ),
          child: CircleAvatar(
            radius: 10,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.4),
              decoration: const BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text('',
                    style: Theme.of(context).textTheme.titleSmall.copyWith(
                          color: Colors.black,
                        )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 5),
              child: Text('12:03',
                  style: Theme.of(context).textTheme.labelSmall.copyWith(
                        color: Colors.grey,
                      )),
            ),
          ],
        ),
      ],
    );
  }
}
