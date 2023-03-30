import 'package:acroworld/screens/home_screens/events/widgets/carousel_slider_card.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselSliderWidget extends StatefulWidget {
  const CarouselSliderWidget(
      {required this.sliders, Key? key, this.isDots = true})
      : super(key: key);
  final List sliders;

  final bool isDots;

  @override
  State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return widget.sliders.isNotEmpty
        ? Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 10),
                  viewportFraction: 0.95,
                  onPageChanged: (index, reason) {
                    setState(
                      () {
                        _currentIndex = index;
                      },
                    );
                  },
                ),
                items: widget.sliders
                    .map((item) => CarouselSliderCard(item: item))
                    .toList(),
              ),
              widget.isDots
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.sliders.map((obj) {
                        int index = widget.sliders.indexOf(obj);
                        return Container(
                          width: 10.0,
                          height: 10.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: PRIMARY_COLOR),
                            shape: BoxShape.circle,
                            color: _currentIndex == index
                                ? PRIMARY_COLOR
                                : Colors.white,
                          ),
                        );
                      }).toList(),
                    )
                  : Container()
            ],
          )
        : Container();
  }
}
