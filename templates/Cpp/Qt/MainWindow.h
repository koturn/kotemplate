#ifndef <+INCLUDE_GUARD+>
#define <+INCLUDE_GUARD+>

#include <QMainWindow>

namespace Ui {
class <+FILE_PASCAL+>;
}

class <+FILE_PASCAL+> : public QMainWindow
{
  Q_OBJECT

public:
  explicit <+FILE_PASCAL+>(QWidget* parent = Q_NULLPTR);
  ~<+FILE_PASCAL+>();

private:
  QScopedPointer<Ui::<+FILE_PASCAL+>> ui;
};

#endif // <+INCLUDE_GUARD+>
