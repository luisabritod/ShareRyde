import 'package:flutter/material.dart';

class SearchDestinationPage extends StatefulWidget {
  const SearchDestinationPage({super.key});

  @override
  State<SearchDestinationPage> createState() => _SearchDestinationPageState();
}

class _SearchDestinationPageState extends State<SearchDestinationPage> {
  TextEditingController pickupLocationTextEditingController =
      TextEditingController();
  TextEditingController destinationLocationTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 10,
              child: Container(
                height: 220,
                decoration: const BoxDecoration(
                  color: Color(0xffEFEFEF),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff414141),
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    top: 48,
                    right: 24,
                    bottom: 20,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Color(0xff0C849B),
                            ),
                          ),
                          const Center(
                            child: Text(
                              'Set Destination',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff0C849B),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/initial.png',
                            height: 16,
                            width: 16,
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xff414141).withOpacity(0.35),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Pickup Location',
                                    hintStyle: const TextStyle(
                                      color: Color(0xffEFEFEF),
                                    ),
                                    fillColor: const Color(0xff414141)
                                        .withOpacity(0.35),
                                    filled: true,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.only(
                                      left: 11,
                                      top: 8,
                                      bottom: 8,
                                    ),
                                  ),
                                  controller:
                                      pickupLocationTextEditingController,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/final.png',
                            height: 16,
                            width: 16,
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xff414141).withOpacity(0.35),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Destination Location',
                                    hintStyle: const TextStyle(
                                      color: Color(0xffEFEFEF),
                                    ),
                                    fillColor: const Color(0xff414141)
                                        .withOpacity(0.35),
                                    filled: true,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.only(
                                      left: 11,
                                      top: 8,
                                      bottom: 8,
                                    ),
                                  ),
                                  controller:
                                      destinationLocationTextEditingController,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
