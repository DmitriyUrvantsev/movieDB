import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class MovieScreenSkeletonWidget extends StatelessWidget {
  const MovieScreenSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      // Stack для TextFielda
      children: [
        ListView.builder(
          padding: const EdgeInsets.only(top: 65),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemExtent: 162,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color.fromARGB(182, 68, 68, 68),
                    // width: 1.0,
                    // style: BorderStyle.solid,
                    // strokeAlign: BorderSide.strokeAlignInside
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      offset: Offset(0, 3),
                      blurRadius: 10,

                      //blurStyle: BlurStyle.normal
                    )
                  ],
                ),
                child: SkeletonItem(
                  child: Row(
                    children: [
                      const SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                            width: 95, height: double.infinity),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 20),
                            SkeletonLine(
                              style: SkeletonLineStyle(
                                  height: 16,
                                  width: double.infinity,
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            const SizedBox(height: 10),
                            SkeletonLine(
                              style: SkeletonLineStyle(
                                  height: 16,
                                  width: 60,
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            const SizedBox(height: 20),
                            SkeletonParagraph(
                              style: SkeletonParagraphStyle(
                                  lines: 3,
                                  spacing: 6,
                                  lineStyle: SkeletonLineStyle(
                                    randomLength: true,
                                    height: 10,
                                    borderRadius: BorderRadius.circular(8),
                                    minLength:
                                        MediaQuery.of(context).size.width / 2,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: TextField(
            // controller: _serchController,
            onChanged: (value) {},
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white.withAlpha(210),
              labelText: 'Поиск',
            ),
          ),
        )
      ],
    );
  }
}
