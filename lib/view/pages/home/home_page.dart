import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controller/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeController>()
        ..getBanners()
        ..getProduct()
        ..getCategory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home page"),
        ),
        body: context.watch<HomeController>().isTotalLoading
            ? const CircularProgressIndicator()
            : ListView(
                children: [
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: context
                            .watch<HomeController>()
                            .listOfBanners
                            .length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(16),
                            width: MediaQuery.of(context).size.width - 48,
                            decoration: BoxDecoration(
                                color: Colors.pinkAccent,
                                borderRadius: BorderRadius.circular(24)),
                            child: Row(
                              children: [
                                context
                                            .watch<HomeController>()
                                            .listOfBanners[index]
                                            .product
                                            .image !=
                                        null
                                    ? Image.network(
                                        context
                                                .watch<HomeController>()
                                                .listOfBanners[index]
                                                .product
                                                .image ??
                                            "",
                                        height: 150,
                                        width: 166,
                                      )
                                    : const SizedBox.shrink(),
                                Column(
                                  children: [
                                    Text(context
                                        .watch<HomeController>()
                                        .listOfBanners[index]
                                        .title),
                                    Text(context
                                            .watch<HomeController>()
                                            .listOfBanners[index]
                                            .product
                                            .name ??
                                        ""),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: SizedBox(
                      height: 180,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: context
                              .watch<HomeController>()
                              .listOfCategory
                              .length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.all(16),
                              width:
                                  (MediaQuery.of(context).size.width - 48) / 3,
                              decoration: BoxDecoration(
                                  color: Colors.pinkAccent,
                                  borderRadius: BorderRadius.circular(24)),
                              child: Column(
                                children: [
                                  context
                                              .watch<HomeController>()
                                              .listOfCategory[index]
                                              .image !=
                                          null
                                      ? Image.network(
                                          context
                                                  .watch<HomeController>()
                                                  .listOfCategory[index]
                                                  .image ??
                                              "",
                                          height: 64,
                                        )
                                      : const SizedBox.shrink(),
                                  Column(
                                    children: [
                                      Text(context
                                              .watch<HomeController>()
                                              .listOfCategory[index]
                                              .name ??
                                          ""),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                      itemCount:
                          context.watch<HomeController>().listOfProduct.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(16),
                          width: double.infinity,
                          color: Colors.pinkAccent,
                          child: Row(
                            children: [
                              context
                                          .watch<HomeController>()
                                          .listOfProduct[index]
                                          .image ==
                                      null
                                  ? const SizedBox.shrink()
                                  : Image.network(
                                      context
                                              .watch<HomeController>()
                                              .listOfProduct[index]
                                              .image ??
                                          "",
                                      height: 64,
                                      width: 64,
                                    ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(context
                                            .watch<HomeController>()
                                            .listOfProduct[index]
                                            .name ??
                                        ""),
                                    Text(context
                                            .watch<HomeController>()
                                            .listOfProduct[index]
                                            .desc ??
                                        ""),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Text(context
                                  .watch<HomeController>()
                                  .listOfProduct[index]
                                  .price
                                  .toString())
                            ],
                          ),
                        );
                      })
                ],
              ));
  }
}
