import 'windows.dart';

void main() {
  var app = Window('App', title: 'Windows!');
  
  Window.initState = () {
    print('This is called when your gui is created!');
  };

  app.text('Yo', 100, 100);
  app.line(0, 0, 50, 50);

  app.run();
}