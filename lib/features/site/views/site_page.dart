import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_luan/core/constants/app_durations.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/core/theme/site_metrics.dart';
import 'package:portfolio_luan/features/contact/controllers/contact_bloc.dart';
import 'package:portfolio_luan/features/contact/controllers/contact_event.dart';
import 'package:portfolio_luan/features/contact/controllers/contact_state.dart';
import 'package:portfolio_luan/features/home/controllers/home_bloc.dart';
import 'package:portfolio_luan/features/home/controllers/home_event.dart';
import 'package:portfolio_luan/features/home/controllers/home_state.dart';
import 'package:portfolio_luan/features/projects/controllers/projects_bloc.dart';
import 'package:portfolio_luan/features/projects/controllers/projects_event.dart';
import 'package:portfolio_luan/features/projects/controllers/projects_state.dart';
import 'package:portfolio_luan/features/site/views/site_anchor.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_contact_section.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_footer.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_header.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_hero.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_projects_section.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_stack_section.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_stats.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_trajectory_section.dart';
import 'package:portfolio_luan/features/stack/controllers/stack_bloc.dart';
import 'package:portfolio_luan/features/stack/controllers/stack_state.dart';
import 'package:portfolio_luan/features/trajectory/controllers/trajectory_bloc.dart';
import 'package:portfolio_luan/features/trajectory/controllers/trajectory_state.dart';
import 'package:portfolio_luan/shared/widgets/feedback/error_view.dart';
import 'package:portfolio_luan/shared/widgets/feedback/loading_view.dart';

class SitePage extends StatefulWidget {
  const SitePage({this.anchor, super.key});

  final SiteAnchor? anchor;

  @override
  State<SitePage> createState() => _SitePageState();
}

class _SitePageState extends State<SitePage> {
  final ScrollController _scroll = ScrollController();
  final Map<SiteAnchor, GlobalKey> _keys = {
    for (final anchor in SiteAnchor.values) anchor: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _agendaRolagem();
  }

  @override
  void didUpdateWidget(SitePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.anchor != oldWidget.anchor) {
      _agendaRolagem();
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _agendaRolagem() {
    final anchor = widget.anchor;

    if (anchor == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _rolaAte(anchor));
  }

  Future<void> _rolaAte(SiteAnchor anchor) async {
    final alvo = _keys[anchor]?.currentContext;

    if (alvo == null) {
      return;
    }

    await Scrollable.ensureVisible(
      alvo,
      duration: AppDurations.paletteTransition,
      curve: Curves.easeInOut,
    );
  }

  void _vaiPara(SiteAnchor anchor) {
    unawaited(_rolaAte(anchor));
  }

  void _voltaAoTopo() {
    if (_scroll.hasClients) {
      _scroll.animateTo(
        0,
        duration: AppDurations.paletteTransition,
        curve: Curves.easeInOut,
      );
    }
  }

  void _avisaFalha(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), duration: AppDurations.snackBar),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sand,
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProjectsBloc, ProjectsState>(
            listenWhen: (previous, current) =>
                current is ProjectsLoaded && current.launchFailure != null,
            listener: (context, state) =>
                _avisaFalha((state as ProjectsLoaded).launchFailure!.message),
          ),
          BlocListener<ContactBloc, ContactState>(
            listenWhen: (previous, current) =>
                current is ContactLoaded && current.launchFailure != null,
            listener: (context, state) =>
                _avisaFalha((state as ContactLoaded).launchFailure!.message),
          ),
        ],
        child: SingleChildScrollView(
          controller: _scroll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) => _cabecalho(context, state),
              ),
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) => switch (state) {
                  HomeLoaded(:final profile) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SiteHero(
                        profile: profile,
                        onProjectsPressed: () => _vaiPara(SiteAnchor.projects),
                        onResumePressed: () => context.read<ContactBloc>().add(
                          const ResumeDownloadPressed(),
                        ),
                      ),
                      SiteStats(stats: profile.stats),
                    ],
                  ),
                  HomeFailure(:final failure) => _falha(
                    failure.message,
                    () => context.read<HomeBloc>().add(const HomeStarted()),
                  ),
                  _ => _carregando(),
                },
              ),
              KeyedSubtree(
                key: _keys[SiteAnchor.projects],
                child: BlocBuilder<ProjectsBloc, ProjectsState>(
                  builder: (context, state) => switch (state) {
                    ProjectsLoaded() => SiteProjectsSection(
                      state: state,
                      onCategorySelected: (category) => context
                          .read<ProjectsBloc>()
                          .add(ProjectsFilterChanged(category)),
                      onProjectPressed: (project) => context
                          .read<ProjectsBloc>()
                          .add(ProjectOpened(project)),
                    ),
                    ProjectsFailure(:final failure) => _falha(
                      failure.message,
                      () => context.read<ProjectsBloc>().add(
                        const ProjectsStarted(),
                      ),
                    ),
                    _ => _carregando(),
                  },
                ),
              ),
              KeyedSubtree(
                key: _keys[SiteAnchor.stack],
                child: BlocBuilder<StackBloc, StackState>(
                  builder: (context, state) => switch (state) {
                    StackLoaded(:final stack) => SiteStackSection(stack: stack),
                    StackFailure(:final failure) => _falha(failure.message),
                    _ => _carregando(),
                  },
                ),
              ),
              KeyedSubtree(
                key: _keys[SiteAnchor.trajectory],
                child: BlocBuilder<TrajectoryBloc, TrajectoryState>(
                  builder: (context, state) => switch (state) {
                    TrajectoryLoaded(:final trajectory) =>
                      SiteTrajectorySection(trajectory: trajectory),
                    TrajectoryFailure(:final failure) => _falha(
                      failure.message,
                    ),
                    _ => _carregando(),
                  },
                ),
              ),
              KeyedSubtree(
                key: _keys[SiteAnchor.contact],
                child: BlocBuilder<ContactBloc, ContactState>(
                  builder: (context, state) => switch (state) {
                    ContactLoaded(:final contact) => SiteContactSection(
                      contact: contact,
                      onLinkPressed: (url) => context.read<ContactBloc>().add(
                        ContactLinkPressed(url),
                      ),
                      onResumePressed: () => context.read<ContactBloc>().add(
                        const ResumeDownloadPressed(),
                      ),
                    ),
                    ContactFailure(:final failure) => _falha(failure.message),
                    _ => _carregando(),
                  },
                ),
              ),
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) => SiteFooter(
                  credits: _creditos(state),
                  onBackToTop: _voltaAoTopo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cabecalho(BuildContext context, HomeState state) {
    final profile = state is HomeLoaded ? state.profile : null;

    return SiteHeader(
      sections: SiteAnchor.labels,
      availabilityLabel: profile != null && profile.available
          ? profile.availabilityLabel
          : null,
      onSectionSelected: (index) => _vaiPara(SiteAnchor.values[index]),
      onLogoPressed: _voltaAoTopo,
      onContactPressed: () => _vaiPara(SiteAnchor.contact),
    );
  }

  String _creditos(HomeState state) {
    final ano = DateTime.now().year;
    final nome = state is HomeLoaded
        ? '${state.profile.firstName} ${state.profile.lastName}'
        : '';

    return '© $ano $nome';
  }

  Widget _carregando() => const SizedBox(
    height: SiteMetrics.sectionPlaceholder,
    child: LoadingView(palette: ScreenPalette.light),
  );

  Widget _falha(String mensagem, [VoidCallback? onRetry]) => SizedBox(
    height: SiteMetrics.sectionPlaceholder,
    child: ErrorView(
      message: mensagem,
      palette: ScreenPalette.light,
      onRetry: onRetry,
    ),
  );
}
