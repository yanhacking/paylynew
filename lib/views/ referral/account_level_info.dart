import '../../controller/referral_status/referral_status_controller.dart';
import '../../utils/basic_screen_imports.dart';
import 'level_card_widget.dart';

class AccountLevelInfo extends StatelessWidget {
  AccountLevelInfo({super.key});
  final controller = Get.put(ReferralStatusController());
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleHeading3Widget(
          text: Strings.accountLevel,
        ),
        verticalSpace(Dimensions.heightSize),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: controller.referInfoModel.data.accountLevels.length,
          itemBuilder: (context, index) {
            final levelData =
                controller.referInfoModel.data.accountLevels[index];
            return LevelCard(
              level: levelData.title,
              refers: levelData.referUser.toString(),
              deposit:
                  '${levelData.depositAmount} ${controller.referInfoModel.data.basic.currencyCode}',
              commission: levelData.commission.toString(),
              active: levelData.active,
            );
          },
        ),
      ],
    );
  }
}
