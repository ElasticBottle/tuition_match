//..lib/main.dart

import 'package:auto_route/auto_route.dart';
import 'package:cotor/common_widgets/custom_raised_button.dart';
import 'package:cotor/constants/keys.dart';
import 'package:cotor/features/onboarding/domain/entities/onboard_info.dart';
import 'package:cotor/features/onboarding/presentation/bloc/bloc.dart';
import 'package:cotor/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:cotor/routing/router.gr.dart';

const Color BLUE_GRAY = Colors.blueGrey;
const Color ORANGE_ACCENT = Colors.orangeAccent;

class OnboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider<OnboardingBloc>(
        create: (_) => sl<OnboardingBloc>(),
        child: OnboardPageSlide(),
      ),
    );
  }
}

class OnboardPageSlide extends StatefulWidget {
  const OnboardPageSlide();
  @override
  OnboardPageSlideState createState() {
    return OnboardPageSlideState();
  }
}

class OnboardPageSlideState extends State<OnboardPageSlide> {
  final IndexController controller = IndexController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (BuildContext context, OnboardingState state) {
        return Stack(
          children: <Widget>[
            TransformerPageView(
              pageSnapping: true,
              onPageChanged: (index) {
                currentIndex = index;
                BlocProvider.of<OnboardingBloc>(context)
                    .add(GetNextOnboardingInfo(index: index));
              },
              loop: false,
              controller: controller,
              transformer: PageTransformerBuilder(
                  builder: (Widget child, TransformInfo info) {
                Widget mainbody = Container();
                if (state is InitialOnboardingState) {
                  BlocProvider.of<OnboardingBloc>(context)
                      .add(GetNextOnboardingInfo(index: 0));
                } else if (state is Loading) {
                  mainbody = LoadingWidget();
                } else if (state is Loaded) {
                  mainbody = OnboardInfoDisplay(
                    onboardInfo: state.info,
                    transformInfo: info,
                  );
                } else if (state is Error) {}
                return PageViewBody(
                  currentIndex: currentIndex,
                  mainBody: mainbody,
                  info: info,
                  totalLength: BlocProvider.of<OnboardingBloc>(context)
                      .initialState
                      .props[0],
                  controller: controller,
                );
              }),
              itemCount: BlocProvider.of<OnboardingBloc>(context)
                  .initialState
                  .props[0],
            ),
            if (currentIndex + 1 ==
                BlocProvider.of<OnboardingBloc>(context).initialState.props[0])
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 25.0, 25.0),
                  child: CustomRaisedButton(
                    key: Key(Keys.finishOnboard),
                    child: Icon(Icons.arrow_forward_ios),
                    borderRadius: 150.0,
                    width: 50.0,
                    height: 50.0,
                    textColor: BLUE_GRAY,
                    color: ORANGE_ACCENT,
                    onPressed: () => Navigator.of(context, rootNavigator: true)
                        .pushNamed(Routes.signInPageBuilder),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class PageViewBody extends StatelessWidget {
  const PageViewBody(
      {this.info,
      this.currentIndex,
      this.mainBody,
      this.totalLength,
      this.controller});
  final TransformInfo info;
  final Widget mainBody;
  final int currentIndex;
  final int totalLength;
  final IndexController controller;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 8.0,
      textStyle: TextStyle(color: Colors.white),
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        alignment: Alignment.center,
        color: Colors.white,
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            mainBody,
            ParallaxContainer(
              position: info.position,
              translationFactor: 600.0,
              child: Dots(
                controller: controller,
                slideIndex: currentIndex,
                numberOfDots: totalLength,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class OnboardInfoDisplay extends StatelessWidget {
  const OnboardInfoDisplay({this.onboardInfo, this.transformInfo});
  final OnboardInfo onboardInfo;
  final TransformInfo transformInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ParallaxContainer(
          child: Text(
            onboardInfo.title,
            style: TextStyle(
                color: BLUE_GRAY,
                fontSize: 34.0,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold),
          ),
          position: transformInfo.position,
          opacityFactor: .8,
          translationFactor: 200.0,
        ),
        SizedBox(
          height: 35.0,
        ),
        ParallaxContainer(
          child: Image(
            image: onboardInfo.image,
            fit: BoxFit.contain,
            height: 350,
          ),
          position: transformInfo.position,
          translationFactor: 400.0,
        ),
        SizedBox(
          height: 35.0,
        ),
        ParallaxContainer(
          child: Text(
            onboardInfo.description,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: BLUE_GRAY,
                fontSize: 24.0,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold),
          ),
          position: transformInfo.position,
          translationFactor: 250.0,
        ),
        SizedBox(
          height: 55.0,
        ),
      ],
    );
  }
}

class Dots extends StatelessWidget {
  const Dots({this.controller, this.slideIndex, this.numberOfDots});
  final IndexController controller;
  final int slideIndex;
  final int numberOfDots;

  Widget _activeSlide(int index) {
    return GestureDetector(
      onTap: () {
        print('Tapped');
        // controller.move(index);
      },
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
              color: ORANGE_ACCENT.withOpacity(.3),
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inactiveSlide(int index) {
    return GestureDetector(
      onTap: () {
        controller.move(index);
      },
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(left: 5.0, right: 5.0),
          child: Container(
            width: 14.0,
            height: 14.0,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.7),
                borderRadius: BorderRadius.circular(50.0)),
          ),
        ),
      ),
    );
  }

  List<Widget> _generateDots() {
    final List<Widget> dots = [];
    for (int i = 0; i < numberOfDots; i++) {
      dots.add(i == slideIndex ? _activeSlide(i) : _inactiveSlide(i));
    }
    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _generateDots(),
    ));
  }
}
