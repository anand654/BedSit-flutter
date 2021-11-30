import 'package:bachelor_room/utils/colors.dart';
import 'package:flutter/material.dart';

class DescriptionInfo extends StatelessWidget {
  final String rent;
  final String deposit;
  final String address;
  DescriptionInfo({
    @required this.rent,
    @required this.deposit,
    @required this.address,
  });
  @override
  Widget build(BuildContext context) {
    final _list = address.split(",");
    final int _length = _list.length;
    final _removed = _list.sublist(0, _length - 2);
    final String _res = _removed.join();

    return Card(
      margin: const EdgeInsets.only(
        top: 15,
        right: 10,
      ),
      color: MColors.cardColor,
      elevation: MConstants.noelevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MConstants.descBorRad),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CTitleCentre('rent', '₹${rent ?? ''}/-'),
                  const VerticalDivider(
                    thickness: 1,
                    indent: 8,
                    endIndent: 2,
                  ),
                  CTitleCentre('deposit', '₹${deposit ?? ''}/-'),
                  const VerticalDivider(
                    thickness: 1,
                    indent: 8,
                    endIndent: 2,
                  ),
                  CTitleCentre('area', '~ sqft'),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              indent: 15,
              endIndent: 15,
            ),
            _titelSideDesc('address', _res)
          ],
        ),
      ),
    );
  }
}

Widget contactTime(String clFrom, String clTo) {
  return Row(
    children: [
      Card(
        margin: const EdgeInsets.only(
          top: 15,
          right: 10,
        ),
        color: MColors.cardColor,
        elevation: MConstants.noelevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MConstants.descBorRad),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 50,
            top: 8,
            bottom: 8,
          ),
          child: _titelSideCT('contact time',
              clFrom == null ? '    anytime' : '    $clFrom - $clTo'),
        ),
      ),
      SizedBox(
        width: 20,
      ),
      Text(
        'you can contact\nat this hour',
        style: MTextStyle.subtitleText,
      ),
    ],
  );
}

class CDescOverView extends StatelessWidget {
  final bool parking;
  final bool nonVeg;
  const CDescOverView({
    @required this.parking,
    @required this.nonVeg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: const EdgeInsets.only(
          top: 15,
          right: 10,
        ),
        color: MColors.cardColor,
        elevation: MConstants.noelevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MConstants.descBorRad),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 10,
                ),
                child: Text(
                  'overview',
                  style: MTextStyle.titleText,
                ),
              ),
            ),
            const Divider(
              thickness: 1,
              indent: 15,
              endIndent: 15,
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CTitleCentre(
                    'Bike Parking',
                    parking ? 'YES' : 'NO',
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    indent: 8,
                    endIndent: 2,
                  ),
                  CTitleCentre(
                    'Non Veg',
                    '-',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class CCallBtn extends StatelessWidget {
  final String title;
  final VoidCallback onpressed;
  const CCallBtn({
    @required this.title,
    @required this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: ElevatedButton(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.call,
              color: MColors.whiteColor,
            ),
            Text(
              'call',
              style: MTextStyle.headerText,
            ),
          ],
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(MColors.redButtonColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MConstants.descBorRad),
            ),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 18,
            ),
          ),
        ),
        onPressed: onpressed,
      ),
    );
  }
}

class CTitleCentre extends StatelessWidget {
  final String title;
  final String subtitle;
  const CTitleCentre(
    this.title,
    this.subtitle,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: '$title\n',
              style: MTextStyle.titleText,
            ),
            TextSpan(
              text: subtitle,
              style: MTextStyle.subtitleText.copyWith(
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _titelSideDesc(String title, String subtitle) {
  return RichText(
    softWrap: true,
    text: TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: '$title\n',
          style: MTextStyle.titleText,
        ),
        TextSpan(
          text: subtitle,
          style: MTextStyle.subtitleText.copyWith(
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

Widget _titelSideCT(String title, String subtitle) {
  return RichText(
    softWrap: true,
    text: TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: '$title\n',
          style: MTextStyle.titleText,
        ),
        TextSpan(
          text: subtitle,
          style: MTextStyle.subtitleText.copyWith(
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}
