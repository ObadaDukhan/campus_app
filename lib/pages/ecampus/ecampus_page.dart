import 'package:auto_route/auto_route.dart';
import 'package:campus_app/core/authentication/bloc/authentication_bloc.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/routes/router.gr.dart';
import 'package:campus_app/pages/ecampus/bloc/ecampus_bloc.dart';
import 'package:campus_app/pages/ecampus/widgets/ecampus_feature_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EcampusPage extends StatelessWidget {
  const EcampusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = AutoRouter.of(context);

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationTodoState ||
            state is Authentication2FATodoState) {
          router.push(const RUBSignInPageRoute());
        }
      },
      child: BlocProvider(
        create: (context) => sl<EcampusBloc>(),
        child: const ECampusListWidget(),
      ),
    );
  }
}
