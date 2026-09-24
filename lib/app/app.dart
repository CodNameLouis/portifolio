import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_luan/app/router/app_router.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/services/json_asset_loader.dart';
import 'package:portfolio_luan/core/services/link_launcher.dart';
import 'package:portfolio_luan/core/theme/app_theme.dart';
import 'package:portfolio_luan/features/contact/repositories/contact_repository.dart';
import 'package:portfolio_luan/features/contact/repositories/local_contact_repository.dart';
import 'package:portfolio_luan/features/home/repositories/local_profile_repository.dart';
import 'package:portfolio_luan/features/home/repositories/profile_repository.dart';
import 'package:portfolio_luan/features/projects/repositories/local_projects_repository.dart';
import 'package:portfolio_luan/features/projects/repositories/projects_repository.dart';
import 'package:portfolio_luan/features/stack/repositories/local_stack_repository.dart';
import 'package:portfolio_luan/features/stack/repositories/stack_repository.dart';
import 'package:portfolio_luan/features/trajectory/repositories/local_trajectory_repository.dart';
import 'package:portfolio_luan/features/trajectory/repositories/trajectory_repository.dart';

class App extends StatefulWidget {
  const App({this.bundle, this.site, super.key});

  final AssetBundle? bundle;
  final bool? site;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router = widget.site == null
      ? AppRouter.build()
      : AppRouter.build(site: widget.site!);
  late final JsonAssetLoader _loader = JsonAssetLoader(
    bundle: widget.bundle ?? rootBundle,
  );

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProfileRepository>(
          create: (context) => LocalProfileRepository(loader: _loader),
        ),
        RepositoryProvider<ProjectsRepository>(
          create: (context) => LocalProjectsRepository(loader: _loader),
        ),
        RepositoryProvider<StackRepository>(
          create: (context) => LocalStackRepository(loader: _loader),
        ),
        RepositoryProvider<TrajectoryRepository>(
          create: (context) => LocalTrajectoryRepository(loader: _loader),
        ),
        RepositoryProvider<ContactRepository>(
          create: (context) => LocalContactRepository(loader: _loader),
        ),
        RepositoryProvider<LinkLauncher>(
          create: (context) => const LinkLauncher(),
        ),
      ],
      child: MaterialApp.router(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        routerConfig: _router,
      ),
    );
  }
}
