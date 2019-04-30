#include "<+FILE_PASCAL+>.h"
#include "ui_<+FILE_PASCAL+>.h"

<+FILE_PASCAL+>::<+FILE_PASCAL+>(QWidget* parent) :
  QMainWindow(parent),
  ui(new Ui::<+FILE_PASCAL+>)
{
  ui->setupUi(this);
}

<+FILE_PASCAL+>::~<+FILE_PASCAL+>()
{}
