import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class MovieDetailsSceletonWidget extends StatelessWidget {
  const MovieDetailsSceletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.grey.shade500,
      child: SkeletonItem(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TopPosterSceletonWidget(),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: _MovieNameSceletonWidget(),
            ),
            const _ScoreSceletonWidget(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 60),
              child: _SummerySceletonWidget(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: _overviewSceletonWidget(),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: DescriptionWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

//?-----------------------------------------------------------------------------
class _TopPosterSceletonWidget extends StatelessWidget {
  const _TopPosterSceletonWidget();

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 390 / 219,
      child: SkeletonLine(
        style: SkeletonLineStyle(height: double.infinity),
      ),
    );
  }
}

//?-----------------------------------------------------------------------------
class _MovieNameSceletonWidget extends StatelessWidget {
  const _MovieNameSceletonWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SkeletonLine(
      style: SkeletonLineStyle(
          height: 18,
          width: 200,
          borderRadius: BorderRadius.circular(8),
          alignment: Alignment.center),
    ));
  }
}

//?-----------------------------------------------------------------------------
class _ScoreSceletonWidget extends StatelessWidget {
  const _ScoreSceletonWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 14,
              width: 135,
              borderRadius: BorderRadius.circular(8),
              // alignment: Alignment.center),
            ),
          ),
          //--------------------------------------
          Container(height: 15, width: 2, color: Colors.grey),
          //--------------------------------------
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 14,
              width: 135,
              borderRadius: BorderRadius.circular(8),
              // alignment: Alignment.center),
            ),
          ),
        ],
      ),
    );
  }
}

//?-----------------------------------------------------------------------------
class _SummerySceletonWidget extends StatelessWidget {
  const _SummerySceletonWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SkeletonParagraph(
      style: SkeletonParagraphStyle(
          lines: 2,
          spacing: 6,
          lineStyle: SkeletonLineStyle(
            //randomLength: true,
            alignment: Alignment.center,
            width: 200,
            height: 12,
            borderRadius: BorderRadius.circular(8),
            minLength: MediaQuery.of(context).size.width / 3,
            maxLength: MediaQuery.of(context).size.width / 2,
          )),
    ));
  }
}

//?-----------------------------------------------------------------------------
_overviewSceletonWidget() {
  return SkeletonLine(
    style: SkeletonLineStyle(
      height: 10,
      width: 80,
      borderRadius: BorderRadius.circular(8),
      // alignment: Alignment.center),
    ),
  );
}

//?-----------------------------------------------------------------------------
class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonParagraph(
      style: SkeletonParagraphStyle(
          lines: 4,
          spacing: 6,
          lineStyle: SkeletonLineStyle(
            //randomLength: true,
            alignment: Alignment.centerLeft,

            height: 10,
            minLength: MediaQuery.of(context).size.width * 0.75,
            maxLength: MediaQuery.of(context).size.width,
            borderRadius: BorderRadius.circular(8),
          )),
    );
  }
}
