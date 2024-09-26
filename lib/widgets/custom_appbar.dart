import 'package:flutter/material.dart';

PreferredSizeWidget customAppBar(BuildContext context, {String title = '', List<Widget>? actions,}){
  return AppBar(
    toolbarHeight: 90,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(100)
      ),
    ),
    flexibleSpace: Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(60)
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blueAccent[700]!,
            Colors.lightBlueAccent,
          ],
        )
      ),
    ),
    bottom: PreferredSize(
      preferredSize: Size(
        MediaQuery.of(context).size.width,
        50,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.w300),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: actions ?? [],
            )
          ],
        ),
      )
    ),
  );
}