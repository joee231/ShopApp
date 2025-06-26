import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var FormKey = GlobalKey<FormState>();
    var searchController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit , SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: FormKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children:
                  [
                    defaultFormField(
                        controller: SearchController(),
                        type: TextInputType.text,
                        validate: (value)
                        {
                          if(value!.isEmpty)
                          {
                            return 'Search must not be empty';
                          }
                          return null;
                        },
                        label: 'Search',
                        prefix: Icons.search,
                        obsecure: null,
                      onSubmitted: (text)
                      {
                        SearchCubit.get(context).search(text);
                      }
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    if(state is SearchLoadingState)
                      LinearProgressIndicator(),
                    if (state is SearchSuccessState)
                    Expanded(
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemCount: SearchCubit.get(context).model!.data!.data!.length,
                        separatorBuilder: (context, index) => myDividor(),
                        itemBuilder:
                            (context, index) => buildListProduct(
                              SearchCubit.get(context).model!.data!.data![index],
                          context,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
