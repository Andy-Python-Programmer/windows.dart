import 'dart:ffi';
import 'package:win32/win32.dart';
import 'package:ffi/ffi.dart';

class Window {
  var wc = WNDCLASS.allocate();
  final hInstance = GetModuleHandle(nullptr);

  final name;
  final String title;
  final int width;
  final int height;
  static Function initState;
  static Function disposeState;

  static List painter = [];

  static int _mainWindowProc(int hWnd, int uMsg, int wParam, int lParam) {
    switch (uMsg) {
      case WM_DESTROY:
        disposeState == null ? () {} : disposeState();

        PostQuitMessage(0);
        return 0;

      case WM_CREATE:
        initState == null ? () {} : initState();

        return 0;

      case WM_PAINT:
        final ps = PAINTSTRUCT.allocate();
        final hdc = BeginPaint(hWnd, ps.addressOf);

        painter.forEach((element) {
          element(hdc, hWnd);
        });

        EndPaint(hWnd, ps.addressOf);
        free(ps.addressOf);

        return 0;
    }
    return DefWindowProc(hWnd, uMsg, wParam, lParam);
  }

  Window(this.name, this.width, this.height, {this.title}) {
    wc.hbrBackground = GetStockObject(WHITE_BRUSH);
    wc.hCursor = LoadCursor(NULL, IDC_ARROW);
    wc.hInstance = hInstance;
    wc.lpszClassName = TEXT(name);
    wc.lpfnWndProc = Pointer.fromFunction<WindowProc>(_mainWindowProc, 0);

    RegisterClass(wc.addressOf);
  }

  int run() {
    final hWnd = CreateWindowEx(
        0, // Optional window styles.
        wc.lpszClassName, // Window class
        TEXT(title ?? 'App'), // Window caption
        WS_OVERLAPPEDWINDOW, // Window style

        // Size and position
        CW_USEDEFAULT,
        CW_USEDEFAULT,
        height,
        width,
        NULL, // Parent window
        NULL, // Menu
        hInstance, // Instance handle
        nullptr // Additional application data
        );

    if (hWnd == 0) {
      final error = GetLastError();
      throw WindowsException(HRESULT_FROM_WIN32(error));
    }

    ShowWindow(hWnd, SW_SHOWNORMAL);
    UpdateWindow(hWnd);

    // Run the message loop
    final msg = MSG.allocate();
    while (GetMessage(msg.addressOf, NULL, 0, 0) != 0) {
      TranslateMessage(msg.addressOf);
      DispatchMessage(msg.addressOf);
    }

    return 0;
  }

  int text(String text, x, y) {
    painter.add((hdc, hWnd) {
      final textPtr = TEXT(text);
      TextOut(hdc, x, y, textPtr, text.length);
      free(textPtr);
    });

    return 0;
  }

  int line(x1, y1, x2, y2) {
    painter.add((hdc, hWnd) {
      MoveToEx(hdc, x1, y1, nullptr);
      LineTo(hdc, x2, y2);
    });
    return 0;
  }

  int block(int x1, int y1, int x2, int y2, int color) {
    painter.add((hdc, hWnd) {
      final rect = RECT.allocate();
      final hBrush = CreateSolidBrush(color);
      rect.left = x1;
      rect.right = x1 + x2;
      rect.top = y1;
      rect.bottom = y1 + y2;

      FillRect(hdc, rect.addressOf, hBrush);

      DeleteObject(hBrush);
    });

    return 0;
  }
}
