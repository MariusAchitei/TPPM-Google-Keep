import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:keep/json/note.dart';
import 'package:keep/pages/home_page.dart';
import 'package:keep/theme/colors.dart';
import 'package:keep/utils/JsonUtils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CardDetailPage extends StatefulWidget {
  Note? note;
  // final int noteId;
  final VoidCallback refreshMainPage;
  // String title;
  // String description;

  CardDetailPage(
      {required this.refreshMainPage,
      // required this.noteId,
      // required this.title,
      // required this.description
      required this.note});

  @override
  _CardDetailPageState createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    _titleController.text = widget.note!.title;
    _descriptionController.text = widget.note!.description;
    super.initState();
    // JsonUtils.loadNotes().then((value) {
    //   setState(() {
    //     widget.note =
    //         value.firstWhere((element) => element.id == widget.noteId);
    //     _titleController.text = widget.note == null ? "" : widget.note!.title;
    //     _descriptionController.text =
    //         widget.note == null ? "" : widget.note!.description;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardColor,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100), child: getAppBar()),
      body: getBody(),
      bottomSheet: getFooter(),
    );
  }

  Widget getAppBar() {
    return AppBar(
      backgroundColor: cardColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          // JsonUtils.loadNotes().then((value) => setState(() {
          //       print("va salut de la back button");
          //       print(value);
          //     }));
          Navigator.pop(context);
          widget.refreshMainPage();
        },
        icon: Icon(
          Icons.arrow_back_ios,
          size: 22,
          color: white.withOpacity(0.7),
        ),
      ),
      actions: [
        IconButton(
          onPressed: null,
          icon: Icon(
            MaterialCommunityIcons.pin,
            color: white.withOpacity(0.7),
            size: 22,
          ),
        ),
        IconButton(
          onPressed: null,
          icon: Icon(
            MaterialIcons.notifications,
            color: white.withOpacity(0.7),
            size: 22,
          ),
        ),
        IconButton(
          onPressed: null,
          icon: Icon(
            Icons.archive,
            color: white.withOpacity(0.7),
            size: 22,
          ),
        )
      ],
    );
  }

  Widget getBody() {
    return ListView(
      padding: EdgeInsets.only(top: 25, right: 15, bottom: 25, left: 15),
      children: [
        TextField(
          onChanged: (value) {
            print("value: $value");
            // setState(() {
            JsonUtils.updateNoteTitleFromJson(widget.note!.id, value)
                .then((value) => null);
            // })
            widget.note!.title = value;
          },
          controller: _titleController,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 22,
              color: white.withOpacity(0.8)),
          decoration: InputDecoration(border: InputBorder.none),
        ),
        TextField(
          onChanged: (value) {
            print("value: $value");
            // setState(() {
            JsonUtils.updateNoteDescriptionFromJson(widget.note!.id, value)
                .then((value) => null);

            widget.note!.description = value;
            // })
          },
          maxLines: 10,
          controller: _descriptionController,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              height: 1.5,
              color: white.withOpacity(0.8)),
          decoration: InputDecoration(border: InputBorder.none),
        ),
        Container()
      ],
    );
  }

  Widget getFooter() {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 80,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: black.withOpacity(0.2), spreadRadius: 1, blurRadius: 3)
        ],
        color: cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25, right: 10, left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: null,
              icon: Icon(
                AntDesign.plussquareo,
                size: 22,
                color: white.withOpacity(0.7),
              ),
            ),
            Text(
              "Edited Apr 3",
              style: TextStyle(fontSize: 12, color: white.withOpacity(0.7)),
            ),
            IconButton(
              onPressed: null,
              icon: Icon(
                Octicons.kebab_vertical,
                size: 22,
                color: white.withOpacity(0.7),
              ),
            )
          ],
        ),
      ),
    );
  }
}
