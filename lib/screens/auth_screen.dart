import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CurvePainter extends CustomPainter {
  final bool isSignup;
  CurvePainter(this.isSignup);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill; // Change this to fill

    var shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 40);

    if (isSignup == false) {
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
    } else {
      //*Signup screen
      //! Shadow - up
      var path = Path();
      path.moveTo(0, size.height * 0.6);
      path.quadraticBezierTo(size.width * 0.75, size.height * 0.75,
          size.width * 1.15, size.height * 0.45);
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);

      canvas.drawPath(path, shadowPaint);

      path = new Path(); //! Space - up

      path.moveTo(0, size.height * 0.50);
      path.quadraticBezierTo(
          size.width * 0.6, size.height * 0.65, size.width, size.height * 0.43);
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);

      canvas.drawPath(path, paint);

      path = new Path(); //! Shadow - down

      path.moveTo(0, size.height * 0.95);
      path.quadraticBezierTo(size.width * 0.25, size.height * 0.65,
          size.width * 1.45, size.height * 0.6);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);

      canvas.drawPath(path, shadowPaint);

      path = new Path(); //! Space - down

      path.moveTo(0, size.height * 0.9);
      path.quadraticBezierTo(size.width * 0.15, size.height * 0.55,
          size.width * 1.35, size.height * 0.65);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignup = false;

  void toggleState() {
    setState(
      () {
        _isSignup = true;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: width,
            height: height,
            color: Colors.blueAccent,
            child: CustomPaint(
              painter: CurvePainter(_isSignup),
            ),
          ),
          Positioned(
            top: height * 0.13,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent,
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
          Positioned(
            top: height * 0.25,
            child: AuthCard(),
          ),
        ],
      ),
    );
  }
}

enum Mode { Login, Signup }

class AuthCard extends StatefulWidget {
  AuthCard({Key key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  Mode _authMode = Mode.Login;

  bool _isLoading = false;
  final _passwordController = TextEditingController();

  void toggleAuthMode() {
    if (_authMode == Mode.Login) {
      setState(() {
        _authMode = Mode.Signup;
      });
    } else {
      setState(() {
        _authMode = Mode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Container(
      height: height,
      width: width,
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              height: height * 0.055,
              padding: EdgeInsets.only(bottom: height * 0.005),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(height)),
                color: Colors.grey.withOpacity(0.2),
              ),
              width: width * 0.7,
              child: TextFormField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'E-Mail',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              height: height * 0.055,
              padding: EdgeInsets.only(bottom: height * 0.005),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(height)),
                color: Colors.grey.withOpacity(0.2),
              ),
              width: width * 0.7,
              child: TextFormField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            _authMode == Mode.Signup
                ? Container(
                    height: height * 0.055,
                    padding: EdgeInsets.only(bottom: height * 0.005),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(height)),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    width: width * 0.7,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Confirm password',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
