import 'package:flutter/material.dart';
import 'package:portfolio_new/models/portfolio_model.dart';
import 'package:portfolio_new/services/portfolio_notifier.dart';
import 'package:portfolio_new/services/portfolio_state.dart';

class PortfolioScope extends InheritedNotifier<PortfolioNotifier> {
  const PortfolioScope({
    super.key,
    required PortfolioNotifier notifier,
    required super.child,
  }) : super(notifier: notifier);

  static PortfolioNotifier of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<PortfolioScope>();
    assert(scope != null, 'No PortfolioScope found in context');
    return scope!.notifier!;
  }

  static PortfolioState stateOf(BuildContext context) {
    return of(context).state;
  }

  static PortfolioData dataOf(BuildContext context) {
    return of(context).state.data;
  }
}
