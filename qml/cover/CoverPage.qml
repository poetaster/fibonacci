import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {

    function format(variable, formula, result) {
         if (navigationState.name === "exprtk") {
                 return variable + "\n\n" + formula + " =\n " + result
         } else {
          return (variable !== "") && (formula === result) ? variable + " = " + result : ((variable !== "" ? variable + " = " : "") + formula + " = " + result)
         }
    }

    function formatNumber(n, maxsize){
        var str = String(n);
        var l = str.length;
        var round_n;

        if(l > maxsize){

            if(str.split('e').length > 1){
                round_n = Number(n).toPrecision(maxsize-5);
            }else{
                round_n = Number(n).toPrecision(maxsize);
                if(String(round_n).length > maxsize){
                    round_n = Number(n).toExponential(maxsize-4);
                }
            }

            str = String(round_n);
        }

        return str;
    }

    Rectangle {
        id: screen
        color: Theme.secondaryHighlightColor
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 10
            leftMargin: 10
            rightMargin: 10
        }
        height: column.height + 10

        Column {
                id: column

                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: 4
                    leftMargin: 4
                }
                width: parent.width - 10
                Row{
                    width: parent.width
                    Label {
                        id: stack_1_id
                        horizontalAlignment: Text.AlignLeft
                        color: Theme.primaryColor
                        text: "2:"
                    }
                    Label {
                        width: parent.width - stack_1_id.width - 4
                        horizontalAlignment: Text.AlignRight
                        text: root.memoryModel.count > 1 ? root.memoryModel.get(root.memoryModel.count - 2).value : ""
                    }
                }
                Row{
                    width: parent.width
                    Label {
                        id: stack_0_id
                        horizontalAlignment: Text.AlignLeft
                        color: Theme.primaryColor
                        text: "1:"
                    }
                    Label {
                        width: parent.width - stack_0_id.width - 4
                        horizontalAlignment: Text.AlignRight
                        text: root.memoryModel.count > 0 ? root.memoryModel.get(root.memoryModel.count - 1).value : ""
                    }
                }

        }

    }

    Image {
        opacity: .30
        anchors{
            top: screen.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: Theme.paddingLarge * 4
        }
        source: "harbour-fibonacci.png"
    }
    Label {
        font.pixelSize : Theme.fontSizeSmall
        color: Theme.primaryColor
        width: parent.width - (Theme.paddingLarge * 2)
        wrapMode: Text.Wrap
        anchors{
            top: screen.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: Theme.paddingLarge
            leftMargin: Theme.paddingLarge
            rightMargin: Theme.paddingLarge
        }
      text: resultsListModel.count > 0 ? format(resultsListModel.get(0).variable, resultsListModel.get(0).formula, resultsListModel.get(0).result) : ""

    }
}




