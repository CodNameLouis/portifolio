import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_luan/app/router/app_routes.dart';
import 'package:portfolio_luan/core/constants/app_durations.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/features/contact/controllers/contact_bloc.dart';
import 'package:portfolio_luan/features/contact/controllers/contact_event.dart';
import 'package:portfolio_luan/features/contact/controllers/contact_state.dart';
import 'package:portfolio_luan/features/contact/models/contact_model.dart';
import 'package:portfolio_luan/features/contact/views/widgets/contact_hero.dart';
import 'package:portfolio_luan/features/contact/views/widgets/contact_link_tile.dart';
import 'package:portfolio_luan/features/contact/views/widgets/resume_button.dart';
import 'package:portfolio_luan/shared/widgets/feedback/error_view.dart';
import 'package:portfolio_luan/shared/widgets/feedback/loading_view.dart';
import 'package:portfolio_luan/shared/widgets/layout/divided_column.dart';
import 'package:portfolio_luan/shared/widgets/layout/fade_slide_in.dart';
import 'package:portfolio_luan/shared/widgets/layout/page_header.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = ScreenPalette.forIndex(AppRoutes.contactIndex);

    return BlocConsumer<ContactBloc, ContactState>(
      listenWhen: (previous, current) =>
          current is ContactLoaded && current.launchFailure != null,
      listener: (context, state) {
        final failure = (state as ContactLoaded).launchFailure!;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            duration: AppDurations.snackBar,
          ),
        );
      },
      builder: (context, state) {
        return switch (state) {
          ContactInitial() || ContactLoading() => LoadingView(palette: palette),
          ContactFailure(:final failure) => ErrorView(
            message: failure.message,
            palette: palette,
            onRetry: () =>
                context.read<ContactBloc>().add(const ContactStarted()),
          ),
          ContactLoaded(:final contact) => _ContactContent(
            contact: contact,
            palette: palette,
          ),
        };
      },
    );
  }
}

class _ContactContent extends StatelessWidget {
  const _ContactContent({required this.contact, required this.palette});

  final ContactModel contact;
  final ScreenPalette palette;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ContactBloc>();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: FadeSlideIn(order: 0, child: PageHeader(palette: palette)),
        ),
        SliverToBoxAdapter(
          child: FadeSlideIn(
            order: 1,
            child: ContactHero(
              title: contact.title,
              subtitle: contact.subtitle,
              palette: palette,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: FadeSlideIn(
            order: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.xxl,
                AppSpacing.pageHorizontal,
                0,
              ),
              child: DividedColumn(
                dividerColor: palette.divider,
                itemPadding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.lg,
                ),
                children: [
                  for (final link in contact.links)
                    ContactLinkTile(
                      link: link,
                      palette: palette,
                      onPressed: () => bloc.add(ContactLinkPressed(link.url)),
                    ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: FadeSlideIn(
            order: 3,
            child: ResumeButton(
              onPressed: () => bloc.add(const ResumeDownloadPressed()),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.x6l)),
      ],
    );
  }
}
