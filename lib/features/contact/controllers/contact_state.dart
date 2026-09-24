import 'package:equatable/equatable.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/features/contact/models/contact_model.dart';

sealed class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object?> get props => [];
}

final class ContactInitial extends ContactState {
  const ContactInitial();
}

final class ContactLoading extends ContactState {
  const ContactLoading();
}

final class ContactLoaded extends ContactState {
  const ContactLoaded({required this.contact, this.launchFailure});

  final ContactModel contact;
  final AppFailure? launchFailure;

  ContactLoaded copyWith({AppFailure? launchFailure}) =>
      ContactLoaded(contact: contact, launchFailure: launchFailure);

  @override
  List<Object?> get props => [contact, launchFailure];
}

final class ContactFailure extends ContactState {
  const ContactFailure(this.failure);

  final AppFailure failure;

  @override
  List<Object?> get props => [failure];
}
