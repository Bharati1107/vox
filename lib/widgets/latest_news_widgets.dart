// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../utils/constant.dart';

class LatestNewsWidget extends StatelessWidget {
  dynamic headline;
  LatestNewsWidget(
    this.headline, {
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      headline['Headline'] == ''
                          ? Container()
                          : Text(
                              '${headline['Headline']}',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Text(
                            "15 mins ago",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          // Icon(
                          //   Icons.bookmark_outlined,
                          //   color: orange,
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  child: Image.network(
                    headline['Image'], // Replace with your image URL
                    fit: BoxFit.cover,
                    height: 120,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return Center(
                          child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                        valueColor: AlwaysStoppedAnimation<Color>(orange),
                      ));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
