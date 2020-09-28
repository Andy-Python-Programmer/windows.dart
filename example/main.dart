import '../bin/windows.dart';

Future sleep() {
  return Future.delayed(const Duration(seconds: 1), () {});
}

void main() async {
  var app = Window('App', title: 'Windows!');
  
  Window.initState = () {
    print('This is called when your gui is created!');
  };

  Window.disposeState = () {
    print('This is called on app is quited!');
  };

  app.text('Yo', 100, 100);
  app.line(0, 0, 50, 50);

  app.block(100, 10, 200, 20, 0x0000FF00);

  app.run();
}