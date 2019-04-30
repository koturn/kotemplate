#include <windows.h>

#if defined(_MSC_VER) && !defined(DISABLE_PRAGMA_LINK)
#  pragma comment(lib, "gdi32")
#  pragma comment(lib, "user32")
#endif

#ifndef __UNUSED__
#  if defined(__cplusplus)
#    define __UNUSED__(x)
#  elif defined(__GNUC__)
#    define __UNUSED__(x)  __UNUSED___ ## x __attribute__((unused))
#  elif defined(_MSC_VER)
#    define __UNUSED__(x)  __pragma(warning(suppress: 4100)) x
#  elif defined(__LCLINT__)
#    define __UNUSED__(x)  /*@unused@*/ x
#  else
#    define __UNUSED__(x)  x
#  endif
#endif

LRESULT CALLBACK WndProc(HWND hCurInst, UINT hPrevInst, WPARAM lpsCmdLine, LPARAM nCmdShow);
ATOM InitApp(HINSTANCE hInst);
BOOL InitInstance(HINSTANCE hInst, int nCmdShow);

TCHAR szClassName[] = TEXT("<+FILEBASE+>");


int WINAPI
WinMain(HINSTANCE hCurInst, HINSTANCE __UNUSED__(hPrevInst), LPSTR __UNUSED__(lpsCmdLine), int nCmdShow)
{
  MSG msg;
  BOOL bRet;

  if (!InitApp(hCurInst)) return FALSE;
  if (!InitInstance(hCurInst, nCmdShow)) return FALSE;
  while ((bRet = GetMessage(&msg, NULL, 0, 0)) != 0) {
    if (bRet == -1) {
      MessageBox(NULL, TEXT("GetMessage Error"), TEXT("error"), MB_OK);
      break;
    } else {
      TranslateMessage(&msg);
      DispatchMessage(&msg);
    }
  }
  return (int) msg.wParam;
}


ATOM
InitApp(HINSTANCE hInst)
{
  WNDCLASSEX wc;
  wc.cbSize = sizeof(WNDCLASSEX);
  wc.style = CS_HREDRAW | CS_VREDRAW;
  wc.lpfnWndProc = WndProc;
  wc.cbClsExtra = 0;
  wc.cbWndExtra = 0;
  wc.hInstance = hInst;
  wc.hIcon = (HICON) LoadImage(
      NULL,
      MAKEINTRESOURCE(IDI_APPLICATION),
      IMAGE_ICON,
      0,
      0,
      LR_DEFAULTSIZE | LR_SHARED);
  wc.hCursor = (HCURSOR) LoadImage(
      NULL,
      MAKEINTRESOURCE(IDC_ARROW),
      IMAGE_CURSOR,
      0,
      0,
      LR_DEFAULTSIZE | LR_SHARED);
  wc.hbrBackground = (HBRUSH) GetStockObject(WHITE_BRUSH);
  wc.lpszMenuName = NULL;
  wc.lpszClassName = szClassName;
  wc.hIconSm = (HICON) LoadImage(
      NULL,
      MAKEINTRESOURCE(IDI_APPLICATION),
      IMAGE_ICON,
      0,
      0,
      LR_DEFAULTSIZE | LR_SHARED);
  return RegisterClassEx(&wc);
}


BOOL
InitInstance(HINSTANCE hInst, int nCmdShow)
{
  HWND hWnd = CreateWindow(
      szClassName,
      TEXT("<+FILEBASE+>"),
      WS_OVERLAPPEDWINDOW,
      CW_USEDEFAULT,  /* x-coordinate */
      CW_USEDEFAULT,  /* y-coordinate */
      CW_USEDEFAULT,  /* width */
      CW_USEDEFAULT,  /* height */
      NULL,
      NULL,
      hInst,
      NULL);
  if (!hWnd) return FALSE;
  ShowWindow(hWnd, nCmdShow);
  UpdateWindow(hWnd);
  return TRUE;
}


LRESULT CALLBACK
WndProc(HWND hWnd, UINT msg, WPARAM wp, LPARAM lp)
{
  switch (msg) {
    case WM_DESTROY:
      PostQuitMessage(0);
      break;
    default:
      return DefWindowProc(hWnd, msg, wp, lp);
  }
  return 0;
}
