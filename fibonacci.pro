# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-fibonacci

CONFIG += c++17
CONFIG += sailfishapp
QMAKE_CXXFLAGS += -std=c++17

SOURCES += \
    src/harbour-fibonacci.cpp \
    src/settingsmanager.cpp

    HEADERS += \
    src/settingsmanager.h

OTHER_FILES += \
    rpm/harbour-fibonacci.spec \
    harbour-rpncalc.desktop \
    qml/cover/CoverPage.qml \
    qml/pages/MainPage.qml \
    qml/cover/harbour-fibonacci.png \
    qml/harbour-fibonacci.qml \
    qml/pages/Settings.qml \
    qml/pages/SymbolPage.qml \
    qml/pages/WideLandscape.qml \
    qml/elements/KeyboardButton.qml \
    qml/elements/CalcScreen.qml \
    qml/elements/Memory.qml \
    qml/elements/StdKeyboard.qml \
    qml/elements/Popup.qml \
    qml/elements/StackFlick.qml \
    qml/elements/PythonGlue.qml \
    qml/elements/CustomBackgroundItem.qml \
    qml/elements/CustomGlassItem.qml \
    qml/elements/OperandEditor.qml \

python.path = /usr/share/$${TARGET}
python.files = python


libs.path = /usr/share/$${TARGET}
libs.files = lib


INSTALLS += python
INSTALLS += libs


SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172 256x256



