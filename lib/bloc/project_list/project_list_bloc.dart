import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/project_model.dart';
import '../../utils/api_services.dart';

part 'project_list_event.dart';

part 'project_list_state.dart';

class ProjectListBloc extends Bloc<ProjectListEvent, ProjectListState> {
  ProjectListBloc() : super(ProjectListInitial()) {
    on<ProjectListPressed>((event, emit) async {
      emit(ProjectListLoading());
      try {
        ProjectModel? projectModel = await ApiServices.getProjectList();
        emit(ProjectListSuccess(projectModel: projectModel));
      } catch (e) {
        emit(ProjectListFailure(error: (e.toString())));
      }
    });
  }
}
