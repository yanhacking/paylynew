import '../../controller/wallets/wallets_controller.dart';
import '../../utils/basic_screen_imports.dart';
import '../../utils/responsive_layout.dart';
import '../../widgets/appbar/appbar_widget.dart';

class WalletsScreen extends StatelessWidget {
  WalletsScreen({super.key});
  final controller = Get.put(WalletsController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: const AppBarWidget(
          text: Strings.myWallets,
        ),
        body: _bodyWidget(context),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    var wallets = controller.walletsInfoModel.data.userWallets;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.marginSizeHorizontal * 0.5,
        ),
        child: Wrap(
          spacing: Dimensions.marginSizeHorizontal * 0.5,
          runSpacing: Dimensions.marginSizeHorizontal * 0.5,
          children: List.generate(wallets.length, (index) {
            return Container(
              width: MediaQuery.of(context).size.width / 2 -
                  Dimensions.marginSizeHorizontal,
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.marginSizeHorizontal * 0.5,
                vertical: Dimensions.marginSizeVertical * 0.45,
              ),
              decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? CustomColor.whiteColor.withOpacity(alpha:0.06)
                    : CustomColor.primaryLightColor.withOpacity(alpha:0.06),
                borderRadius: BorderRadius.circular(Dimensions.radius * 1.4),
              ),
              child: _buildWalletItem(wallets[index]),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildWalletItem(wallet) {
    int precision = wallet.currency.type == 'FIAT' ? 2 : 8;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radius * 0.8),
            child: Image.network(
              wallet.currency.currencyImage,
              fit: BoxFit.cover,
              height: Dimensions.heightSize * 3,
            ),
          ),
        ),
        horizontalSpace(Dimensions.widthSize),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: crossStart,
            mainAxisAlignment: mainSpaceBet,
            mainAxisSize: mainMin,
            children: [
              TitleHeading3Widget(
                text: wallet.currency.country,
                fontSize: Dimensions.headingTextSize5,
                maxLines: 1,
              ),
              verticalSpace(Dimensions.heightSize * 0.5),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TitleHeading4Widget(
                      text: wallet.balance.toStringAsFixed(precision),
                      fontSize: Dimensions.headingTextSize5 * 0.9,
                    ),
                    horizontalSpace(Dimensions.widthSize * 0.5),
                    TitleHeading4Widget(
                      text: wallet.currency.code,
                      color: CustomColor.primaryLightColor,
                      fontSize: Dimensions.headingTextSize5 * 0.9,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
