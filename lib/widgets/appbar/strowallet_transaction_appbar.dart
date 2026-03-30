import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/utils/custom_color.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/widgets/text_labels/title_heading4_widget.dart';

import '../../language/english.dart';
import '../../routes/routes.dart';
import '../text_labels/title_heading3_widget.dart';
import 'back_button.dart';

class StrowalletTransactionAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final String text;
  final VoidCallback? onTapLeading;

  final bool homeButtonShow;
  final IconData? actionIcon;

  const StrowalletTransactionAppbar(
      {required this.text,
      this.onTapLeading,

      this.homeButtonShow = false,
      this.actionIcon,
      super.key});

  @override
  Widget build(BuildContext context) {
    bool isTablet() {
      return MediaQuery.of(context).size.shortestSide >= 600;
    }

    return AppBar(
      title: TitleHeading4Widget(
        text: text,
        fontSize: isTablet()
            ? Dimensions.headingTextSize4
            : Dimensions.headingTextSize3,
        fontWeight: FontWeight.w500,
        color: Get.isDarkMode
            ? CustomColor.primaryDarkTextColor
            : CustomColor.primaryLightColor,
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
      actions: [ 
        InkWell(
          onTap: (){
            Get.toNamed(Routes.webhookLogsScreen);
          },
          child:  TitleHeading3Widget(
            fontSize: Dimensions.headingTextSize4,
            padding: EdgeInsets.only(
              right: Dimensions.paddingHorizontalSize*0.4,
            
            ),
           text: Strings.webhookLogs,
           
          ),
        ),
      ], 

      leading: BackButtonWidget(
        onTap: onTapLeading ??
            () {
              Get.back();
            },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Dimensions.appBarHeight * 0.7);
}
