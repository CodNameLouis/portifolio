import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_luan/app/router/app_routes.dart';
import 'package:portfolio_luan/app/shell/views/app_shell_page.dart';
import 'package:portfolio_luan/core/services/link_launcher.dart';
import 'package:portfolio_luan/features/contact/controllers/contact_bloc.dart';
import 'package:portfolio_luan/features/contact/controllers/contact_event.dart';
import 'package:portfolio_luan/features/contact/repositories/contact_repository.dart';
import 'package:portfolio_luan/features/contact/views/contact_page.dart';
import 'package:portfolio_luan/features/home/controllers/home_bloc.dart';
import 'package:portfolio_luan/features/home/controllers/home_event.dart';
import 'package:portfolio_luan/features/home/repositories/profile_repository.dart';
import 'package:portfolio_luan/features/home/views/home_page.dart';
import 'package:portfolio_luan/features/projects/controllers/projects_bloc.dart';
import 'package:portfolio_luan/features/projects/controllers/projects_event.dart';
import 'package:portfolio_luan/features/projects/repositories/projects_repository.dart';
import 'package:portfolio_luan/features/projects/views/projects_page.dart';
import 'package:portfolio_luan/features/site/views/site_anchor.dart';
import 'package:portfolio_luan/features/site/views/site_page.dart';
import 'package:portfolio_luan/features/stack/controllers/stack_bloc.dart';
import 'package:portfolio_luan/features/stack/controllers/stack_event.dart';
import 'package:portfolio_luan/features/stack/repositories/stack_repository.dart';
import 'package:portfolio_luan/features/stack/views/stack_page.dart';
import 'package:portfolio_luan/features/trajectory/controllers/trajectory_bloc.dart';
import 'package:portfolio_luan/features/trajectory/controllers/trajectory_event.dart';
import 'package:portfolio_luan/features/trajectory/repositories/trajectory_repository.dart';
import 'package:portfolio_luan/features/trajectory/views/trajectory_page.dart';

abstract final class AppRouter {
  static GoRouter build({bool site = kIsWeb}) {
    return GoRouter(
      initialLocation: AppRoutes.home,
      routes: site ? _siteRoutes() : _appRoutes(),
    );
  }

  static List<RouteBase> _siteRoutes() {
    SiteAnchor? ancoraDe(String path) {
      for (final anchor in SiteAnchor.values) {
        if (anchor.path == path) {
          return anchor;
        }
      }

      return null;
    }

    GoRoute rota(String path, String name) {
      return GoRoute(
        path: path,
        name: name,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  HomeBloc(repository: context.read<ProfileRepository>())
                    ..add(const HomeStarted()),
            ),
            BlocProvider(
              create: (context) => ProjectsBloc(
                repository: context.read<ProjectsRepository>(),
                linkLauncher: context.read<LinkLauncher>(),
              )..add(const ProjectsStarted()),
            ),
            BlocProvider(
              create: (context) =>
                  StackBloc(repository: context.read<StackRepository>())
                    ..add(const StackStarted()),
            ),
            BlocProvider(
              create: (context) => TrajectoryBloc(
                repository: context.read<TrajectoryRepository>(),
              )..add(const TrajectoryStarted()),
            ),
            BlocProvider(
              create: (context) => ContactBloc(
                repository: context.read<ContactRepository>(),
                linkLauncher: context.read<LinkLauncher>(),
              )..add(const ContactStarted()),
            ),
          ],
          child: SitePage(anchor: ancoraDe(path)),
        ),
      );
    }

    return [
      rota(AppRoutes.home, AppRoutes.homeName),
      rota(AppRoutes.projects, AppRoutes.projectsName),
      rota(AppRoutes.stack, AppRoutes.stackName),
      rota(AppRoutes.trajectory, AppRoutes.trajectoryName),
      rota(AppRoutes.contact, AppRoutes.contactName),
    ];
  }

  static List<RouteBase> _appRoutes() {
    return [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShellPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: AppRoutes.homeName,
                builder: (context, state) => BlocProvider(
                  create: (context) =>
                      HomeBloc(repository: context.read<ProfileRepository>())
                        ..add(const HomeStarted()),
                  child: const HomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.projects,
                name: AppRoutes.projectsName,
                builder: (context, state) => BlocProvider(
                  create: (context) => ProjectsBloc(
                    repository: context.read<ProjectsRepository>(),
                    linkLauncher: context.read<LinkLauncher>(),
                  )..add(const ProjectsStarted()),
                  child: const ProjectsPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.stack,
                name: AppRoutes.stackName,
                builder: (context, state) => BlocProvider(
                  create: (context) =>
                      StackBloc(repository: context.read<StackRepository>())
                        ..add(const StackStarted()),
                  child: const StackPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.trajectory,
                name: AppRoutes.trajectoryName,
                builder: (context, state) => BlocProvider(
                  create: (context) => TrajectoryBloc(
                    repository: context.read<TrajectoryRepository>(),
                  )..add(const TrajectoryStarted()),
                  child: const TrajectoryPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.contact,
                name: AppRoutes.contactName,
                builder: (context, state) => BlocProvider(
                  create: (context) => ContactBloc(
                    repository: context.read<ContactRepository>(),
                    linkLauncher: context.read<LinkLauncher>(),
                  )..add(const ContactStarted()),
                  child: const ContactPage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ];
  }
}
