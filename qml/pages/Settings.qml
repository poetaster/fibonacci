import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

Page {
    id :settingsPage

    allowedOrientations: Screen.sizeCategory > Screen.Medium ? Orientation.All : Orientation.Portrait

    PageHeader {
        id: header
        title: "Settings"
    }

    SilicaFlickable {
        anchors.top: header.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: parent.height

        //contentWidth: column.width; contentHeight: column.height

        Column {
            id: column
            spacing: 10


            width:parent.width
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            //anchors.fill: parent

            ComboBox{
                label: "Trigonometric unit"
                currentIndex: settings.angleUnit == "Degree" ? 1 : settings.angleUnit == "Gradient" ? 2 : 0

                menu: ContextMenu {
                    MenuItem { text: "Radian" }
                    MenuItem { text: "Degree" }
                    MenuItem { text: "Gradient" }
                }

                onCurrentItemChanged: {
                    settings.angleUnit = currentItem.text;
                }
            }

            ComboBox{
                label: "Stack view precision"
                currentIndex: settings.reprFloatPrecision - 1

                menu: ContextMenu {
                    MenuItem { text: "1"; }
                    MenuItem { text: "2"; }
                    MenuItem { text: "3"; }
                    MenuItem { text: "4"; }
                    MenuItem { text: "5"; }
                    MenuItem { text: "6"; }
                    MenuItem { text: "7"; }
                    MenuItem { text: "8"; }
                    MenuItem { text: "9"; }
                    MenuItem { text: "10"; }
                    MenuItem { text: "11"; }
                    MenuItem { text: "12"; }
                    MenuItem { text: "13"; }
                    MenuItem { text: "14"; }
                    MenuItem { text: "15"; }
                    MenuItem { text: "16"; }
                    MenuItem { text: "17"; }
                    MenuItem { text: "18"; }
                    MenuItem { text: "19"; }
                    MenuItem { text: "20"; }
                    MenuItem { text: "21"; }
                    MenuItem { text: "22"; }
                    MenuItem { text: "23"; }
                    MenuItem { text: "24"; }
                    MenuItem { text: "25"; }
                    MenuItem { text: "26"; }
                    MenuItem { text: "27"; }
                    MenuItem { text: "28"; }
                    MenuItem { text: "29"; }
                    MenuItem { text: "30"; }

                }

                onCurrentItemChanged: {
                    settings.reprFloatPrecision = Number(currentItem.text);
                }
            }

            TextSwitch {
                text: "Symbolic mode"
                checked: settings.symbolicMode

                onCheckedChanged: {
                    settings.symbolicMode = checked;
                }
            }

            TextSwitch {
                text: "Rational mode"
                checked: settings.rationalMode

                onCheckedChanged: {
                    settings.rationalMode = checked;
                }
            }

            /* Not functionnal
            TextSwitch {
                text: "Auto simplify expression"
                checked: settings.autoSimplify

                onCheckedChanged: {
                    settings.autoSimplify = checked;
                }
            }
            */
            Item {
                width: parent.width
                height: Theme.paddingLarge
            }
            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: "GNU General Public License v2. Many thanks to the following:"
            }
            Item {
                width: parent.width
                height: Theme.paddingLarge
            }
            Label {
                id: iconLabel
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.primaryColor
                textFormat: Text.StyledText
                linkColor: Theme.highlightColor
                text: "<a href=\"\https://github.com/ArashPartow/exprtk\">Exprtk c++ expression evaluation library.</a>"
                onLinkActivated: {
                    Qt.openUrlExternally(link)
                }
            }
            Item {
                width: parent.width
                height: Theme.paddingLarge
            }
            Label {
                id: sympylabel
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.primaryColor
                textFormat: Text.StyledText
                linkColor: Theme.highlightColor
                text: "<a href=\"\https://github.com/sympy/sympy\">Sympy Symbolic library</a>"
                onLinkActivated: {
                    Qt.openUrlExternally(link)
                }
            }
            Item {
                width: parent.width
                height: Theme.paddingLarge
            }
            Label {
                id: radarLabel
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.primaryColor
                textFormat: Text.StyledText
                linkColor: Theme.highlightColor
                text: "RPN part thanks to  Richard Rondu\n" +
                      " <a href=\"https://github.com/lainwir3d/sailfish-rpn-calculator\">Sailfish Rpncalc</a>"
                onLinkActivated: {
                    Qt.openUrlExternally(link)
                }
            }
            Item {
                width: parent.width
                height: Theme.paddingLarge
            }
            Label {
                id: rabaukeLabel
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.primaryColor
                textFormat: Text.StyledText
                linkColor: Theme.highlightColor
                text: "Many thanks to Heiko Bauke \n" +
                      "<a href=\"https://github.com/rabauke/harbour-babbage\">Babbage</a>"
                onLinkActivated: {
                    Qt.openUrlExternally(link)
                }
            }
            Item {
                width: parent.width
                height: Theme.paddingLarge
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: Theme.paddingSmall
                color: Theme.secondaryColor
                textFormat: Text.StyledText
                linkColor: Theme.highlightColor
                text:  " © 2023 Mark Washeim <a href=\"https://github.com/poetaster/fibonacci\">Source: github</a>"
                onLinkActivated: {
                    Qt.openUrlExternally(link)
                }
            }
        }

    }
}
