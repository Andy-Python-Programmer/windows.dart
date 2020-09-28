import 'package:windows_dart/windows.dart';

void main() async {
  var app = Window('App', 500, 1000, title: 'Windows!');

  Window.initState = () {
    print('This is called when your gui is created!');
  };

  Window.disposeState = () {
    print('This is called on app is quited!');
  };

  app.text('Yo', 500, 200);
  app.line(0, 0, 100, 100);

  app.block(100, 10, 200, 20, Color.red);
  app.block(300, 10, 200, 20, Color.green);
  app.block(500, 10, 200, 20, Color.blue);
  app.block(700, 10, 200, 20, Color.black);
  app.block(900, 10, 200, 20, Color.white);

  print(app.width);
  print(app.height);

  app.run();
}
