import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:http/http.dart' as http;

void main()=> runApp(MyApp());


class MyApp extends StatelessWidget {
  const MyApp({Key? Key}):super(key :Key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,

        home:
        JoystickAreaExample()



    );
  }
}
class JoystickAreaExample extends StatefulWidget {
  const JoystickAreaExample({Key? key}) : super(key: key);

  @override
  _JoystickAreaExampleState createState() => _JoystickAreaExampleState();
}

class _JoystickAreaExampleState extends State<JoystickAreaExample> {
  static const ballSize = 20.0;
  static const step = 10.0;
  double _x = 10.0;
  double _y = 10.0;
  JoystickMode _joystickMode = JoystickMode.all;
  TextEditingController _controller=TextEditingController();
  String userpost='';
  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.computer,size: 28,),
          title:Text('pono robot',
            style: TextStyle(fontSize:28),
          ),
          titleSpacing: 2.0,
          backgroundColor: Colors.black54,
        ),
        body:   Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                verticalDirection: VerticalDirection.up,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return  SecondPage();
                      }));
                    },
                    child: const Text('zeko',style: TextStyle(fontSize:28),),
                  ),
                  Center(
                    child: Joystick(

                      mode: _joystickMode,
                      listener: (details) async {
                        _x =  step * details.x;
                        _y =  step * details.y;
                        userpost=_controller.text;

                        print(_x);
                        print(_y);
                        var res = await http.post(
                          Uri.parse('http://'+userpost+'/control'),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: jsonEncode(<String, int>{
                            'y_pos': _y.round(),
                            'x_pos': _x.round(),
                          }),
                        );
                      },


                    ),
                  ),
                  TextField(

      controller: _controller,
                    decoration: InputDecoration(
                      hintText: "write the IP",
                      border: OutlineInputBorder(),


                    ),
                  ),

                ]
            )
        )
    );
  }
}

class SecondPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SecondPage> {
  bool status = false;
  bool status2=false;
  int mode=0;
  int manual=0;
  double _currentGirbValue = 0;
  double _currentbaseValue = 0;
  double _currentelbowValue = 50;
  double _x = 10;
  double _y = 10;
  JoystickMode _joystickMode = JoystickMode.all;
  TextEditingController _controller2=TextEditingController();
  String userpost2='';
  static const ballSize = 20.0;
  static const step = 100.0;

  @override
  Widget build(BuildContext context) {

    return
      Scaffold(


        appBar: AppBar(
          leading: Icon(Icons.computer,size: 28,),
          title:Text('ZiKo robot',
            style: TextStyle(fontSize:28),
          ),
          titleSpacing: 2.0,
          backgroundColor: Colors.black54,
        ),

        body:
        Container(

          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              verticalDirection: VerticalDirection.up,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return  JoystickAreaExample();
                    }));
                  },
                  child: const Text('pono',style: TextStyle(fontSize:28),),
                ),
                Column(
                  children: [
                    TextField(
                      controller: _controller2,
                      decoration: InputDecoration(
                        hintText: "write the IP",
                        border: OutlineInputBorder(),


                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: FlutterSwitch(
                            width: 55.0,
                            height: 30.0,
                            valueFontSize: 25.0,
                            toggleSize: 20.0,
                            value: status2,
                            borderRadius: 30.0,
                            padding: 8.0,
                            showOnOff: false,


                            onToggle: (val) async {
                              userpost2=_controller2.text;

                              setState(() {
                                status2 = val;

                                if (status2==false ) {
                                  manual=0;
                                  print("outo") ;

                                }
                                else if(status2==true) {
                                  manual =1;
                                  print("manual");

                                }
                              }
                              );
                              var res = await http.post(

                                Uri.parse('http://'+userpost2+'/control'),
                                headers: <String, String>{
                                  'Content-Type': 'application/json; charset=UTF-8',
                                },
                                body: jsonEncode(<String, int>{
                                  'manual':manual,
                                  'mode': mode,

                                  'x_pos': _x.round(),
                                  'y_pos': _y.round(),
                                  'grabber_angle': _currentGirbValue.round(),
                                  'base_angle': _currentbaseValue.round(),
                                  'link_angle': _currentelbowValue.round(),
                                }),
                              );
                            },

                          ),
                        ),
                        Text("manual",style: TextStyle(fontSize:23),),
                        Container(
                          child: FlutterSwitch(
                            width: 55.0,
                            height: 30.0,
                            valueFontSize: 25.0,
                            toggleSize: 20.0,
                            value: status,
                            borderRadius: 30.0,
                            padding: 8.0,
                            showOnOff: false,


                            onToggle: (val) async {
                              userpost2=_controller2.text;

                              setState(() {
                                status = val;

                                if (status==false ) {
                                  mode=0;
                                  print("line") ;

                                }
                                else if(status==true) {
                                  mode=1;
                                  print("opstacle");

                                }
                              }
                              );
                              var res = await http.post(

                                Uri.parse('http://'+userpost2+'/control'),
                                headers: <String, String>{
                                  'Content-Type': 'application/json; charset=UTF-8',
                                },
                                body: jsonEncode(<String, int>{
                                  'manual':manual,
                                  'mode': mode,

                                  'x_pos': _x.round(),
                                  'y_pos': _y.round(),
                                  'grabber_angle': _currentGirbValue.round(),
                                  'base_angle': _currentbaseValue.round(),
                                  'link_angle': _currentelbowValue.round(),
                                }),
                              );
                            },

                          ),
                        ),
                        Text("obstacle ",style: TextStyle(fontSize:23),)
                      ],
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Joystick(
                        mode: _joystickMode,
                        listener: (details) async {
                          _x =  step * details.x;
                          _y =  step * details.y;
                          userpost2=_controller2.text;
                          print(_x);
                          print(_y);
                          var res = await http.post(
                            Uri.parse('http://'+userpost2+'/control'),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: jsonEncode(<String, int>{
                              'manual':manual,
                              'mode': mode,

                              'x_pos': _x.round(),
                              'y_pos': _y.round(),
                              'grabber_angle': _currentGirbValue.round(),
                              'base_angle': _currentbaseValue.round(),
                              'link_angle': _currentelbowValue.round(),
                            }),
                          );


                          setState(() {


                          });


                        },

                      ),
                    ),

                    Text("Grip",style: TextStyle(fontSize:20) ,),
                    Slider(

                      value: _currentGirbValue,
                      min: -30,
                      max: 60,
                      divisions: 10,
                      label: _currentGirbValue.round().toString(),
                      onChanged: (double value) async {
                        userpost2=_controller2.text;
                        setState(()  {
                          _currentGirbValue = value;

                        });
                        var res = await http.post(
                          Uri.parse('http://'+userpost2+'/control'),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: jsonEncode(<String, int>{
                            'manual':manual,
                            'mode': mode,

                            'x_pos': _x.round(),
                            'y_pos': _y.round(),
                            'grabber_angle': _currentGirbValue.round(),
                            'base_angle': _currentbaseValue.round(),
                            'link_angle': _currentelbowValue.round(),
                          }),
                        );


                      },
                    ),
                    Text("Base",style: TextStyle(fontSize:20) ,),
                    Slider(

                      value: _currentbaseValue,
                      min: -90,
                      max: 100,

                      divisions: 10,
                      label: _currentbaseValue.round().toString(),
                      onChanged: (double value) async {
                        setState(()  {
                          _currentbaseValue = value;
                          userpost2=_controller2.text;
                        });

                        var res = await http.post(
                          Uri.parse('http://'+userpost2+'/control'),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: jsonEncode(<String, int>{
                            'manual':manual,
                            'mode': mode,

                            'x_pos': _x.round(),
                            'y_pos': _y.round(),
                            'grabber_angle': _currentGirbValue.round(),
                            'base_angle': _currentbaseValue.round(),
                            'link_angle': _currentelbowValue.round(),
                          }),
                        );



                      },
                    ),
                    Text("Link",style: TextStyle(fontSize:20) ,),
                    Slider(

                      value: _currentelbowValue,
                      min: 50,
                      max: 120,

                      divisions: 10,
                      label: _currentelbowValue.round().toString(),
                      onChanged: (double value) async {
                        setState(()  {
                          _currentelbowValue = value;
                          userpost2=_controller2.text;
                        });
                        var res = await http.post(
                          Uri.parse('http://'+userpost2+'/control'),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: jsonEncode(<String, int>{
                            'manual':manual,
                            'mode': mode,

                            'x_pos': _x.round(),
                            'y_pos': _y.round(),
                            'grabber_angle': _currentGirbValue.round(),
                            'base_angle': _currentbaseValue.round(),
                            'link_angle': _currentelbowValue.round(),
                          }),
                        );
                      },
                    ),
                  ],
                ),


              ]
          ),
        ),
      );
  }
}
