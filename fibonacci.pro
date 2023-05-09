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
    src/settingsmanager.cpp \
    src/calculator.cpp

    HEADERS += \
    src/settingsmanager.h \
    src/calculator.hpp \
    src/exprtk.hpp


OTHER_FILES += \
    rpm/harbour-fibonacci.spec \
    harbour-fibonacci.desktop \
    qml/cover/CoverPage.qml \
    qml/cover/harbour-fibonacci.png \
    qml/harbour-fibonacci.qml \
    qml/pages/*.qml \
    qml/elements/*.qml \
    qml/components/*.qml \

layout.path = /usr/share/maliit/plugins/com/jolla/layouts
layout.files = layouts/programmers.qml layouts/layouts_programmers.conf

python.path = /usr/share/$${TARGET}/qml
python.files = python


libs.path = /usr/share/$${TARGET}
libs.files = lib


INSTALLS += layout
INSTALLS += python
INSTALLS += libs


SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172 256x256



