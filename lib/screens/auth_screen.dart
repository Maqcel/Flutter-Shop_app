import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: width,
            height: height,
            color: Colors.blue,
            child: CustomPaint(
              painter: CurvePainter(),
            ),
          ),
          Positioned(
            top: height * 0.13,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              height: height * 0.1,
              width: height * 0.1,
              child: Icon(
                MdiIcons.accountOutline,
                color: Colors.white,
                size: height * 0.06,
              ),
            ),
          ),
          // TODO - Wire up Form.
          // Positioned(
          //   child: Container(),
          // ),
        ],
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill; // Change this to fill

    var shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 40);

    var path = Path(); //! Shadow - up

    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.65, size.height * 0.65,
        size.width * 1.05, size.height * 0.35);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, shadowPaint);

    path = new Path(); //! Space - up

    path.moveTo(0, size.height * 0.45);
    path.quadraticBezierTo(
        size.width * 0.6, size.height * 0.6, size.width, size.height * 0.3);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);

    path = new Path(); //! Shadow - down

    path.moveTo(0, size.height * 0.85);
    path.quadraticBezierTo(size.width * 0.15, size.height * 0.55,
        size.width * 1.35, size.height * 0.5);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, shadowPaint);

    path = new Path(); //! Space - down

    path.moveTo(0, size.height * 0.85);
    path.quadraticBezierTo(size.width * 0.15, size.height * 0.55,
        size.width * 1.35, size.height * 0.5);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
