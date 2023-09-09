import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../model/project_model.dart';
import '../../utils/api_services.dart';
import '../../utils/app_asset.dart';
import '../../utils/app_color.dart';
import '../../utils/app_dimens.dart';
import '../../utils/app_string.dart';
import '../../utils/util.dart';
import '../../widget/comman_widget.dart';

class DashBoardScreen extends StatefulWidget {
  ProjectData? projectData;

  DashBoardScreen({this.projectData});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

enum Menu { itemOne }

class _DashBoardScreenState extends State<DashBoardScreen> {
  int selectIndex = 1;
  int selectIndex1 = 0;
  bool listNull = false;
  TaskBloc? taskBloc;
  bool isLoading = false;
  bool isRefresh = false;
  List<TaskDetailsList> taskDetailsListAll = [];
  List<TaskDetailsList> taskDetailsList = [];
  int? projectId;
  List projectRights = [];
  late ProjectData projectData;
  List<IssueData>? issueList;

  @override
  void initState() {
    taskBloc = BlocProvider.of<TaskBloc>(context);
    projectData = widget.projectData!;
    projectRights = projectData.projectRights?.split(',');
    projectId = projectData.projectId;
    taskBloc?.add(TaskPressed(projectId: projectId!));
    ApiServices.getIssueList(projectData.projectId!, 2).then((value) {
      setState(() {
        issueList = value.data!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: AppColor.white,
          body: WillPopScope(
            onWillPop: () {
              Navigator.pop(context, issueList?.length);
              return Future(() => false);
            },
            child: Column(
              children: [
                Container(
                  height: 15.w,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                          color: AppColor.bg,
                          blurRadius: 10.0,
                          offset: Offset(0.0, 0.75))
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.w, top: 3.w, bottom: 3.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context, issueList?.length);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: SizedBox(
                                    height: 5.w,
                                    width: 7.w,
                                    child: Image.asset(ImageAsset.arrow_back)),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              projectData.projectDetail?.projectName ?? "",
                              style: Utils.mediumTextStyle(
                                  color: AppColor.textColor,
                                  fontSize: AppDimens.large_font),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 6.w, top: 1.w, bottom: 1.w),
                              child: Image.asset(ImageAsset.iconFilter),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 5.w, top: 1.w, bottom: 1.w),
                              child: Image.asset(ImageAsset.iconsSearch),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                selectIndex == 1
                    ? ((projectRights.contains("7") ||
                            projectRights.contains("1"))
                        ? Expanded(
                            child: BlocListener<TaskBloc, TaskState>(
                              listener: (context, state) {
                                if (state is TaskLoading) {
                                  if (isRefresh == false) {
                                    isLoading = true;
                                  }
                                  setState(() {});
                                } else if (state is TaskSuccess) {
                                  setState(() {
                                    isLoading = false;
                                    taskDetailsListAll.clear();
                                    taskDetailsList.clear();
                                    taskDetailsListAll = state.taskModel.data!;
                                    taskDetailsList.addAll(taskDetailsListAll);
                                  });
                                }
                              },
                              child: RefreshIndicator(
                                onRefresh: () {
                                  taskBloc
                                      ?.add(TaskPressed(projectId: projectId!));
                                  isRefresh = true;
                                  return Future(() => false);
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 3.w, right: 3.w),
                                      child: SizedBox(
                                        height: 16.w,
                                        width: double.infinity,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: Utils.list.length,
                                            itemBuilder: (context, index) {
                                              return planHorizontalList(
                                                  selectIndex1, index, () {
                                                setState(() {
                                                  selectIndex1 = index;
                                                  taskDetailsList.clear();
                                                  if (index == 0) {
                                                    taskDetailsList.addAll(
                                                        taskDetailsListAll);
                                                  } else {
                                                    taskDetailsListAll
                                                        .asMap()
                                                        .entries
                                                        .map((e) {
                                                      if (taskDetailsListAll[
                                                                  e.key]
                                                              .groupingIndex
                                                              .toString()
                                                              .trim() ==
                                                          index
                                                              .toString()
                                                              .trim()) {
                                                        setState(() {
                                                          taskDetailsList.add(
                                                              taskDetailsListAll[
                                                                  e.key]);
                                                        });
                                                      }
                                                    }).toList();
                                                  }
                                                });
                                              });
                                            }),
                                      ),
                                    ),
                                    Expanded(
                                        child: isLoading
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: AppColor.mainColor,
                                                ),
                                              )
                                            : taskDetailsList.isEmpty
                                                ? noDataFound()
                                                : widgetPlan()),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Center(
                                child: Text("You not access Site Plan"))))
                    : selectIndex == 2
                        ? ((projectRights.contains("1") ||
                                projectRights.contains("7"))
                            ? issueList == null
                                ? Expanded(
                                    child: Center(
                                        child: CircularProgressIndicator()))
                                : Expanded(
                                    child: RefreshIndicator(
                                        onRefresh: () {
                                          ApiServices.getIssueList(
                                                  projectData.projectId!, 2)
                                              .then((value) {
                                            setState(() {
                                              issueList = value.data!;
                                            });
                                          });
                                          return Future(() => false);
                                        },
                                        child: widgetIssueList(
                                            issueList, setState)),
                                  )
                            : Expanded(
                                child: Center(
                                child: Text("You not access Issues"),
                              )))
                        : Container(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 20.w,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                            color: AppColor.bg,
                            blurRadius: 10.0,
                            offset: Offset(0.0, 0.75))
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          item(
                              1,
                              selectIndex == 1
                                  ? ImageAsset.iconPlan
                                  : ImageAsset.iconPlan1,
                              "Plan", () {
                            setState(() {
                              selectIndex = 1;
                            });
                          }),
                          item(
                              2,
                              selectIndex == 2
                                  ? ImageAsset.iconIssues
                                  : ImageAsset.iconIssues1,
                              "Issues", () {
                            setState(() {
                              selectIndex = 2;
                            });
                          }),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: selectIndex == 2
              ? Padding(
                  padding: EdgeInsets.only(bottom: 22.w),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return TaskIssueScreen(
                          tag: 1,
                          edit: 0,
                          projectID: projectId,
                        );
                      })).then((value) {
                        if (value != null) {
                          setState(() {
                            issueList?.add(value);
                          });
                        }
                      });
                    },
                    child: Container(
                        height: 10.w,
                        width: 30.w,
                        decoration: BoxDecoration(
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                  color: AppColor.white3,
                                  blurRadius: 50.0,
                                  offset: Offset(0.0, 0.75))
                            ],
                            color: AppColor.floatBg1,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              color: AppColor.textColor3,
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            Text(
                              "Add Issue",
                              style: Utils.regularTextStyle(),
                            )
                          ],
                        )),
                  ),
                )
              : taskDetailsList.isEmpty
                  ? Container()
                  : selectIndex == 1
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 22.w),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return AddTaskScreen(
                                  projectId: projectId!,
                                );
                              })).then((value) {
                                if (value != null) {
                                  for (int i = 0; i < value.data.length; i++) {
                                    setState(() {
                                      taskDetailsListAll.add(value.data[i]);
                                      taskDetailsList.add(value.data[i]);
                                    });
                                  }
                                }
                              });
                            },
                            child: Container(
                                height: 10.w,
                                width: 30.w,
                                decoration: BoxDecoration(
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                          color: AppColor.white3,
                                          blurRadius: 50.0,
                                          offset: Offset(0.0, 0.75))
                                    ],
                                    color: AppColor.floatBg1,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_circle_outline,
                                      color: AppColor.textColor3,
                                    ),
                                    SizedBox(
                                      width: 1.w,
                                    ),
                                    Text(
                                      "Add Task",
                                      style: Utils.regularTextStyle(),
                                    )
                                  ],
                                )),
                          ),
                        )
                      : Container()),
    );
  }

  Widget item(int index, String icon, String name, GestureTapCallback? onTab) {
    return InkWell(
      onTap: onTab,
      child: Column(
        children: [
          Container(
            height: 1.w,
            width: 10.w,
            decoration: BoxDecoration(
                color: selectIndex == index ? AppColor.divider : AppColor.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5))),
          ),
          SizedBox(
            height: 2.w,
          ),
          Container(
            height: 8.w,
            width: 8.w,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(icon), fit: BoxFit.cover)),
          ),
          SizedBox(
            height: 2.w,
          ),
          Text(
            name,
            style: Utils.regularTextStyle(
                color:
                    selectIndex == index ? AppColor.textColor2 : AppColor.black,
                fontSize: AppDimens.default_font),
          )
        ],
      ),
    );
  }

  Widget noDataFound() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(),
        SizedBox(
            height: 60.w,
            width: 60.w,
            child: Image.asset(ImageAsset.dashboardImage)),
        Text(
          AppString.strAddTasks,
          textAlign: TextAlign.center,
          style: Utils.regularTextStyle(
              color: AppColor.textColor3, fontSize: AppDimens.medium_font),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 22.w),
          child: InkWell(
            onTap: () {
              selectIndex1 = 0;
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return AddTaskScreen(
                  projectId: projectId!,
                );
              })).then((value) {
                if (value != null) {
                  for (int i = 0; i < value.data.length; i++) {
                    setState(() {
                      taskDetailsList.add(value.data[i]);
                      taskDetailsListAll.add(value.data[i]);
                    });
                  }
                }
              });
            },
            child: Container(
                height: 15.w,
                width: 70.w,
                decoration: BoxDecoration(
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                          color: AppColor.white3,
                          blurRadius: 50.0,
                          offset: Offset(0.0, 0.75))
                    ],
                    color: AppColor.floatBg1,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: AppColor.textColor3,
                    ),
                    SizedBox(
                      width: 1.w,
                    ),
                    Text(
                      "Add Task",
                      style: Utils.regularTextStyle(
                          fontSize: AppDimens.medium_font),
                    )
                  ],
                )),
          ),
        )
      ],
    );
  }

  double bottom = 0.0;

  Widget widgetPlan() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: taskDetailsList.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 15.w),
            itemBuilder: (context, index) {
              int? differentDate;
              if (taskDetailsList[index].startDate != null) {
                DateTime to =
                    DateTime.parse(taskDetailsList[index].endDate ?? '');
                differentDate = Utils.daysElapsedSince(DateTime.now(), to);
              }
              return Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 4.w),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: AppColor.btnUpdateBg,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 8.w, left: 4.w, bottom: 3.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      taskDetailsList[index].title ?? "",
                                      overflow: TextOverflow.clip,
                                      style: Utils.mediumTextStyle(
                                          fontSize: AppDimens.large_font,
                                          color: AppColor.textColor5),
                                    ),
                                    Text(
                                      taskDetailsList[index].taskCategory.title,
                                      overflow: TextOverflow.clip,
                                      style: Utils.regularTextStyle(
                                          color: AppColor.textColor1,
                                          fontSize: AppDimens.large_font),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (_) {
                                          return UpdateTaskScreen(
                                            taskDetailsList:
                                                taskDetailsList[index],
                                          );
                                        })).then((value) {
                                          setState(() {
                                            taskDetailsList[index]
                                                    .issues_count =
                                                value.issues_count;
                                            taskDetailsList[index]
                                                    .taskProgress =
                                                value.taskProgress;
                                            if (taskDetailsList[index]
                                                    .startDate !=
                                                null) {
                                              DateTime from = DateTime.parse(
                                                  value.startDate ?? '');
                                              DateTime to = DateTime.parse(
                                                  value.endDate ?? '');
                                              differentDate =
                                                  Utils.daysElapsedSince(
                                                      from, to);
                                            }
                                          });
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColor.cBg,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            "Update",
                                            style: Utils.regularTextStyle(
                                                color: AppColor.textColor5,
                                                fontSize: AppDimens.large_font),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    PopupMenuButton(
                                        child: Icon(
                                          Icons.more_vert,
                                          color: AppColor.textColor2,
                                          size: 30,
                                        ),
                                        onSelected: (Menu item) {
                                          if (item.index == 0) {
                                            showMyDialog(context,
                                                "are you sure, delete this task?",
                                                () {
                                              Navigator.pop(context);
                                              ApiServices.postTaskDelete(
                                                  taskDetailsList[index].id!);
                                              setState(() {
                                                taskDetailsList.removeAt(index);
                                              });
                                              // .then((value) => () {
                                              //       if (value ==
                                              //           true) {
                                              //
                                              //       }
                                              //     });
                                            });
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<Menu>>[
                                              const PopupMenuItem<Menu>(
                                                value: Menu.itemOne,
                                                child: Text('Delete'),
                                              ),
                                            ]),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Color(int.parse(
                                  taskDetailsList[index].colorCode ?? "")),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              taskDetailsList[index].grouping ?? "",
                              style: Utils.regularTextStyle(
                                  color: AppColor.textColor1,
                                  fontSize: AppDimens.indicator_size),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColor.cBg,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 2.w, top: 4.w),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 15.w,
                                  width: 15.w,
                                  child: CircularPercentIndicator(
                                    radius: 25.0,
                                    lineWidth: 5.0,
                                    percent: double.parse(taskDetailsList[index]
                                                .taskProgress ??
                                            "0.0") /
                                        100,
                                    center: Text(
                                      "${double.parse(taskDetailsList[index].taskProgress ?? "0.0").toStringAsFixed(0)}%",
                                      style: Utils.regularTextStyle(
                                          color: AppColor.progressPercent,
                                          fontSize: 10.0),
                                    ),
                                    progressColor: Colors.green,
                                  ),
                                ),
                                Text(
                                  "${differentDate == null ? "-" : differentDate! < 0 ? "0" : differentDate} days left",
                                  style: Utils.regularTextStyle(
                                      color: AppColor.textColor1,
                                      fontSize: AppDimens.medium_font),
                                ),
                                Text(
                                  "${taskDetailsList[index].issues_count ?? "0"} Issues",
                                  style: Utils.regularTextStyle(
                                      color: AppColor.red,
                                      fontSize: AppDimens.medium_font),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: AppColor.btnUpdateBg,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: InkWell(
                                    onTap: () {
                                      if (differentDate == null) {
                                        Toasts.showToast("Please update task");
                                      } else {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (_) {
                                          return TaskReviewScreen(
                                              id: taskDetailsList[index].id,
                                              day: differentDate);
                                        }));
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        "Review",
                                        style: Utils.regularTextStyle(
                                            color: AppColor.textColor5,
                                            fontSize: AppDimens.medium_font),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
