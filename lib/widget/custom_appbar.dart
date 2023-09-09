import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_color.dart';
import '../utils/app_dimens.dart';

class CustomAppBar extends StatefulWidget {
  bool user = false;
  VoidCallback onPressed;

  CustomAppBar({required this.user, required this.onPressed});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 20.w,
        decoration: const BoxDecoration(
          color: AppColor.bgAppbar,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  widget.onPressed();
                },
                child: Container(
                  margin: EdgeInsets.all(6.0),
                  height: 12.w,
                  width: 12.w,
                  decoration: const BoxDecoration(
                      color: AppColor.mainColor,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Center(
                    child: SvgPicture.asset(
                      iconMenu,
                      width: 5.w,
                      height: 5.w,
                    ),
                  ),
                ),
              ),
              Container(
                width: 35.w,
                height: 15.w,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(logo),
                )),
              ),
              widget.user == true
                  ? Container(
                      margin: EdgeInsets.all(6.0),
                      height: 7.w,
                      width: 20.w,
                      decoration: const BoxDecoration(
                          color: AppColor.btnAdmin,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: const Center(
                        child: Text(
                          "Admin",
                          style: TextStyle(
                              fontSize: AppDimens.default_font,
                              color: AppColor.white),
                        ),
                      ),
                    )
                  : Container(
                      height: 7.w,
                      width: 15.w,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
