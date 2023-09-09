import 'dart:convert';

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:market_rationalist/utils/app_string.dart';
import 'package:market_rationalist/utils/assets_image.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helper/route_helper.dart';
import '../model/user_model.dart';
import '../utils/app_color.dart';
import '../utils/app_dimens.dart';
import '../utils/shared_preferences/preferences_key.dart';
import '../utils/shared_preferences/preferences_manager.dart';
import '../utils/util.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late UserModel userModel;
  bool categoryDropdown = false;

  @override
  void initState() {
    // TODO: implement initState
    _initPackageInfo();
    String body = PreferencesManager.getString(PreferencesKey.userModel);
    userModel = UserModel.fromJson(jsonDecode(body));
    super.initState();
  }

  String packageName = "";

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageName = info.packageName;
    });
  }

  void _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  Future<void> shareLink() async {
    await FlutterShare.share(
        title: AppString.appName,
        text: AppString.appName,
        linkUrl: "https://play.google.com/store/apps/details?id=" + packageName,
        chooserTitle: '');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.secondColor,
      child: Column(
        children: [
          Container(
            height: 35.w,
            child: Column(
              children: [
                SizedBox(
                  height: 10.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 4.w,
                        ),
                        Text(
                          userModel.data?.name ?? "",
                          style: Utils.regularTextStyle(
                              color: AppColor.white,
                              fontSize: AppDimens.large_font),
                        ),
                        SizedBox(
                          height: 4.w,
                        ),
                        Row(
                          children: [
                            Text(
                              userModel.data?.email ?? "",
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: Utils.regularTextStyle(
                                  color: AppColor.white3, fontSize: 10.0),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.w,
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                  height: 0.3.w,
                  width: double.infinity,
                  color: AppColor.white2,
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 12.0.w),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      InkWell(
                        onTap: () {
                          if (userModel.data?.type == 1) {
                            Get.offAndToNamed(RouteHelper.newsList,
                                arguments: 0);
                          } else {
                            setState(() {
                              categoryDropdown = !categoryDropdown;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 20),
                          height: 15.w,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 7.w,
                                    height: 7.w,
                                    child: SvgPicture.asset(
                                      market_updates,
                                      width: 7.w,
                                      height: 7.w,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Text(
                                    AppString.gidesupdates,
                                    style: Utils.regularTextStyle(),
                                  ),
                                ],
                              ),
                              userModel.data?.type == 1
                                  ? Container()
                                  : const Icon(
                                      Icons.arrow_drop_down,
                                      size: 40,
                                      color: AppColor.white,
                                    ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedSizeAndFade.showHide(
                        show: categoryDropdown,
                        child: Column(
                          children: [
                            item1(AppString.market_updates, () {
                              Get.offAndToNamed(RouteHelper.newsList,
                                  arguments: 1);
                            }),
                            item1(AppString.strTechnicalAnalysis, () {
                              Get.offAndToNamed(RouteHelper.newsList,
                                  arguments: 2);
                            }),
                            item1(AppString.strAnnouncements, () {
                              Get.offAndToNamed(RouteHelper.newsList,
                                  arguments: 3);
                            }),
                            item1(AppString.strNewCryptoProjects, () {
                              Get.offAndToNamed(RouteHelper.newsList,
                                  arguments: 4);
                            }),
                            item1(AppString.strSignalPerformance, () {
                              Get.offAndToNamed(RouteHelper.newsList,
                                  arguments: 5);
                            }),
                            item1(AppString.strEducation, () {
                              Get.offAndToNamed(RouteHelper.newsList,
                                  arguments: 6);
                            }),
                            item1(AppString.strMoneyManagement, () {
                              Get.offAndToNamed(RouteHelper.newsList,
                                  arguments: 7);
                            }),
                          ],
                        ),
                      ),
                      userModel.data?.type == 1
                          ? Container()
                          : item(get_premium, AppString.get_premium, () {
                              Get.offAndToNamed(RouteHelper.subscription);
                            }),
                      userModel.data?.type == 1
                          ? Container()
                          : item(jointelegream, AppString.join_telegram, () {
                              SocialShare.shareTelegram(
                                  "https://play.google.com/store/apps/details?id=" +
                                      packageName);
                            }),
                      userModel.data?.type == 1
                          ? Container()
                          : item(joindiscord, AppString.join_discord, () {
                              _launchUrl(
                                  Uri.parse('https://discord.gg/S4ApepzT55'));
                            }),
                      userModel.data?.type == 1
                          ? InkWell(
                              onTap: () {
                                Get.toNamed(RouteHelper.redeemCode);
                                // : Get.toNamed(RouteHelper.redeemCodeApply);
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 20),
                                height: 15.w,
                                width: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 7.w,
                                      height: 7.w,
                                      child: Image.asset(redeemIcon),
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Text(
                                      "Redeem Code",
                                      style: Utils.regularTextStyle(),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      userModel.data?.type == 1
                          ? Container()
                          : item(support, AppString.support, () {
                              Get.offAndToNamed(RouteHelper.sendEmail);
                            }),
                      userModel.data?.type == 1
                          ? Container()
                          : InkWell(
                              onTap: () {
                                _launchUrl(Uri.parse(
                                    'https://twitter.com/MktRationalist'));
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 20),
                                height: 15.w,
                                width: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 7.w,
                                      height: 7.w,
                                      child: Image.asset(twitter),
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Text(
                                      "Join Twitter",
                                      style: Utils.regularTextStyle(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                      userModel.data?.type == 1
                          ? Container()
                          : InkWell(
                              onTap: () {
                                Get.offAndToNamed(
                                    RouteHelper.notificationSetting);
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 20),
                                height: 15.w,
                                width: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.notifications,
                                      size: 30,
                                      color: AppColor.white3,
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Text(
                                      "Notification Setting",
                                      style: Utils.regularTextStyle(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                      item(rate_us, AppString.rate_us, () {
                        _launchUrl(Uri.parse(
                            "https://play.google.com/store/apps/details?id=" +
                                packageName));
                      }),
                      item(share, AppString.share, () {
                        shareLink();
                      }),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w),
                    height: 10.w,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppString.app_version,
                          style: Utils.regularTextStyle(
                              color: AppColor.white3, fontSize: 10.0),
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text(
                                  AppString.appName,
                                  style: Utils.mediumTextStyle(
                                      color: AppColor.black),
                                ),
                                content: Text("Are you sure  want to logout?",
                                    style: Utils.regularTextStyle(
                                        color: AppColor.black)),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      PreferencesManager.remove(
                                          PreferencesKey.userModel);
                                      PreferencesManager.clear();
                                      Get.offAllNamed(RouteHelper.login);
                                    },
                                    child: Container(
                                        height: 9.w,
                                        width: 15.w,
                                        padding: EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Center(
                                          child: Text("Yes",
                                              style: Utils.regularTextStyle(
                                                  color: AppColor.green)),
                                        )),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                            height: 9.w,
                                            width: 15.w,
                                            padding: EdgeInsets.all(10),
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Center(
                                              child: Text(
                                                "No",
                                                style: Utils.regularTextStyle(
                                                    color: AppColor.red),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              AppString.logout,
                              style: Utils.regularTextStyle(
                                  color: AppColor.white3,
                                  fontSize: AppDimens.medium_font),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  item(String icon, String name, VoidCallback onPressed) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.only(left: 20),
        height: 15.w,
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 7.w,
              height: 7.w,
              child: SvgPicture.asset(
                icon,
                width: 7.w,
                height: 7.w,
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Text(
              name,
              style: Utils.regularTextStyle(),
            )
          ],
        ),
      ),
    );
  }

  item1(String name, VoidCallback onPressed) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.only(left: 20),
        height: 8.w,
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 15.w,
            ),
            Text(
              name,
              style: Utils.regularTextStyle(),
            )
          ],
        ),
      ),
    );
  }
}
