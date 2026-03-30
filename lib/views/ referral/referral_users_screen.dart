import 'package:qrpay/language/language_controller.dart';

import '../../controller/referral_status/referral_status_controller.dart';
import '../../utils/basic_screen_imports.dart';
import '../../widgets/appbar/appbar_widget.dart';
import '../../widgets/text_labels/title_heading5_widget.dart';

class ReferralUsersScreen extends StatelessWidget {
  ReferralUsersScreen({
    super.key,
  });
  final controller = Get.put(ReferralStatusController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: const AppBarWidget(text: Strings.referralStatus),
        body: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.paddingHorizontalSize,
          ),
          children: [
            TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: Get.find<LanguageController>().getTranslation(
                  Strings.searchReferralUsers,
                ),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius * 1.4),
                  borderSide: BorderSide(color: CustomColor.primaryLightColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius * 1.4),
                  borderSide: BorderSide(color: CustomColor.primaryLightColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius * 1.4),
                  borderSide: BorderSide(color: CustomColor.primaryLightColor),
                ),
              ),
              onChanged: (v) {
                controller.filterUsers();
              },
            ),
            verticalSpace(Dimensions.heightSize),
            Column(
              children: controller.referUsers.isEmpty
                  ? [
                      Center(
                        child: TitleHeading4Widget(
                          text: Strings.noReferralUsers,
                          color: CustomColor.primaryDarkColor,
                        ),
                      ),
                    ]
                  : List.generate(
                      controller.referUsers.length,
                      (index) {
                        var refer = controller.referUsers[index];
                        return Container(
                          padding: EdgeInsets.all(Dimensions.paddingSize * 0.5),
                          margin: EdgeInsets.only(
                            bottom: Dimensions.heightSize * 0.6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius * 1.5),
                            color: Get.isDarkMode
                                ? CustomColor.primaryBGDarkColor
                                : Colors.white,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: crossStart,
                                  children: [
                                    TitleHeading3Widget(text: refer.username),
                                    verticalSpace(Dimensions.heightSize * 0.3),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: Dimensions.radius * 0.3,
                                          backgroundColor: CustomColor
                                              .blackColor
                                              .withOpacity(alpha:0.3),
                                        ),
                                        horizontalSpace(
                                            Dimensions.widthSize * 0.4),
                                        TitleHeading5Widget(text: refer.email),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: Dimensions.radius * 0.3,
                                          backgroundColor: CustomColor
                                              .blackColor
                                              .withOpacity(alpha:0.3),
                                        ),
                                        horizontalSpace(
                                          Dimensions.widthSize * 0.4,
                                        ),
                                        TitleHeading5Widget(
                                          text: refer.fullMobile,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              TitleHeading5Widget(text: refer.referralId)
                            ],
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
