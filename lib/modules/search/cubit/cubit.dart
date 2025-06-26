import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppapp/modules/search/cubit/states.dart';

import '../../../models/search_Model.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/end_points.dart';
import '../../../shared/network/remote/dio_helper.dart';


class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? model;

  void search(String text) {

    emit(SearchLoadingState());
    DioHelper.postData(
        url: SEARCH,
        token: token,
        data: {
          'text': text
        }
        )
        .then((value)
    {
      model = SearchModel.fromJson(value!.data);

      emit(SearchSuccessState());
    }
    )
        .catchError((error)
    {
      print(error.toString());
      emit(SearchErrorState(error.toString()));
    }
    );
  }
}
