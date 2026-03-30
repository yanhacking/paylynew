import 'package:r_dotted_line_border/r_dotted_line_border.dart';

import '../../utils/basic_screen_imports.dart';
import 'profile_account_info.dart';

class LevelCard extends StatelessWidget {
  final String level;
  final String refers;
  final String deposit;
  final String commission;
  final bool active;

  const LevelCard({
    super.key,
    required this.level,
    required this.refers,
    required this.deposit,
    required this.commission,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? CustomColor.primaryBGDarkColor
            : CustomColor.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.radius * 1.2),
        border: active
            ? RDottedLineBorder.all(
                color: CustomColor.primaryLightColor,
              )
            : null,
        boxShadow: active
            ? [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: FittedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TitleHeading4Widget(
              text: level,
              color: CustomColor.primaryLightColor,
            ),
            verticalSpace(Dimensions.heightSize * 0.5),
            InfoRow(label: Strings.refers, value: refers),
            InfoRow(label: Strings.deposit, value: deposit),
            InfoRow(label: Strings.commission, value: commission),
          ],
        ),
      ),
    );
  }
}
