import 'package:equatable/equatable.dart';

sealed class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object?> get props => [];
}

final class ContactStarted extends ContactEvent {
  const ContactStarted();
}

final class ContactLinkPressed extends ContactEvent {
  const ContactLinkPressed(this.url);

  final String url;

  @override
  List<Object?> get props => [url];
}

final class ResumeDownloadPressed extends ContactEvent {
  const ResumeDownloadPressed();
}
