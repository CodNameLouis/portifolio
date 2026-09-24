import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/core/services/link_launcher.dart';
import 'package:portfolio_luan/features/contact/controllers/contact_event.dart';
import 'package:portfolio_luan/features/contact/controllers/contact_state.dart';
import 'package:portfolio_luan/features/contact/repositories/contact_repository.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc({required this.repository, required this.linkLauncher})
    : super(const ContactInitial()) {
    on<ContactStarted>(_onStarted);
    on<ContactLinkPressed>(_onLinkPressed);
    on<ResumeDownloadPressed>(_onResumePressed);
  }

  final ContactRepository repository;
  final LinkLauncher linkLauncher;

  Future<void> _onStarted(
    ContactStarted event,
    Emitter<ContactState> emit,
  ) async {
    emit(const ContactLoading());

    try {
      emit(ContactLoaded(contact: await repository.fetch()));
    } on AppFailure catch (failure) {
      emit(ContactFailure(failure));
    } on Object {
      emit(const ContactFailure(AppFailure.load()));
    }
  }

  Future<void> _onLinkPressed(
    ContactLinkPressed event,
    Emitter<ContactState> emit,
  ) async {
    await _open(event.url, emit);
  }

  Future<void> _onResumePressed(
    ResumeDownloadPressed event,
    Emitter<ContactState> emit,
  ) async {
    final state = this.state;

    if (state is! ContactLoaded) {
      return;
    }

    await _open(state.contact.resumeUrl, emit);
  }

  Future<void> _open(String url, Emitter<ContactState> emit) async {
    final state = this.state;

    if (state is! ContactLoaded) {
      return;
    }

    if (await linkLauncher.open(url)) {
      return;
    }

    emit(state.copyWith(launchFailure: const AppFailure.link()));
  }
}
