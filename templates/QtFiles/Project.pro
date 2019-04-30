QT += core gui

greaterThan(QT_MAJOR_VERSION, 4) {
  QT += widgets
  CONFIG += c++11
} else {
  QMAKE_CXXFLAGS += -std=c++0x
}

TARGET = <+FILE_PASCAL+>
TEMPLATE = app


SOURCES += \
  main.cpp \
  MainWindow.cpp

HEADERS += MainWindow.h

FORMS += MainWindow.ui

win32: {
  RC_ICONS = icon.ico
} mac: {
  ICON = icon.icns
}
