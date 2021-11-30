import 'package:bachelor_room/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingRoomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width * 0.4;
    return AspectRatio(
      aspectRatio: 1.6,
      child: Card(
        color: MColors.cardColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MConstants.descBorRad)),
        child: Shimmer.fromColors(
          baseColor: Colors.white38,
          highlightColor: MColors.cardColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                margin: const EdgeInsets.all(13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MConstants.descBorRad),
                ),
                child: Container(
                  width: _width,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Card(
                        margin: const EdgeInsets.all(13),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(MConstants.descBorRad),
                        ),
                        child: Container(
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    textLoad(80),
                    textLoad(70),
                    textLoad(100),
                    textLoad(140),
                    Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Card(
                        margin: const EdgeInsets.all(13),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(MConstants.descBorRad),
                        ),
                        child: Container(
                          width: 90,
                          height: 35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card textLoad(double width) {
    return Card(
      child: Container(
        width: width,
        height: 10,
      ),
    );
  }
}
