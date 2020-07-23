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
  bool _isLoading = false;

  final _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void toggleState() {
    setState(
      () {
        _isSignup = !_isSignup;
      },
    );
  }

  void _submit() {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    //print(_authData['email']);
    //print(_authData['password']);
    setState(() {
      _isLoading = true;
    });
    if (!_isSignup) {
      // Log user in
    } else {
      // Sign user up
    }
    setState(() {
      _isLoading = false;
    });
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
            child: Container(
              height: height,
              width: width,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: height * 0.055,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(height)),
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      width: width * 0.7,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(bottom: height * 0.005),
                          hintText: 'E-Mail',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['email'] = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      height: height * 0.055,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(height)),
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      width: width * 0.7,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(bottom: height * 0.005),
                          hintText: 'Password',
                          border: InputBorder.none,
                        ),
                        controller: _passwordController,
                        validator: (value) {
                          if (value.isEmpty || value.length < 5) {
                            return 'Password is too short!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['password'] = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    _isSignup
                        ? Container(
                            height: height * 0.055,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(height)),
                              color: Colors.grey.withOpacity(0.2),
                            ),
                            width: width * 0.7,
                            child: TextFormField(
                              obscureText: true,
                              enabled: _isSignup,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(bottom: height * 0.005),
                                hintText: 'Confirm password',
                                border: InputBorder.none,
                              ),
                              validator: _isSignup
                                  ? (value) {
                                      if (value != _passwordController.text ||
                                          value.isEmpty) {
                                        return 'Passwords do not match!';
                                      }
                                      return null;
                                    }
                                  : null,
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: _isSignup
                          ? height * 0.33 - height * 0.055
                          : height * 0.33,
                    ),
                    _isLoading
                        ? CircularProgressIndicator()
                        : Column(
                            children: <Widget>[
                              Container(
                                width: width * 0.55,
                                child: RaisedButton(
                                  color: Colors.blueAccent.withOpacity(0.7),
                                  onPressed: _submit,
                                  child:
                                      Text('${_isSignup ? 'Signup' : 'Login'}'),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(height),
                                  ),
                                ),
                              ),
                              FlatButton(
                                child: Text(
                                    '${_isSignup ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                                onPressed: toggleState,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ],
                          )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
