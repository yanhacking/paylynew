import '/backend/utils/custom_loading_api.dart';
import '../../controller/referral_status/referral_status_controller.dart';
import '../../utils/basic_screen_imports.dart';
import '../../widgets/appbar/appbar_widget.dart';
import '../../widgets/text_labels/title_heading5_widget.dart';
import 'account_level_info.dart';
import 'profile_account_info.dart';
import 'referral_users_screen.dart';

class ReferralStatusScreen extends StatefulWidget {
  const ReferralStatusScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReferralStatusScreenState createState() => _ReferralStatusScreenState();
}

class _ReferralStatusScreenState extends State<ReferralStatusScreen> {
  final controller = Get.put(ReferralStatusController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(text: Strings.referralStatus),
      body: Obx(
        () => controller.isLoading
            ? const CustomLoadingAPI()
            : _bodyWidget(context),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Dimensions.paddingSize * 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileAccountInfo(),
          verticalSpace(Dimensions.heightSize * 1.5),
          AccountLevelInfo(),
          verticalSpace(Dimensions.heightSize * 1.5),
          ReferralUsersSection(),
        ],
      ),
    );
  }
}

class ReferralUsersSection extends StatelessWidget {
  ReferralUsersSection({
    super.key,
  });
  final controller = Get.put(ReferralStatusController());
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TitleHeading3Widget(
              text: Strings.referralUsers,
            ),
            InkWell(
              onTap: () {
                  

                 Get.to(() => ReferralUsersScreen());  
                 

              },
              child: TitleHeading5Widget(
                text: Strings.viewAll,
                color: CustomColor.primaryLightColor,
              ),
            ),
          ],
        ),
        verticalSpace(Dimensions.heightSize),
        Column(
          children: List.generate(
            controller.referUsers.length, 
            (index) {
              var refer = controller.referUsers[index];
              return Container(
                padding: EdgeInsets.all(Dimensions.paddingSize * 0.5),
                margin: EdgeInsets.only(
                  bottom: Dimensions.heightSize * 0.6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
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
                                backgroundColor: 
                                    CustomColor.blackColor.withOpacity(0.3),
                              ),
                              horizontalSpace(Dimensions.widthSize * 0.4), 
                              TitleHeading5Widget(text: refer.email), 
                            ],
                          ),  
                        

                          Row(
                            children: [
                              CircleAvatar(
                                radius: Dimensions.radius * 0.3,
                                backgroundColor:
                                    CustomColor.blackColor.withOpacity(0.3),
                              ),
                              horizontalSpace(Dimensions.widthSize * 0.4),
                              TitleHeading5Widget(text: refer.fullMobile),
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
    );
  }
}
