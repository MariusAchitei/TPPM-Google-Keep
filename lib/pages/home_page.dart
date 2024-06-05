import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:keep/json/note.dart';
import 'package:keep/pages/card_detail_page.dart';
import 'package:keep/pages/side_menu.dart';
import 'package:keep/theme/colors.dart';
import 'package:keep/utils/JsonUtils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/note_service.dart';

class HomePage extends StatefulWidget {
  List<Note> notes = [];

  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  bool _isGridView = false;
  String? _selectedLabel;
  bool _isLoading = true;

  void refreshPage(index, note) {
    setState(() {
      widget.notes![index] = note;
    });
  }

  Future<void> _loadNotes() async {
    final noteService = Provider.of<NoteService>(context, listen: false);
    await noteService.loadNotes();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
    // refreshPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: SideMenu(),
      backgroundColor: bgColor,
      body: getBody(),
      bottomSheet: getFooter(),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        backgroundColor: bgColor,
        child: Center(
          child: IconButton(
            color: white.withOpacity(0.7),
            icon: const Icon(Icons.add),
            onPressed: () async {
              var note = Note(
                  "New Note",
                  "",
                  await JsonUtils.getMaximumIdFromJson('assets/notes.json') +
                      1);
              setState(() {
                widget.notes!.add(note);
              });
              // write notes to json file
              JsonUtils.appendToJsonFile('assets/notes.json', note)
                  .then((value) => null);
            },
          ),
        ),
      ),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 50),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              width: size.width,
              height: 45,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3)
              ], color: cardColor, borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _drawerKey.currentState?.openDrawer();
                          },
                          child: Icon(
                            Icons.menu,
                            color: white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Search your notes",
                          style: TextStyle(
                              fontSize: 15, color: white.withOpacity(0.3)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  "All notes",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: white.withOpacity(0.6)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              getGridView()
            ],
          )
        ],
      ),
    );
  }

  Widget getGridView() {
    var size = MediaQuery.of(context).size;
    return Column(
      children: List.generate(widget.notes.length, (index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.scale,
                        alignment: Alignment.bottomCenter,
                        child: CardDetailPage(
                            refreshMainPage: refreshPage,
                            index: index,
                            note: widget.notes![index])))
                .then((value) {
              setState(() {});
              print("----------------------->");
              print(widget.notes![index]);
              print(
                  "ffsdhnaf;kolnsdal;kfnsda\nfmsdlkfnlskdanflksdan\nfoinsdoaifnoisdaan\mfoisdhafoinsdaoifnsdaoif\noifnsadoifnsdaoiafnsdoinfsd\nofiasdnfoinsdaoifnsd");
              // JsonUtils.loadNotes().then((value) => setState(() {
              //       widget.notes = value;
              //       print("an refreshPage()");
              //       print(value);
              //     }));
              print(widget.notes![index]);
            });
          },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: cardColor,
                    border: Border.all(color: white.withOpacity(0.1))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 12, left: 8, right: 8, bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.notes![index].title,
                        style: TextStyle(
                            fontSize: 15,
                            color: white.withOpacity(0.9),
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(widget.notes![index].description,
                          style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: white.withOpacity(0.7),
                              fontWeight: FontWeight.w400)),
                      Container()
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget getFooter() {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 80,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: black.withOpacity(0.2), spreadRadius: 1, blurRadius: 3)
      ], color: bgColor),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            children: [
              Container(
                width: size.width * 0.7,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: null,
                      icon: Icon(
                        AntDesign.checksquare,
                        size: 20,
                        color: white.withOpacity(0.5),
                      ),
                    ),
                    IconButton(
                      onPressed: null,
                      icon: Icon(
                        FontAwesome.paint_brush,
                        size: 18,
                        color: white.withOpacity(0.5),
                      ),
                    ),
                    IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.mic_rounded,
                        size: 22,
                        color: white.withOpacity(0.5),
                      ),
                    ),
                    IconButton(
                      onPressed: null,
                      icon: Icon(
                        MaterialIcons.photo,
                        size: 22,
                        color: white.withOpacity(0.5),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
