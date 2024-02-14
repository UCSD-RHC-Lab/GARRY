import 'package:flutter/cupertino.dart';
import 'dart:math';

///
/// Dimmensions page:
/// Defines the dimmensions and logic behind the pages as they are loaded and altered
///
////////////// Define some enums ///////////////
enum ComputeMode { height, width }
enum MainPageComponent { label, nextButton }
enum SessionPageComponent {
  idLabelFontSize,
  buttonFontSize,
  startButtonPadding
}
enum SelectionPageComponent {
  idLabelFontSize,
  selectFeedbackLabelFontSize,
  selectionMenuFontSize,
  feedbackLabelPaddingSize,
}
enum FeedbackPageComponent {
  coinUIWidth,
  pointsFontSize,
  endSessionButtonWidth,
  pointsFeedbackFontSize,
  thermSize,
  textFeedbackPadding,
  textFeedbackSize
}

enum Pages { mainPage, sessionPage, selectionPage, feedbackPage}

//////////////// The main class /////////////////
class Dimensions {
  static const double DEFAULT_FONT_SIZE = 35.0;

  static const Map<Pages, Map> pageMap = {
    Pages.mainPage: mainPageComponentToDimensionsMap,
    Pages.sessionPage: sessionPageComponentToDimensionsMap,
    Pages.selectionPage: selectionPageComponentToDimensionsMap,
    Pages.feedbackPage: feedbackPageComponentToDimensionsMap,
  };

  // each list is in the form of [scaleFactor, min, max]
  static const Map<MainPageComponent, List<double>>
      mainPageComponentToDimensionsMap = {
    MainPageComponent.label: [(1 / 33.7), 35, 52],
    MainPageComponent.nextButton: [(1 / 22.7), 25, 35]
  };

  static const Map<SessionPageComponent, List<double>>
      sessionPageComponentToDimensionsMap = {
    SessionPageComponent.idLabelFontSize: [(1 / 26), 20, 28],
    SessionPageComponent.buttonFontSize: [(1.15 / 25), 23, 32],
    SessionPageComponent.startButtonPadding: [(1 / 10), 50, 100]
  };

  static const Map<SelectionPageComponent, List<double>>
      selectionPageComponentToDimensionsMap = {
    SelectionPageComponent.idLabelFontSize: [(1 / 26), 20, 28],
    SelectionPageComponent.selectFeedbackLabelFontSize: [(1.15 / 25), 28, 38],
    SelectionPageComponent.selectionMenuFontSize: [(1 / 24.7), 20, 27],
    SelectionPageComponent.feedbackLabelPaddingSize: [(1), 13, 13]
  };

  static const Map<FeedbackPageComponent, List<double>>
      feedbackPageComponentToDimensionsMap = {
    FeedbackPageComponent.coinUIWidth: [(1 / 3), 150, 250],
    FeedbackPageComponent.pointsFontSize: [(1 / 18), 25, 40],
    FeedbackPageComponent.endSessionButtonWidth: [(1 / 10), 70, 100],
    FeedbackPageComponent.textFeedbackPadding: [(1 / 65), 5, 30],
    FeedbackPageComponent.textFeedbackSize: [(1 / 35), 10, 30],
    // compute by height
    FeedbackPageComponent.pointsFeedbackFontSize: [(1 / 8), 80, 120],
    FeedbackPageComponent.thermSize: [(1 / 17), 40, 60],
  };

  static double computeSize(BuildContext context, ComputeMode mode, Pages page,
      dynamic pageComponent) {
    List<double> dimensions = pageMap[page][pageComponent];

    if (mode == ComputeMode.height) {
      return constraint(computeSizeWithHeight(context, dimensions[0]),
          dimensions[1], dimensions[2]);
    }
    return constraint(computeSizeWithWidth(context, dimensions[0]),
        dimensions[1], dimensions[2]);
  }

  static double computeSizeWithHeight(
      BuildContext context, double scaleFactor) {
    double screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * scaleFactor;
  }

  static double computeSizeWithWidth(BuildContext context, double scaleFactor) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * scaleFactor;
  }

  static double constraint(
      double value, double minConstraint, double maxConstraint) {
    return max(minConstraint, min(maxConstraint, value));
  }
}
