/*
  Copyright (C) 2016 Heiko Bauke
  Copyright (C) 2023 Mark Washeim

 Contact: Heiko Bauke <heiko.bauke@mail.de>
  Contact: Mark Washeim <blueprint@poetaster.de>

  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.2
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3
import harbour.fibonacci.qmlcomponents 1.0
import "../components"

Page {
    id: exprtkPage



    function format(formula, variable, result, error) {
        // return result + " " + error
        formula = formula.replace(/(\r\n|\n|\r)/gm, "");
        return formula + " =\n " + result + " "  + error
        //return variable !== "" && formula === result ? variable + " := " + result : ((variable !== "" ? variable + " := " : "") + formula + " = " + result + (error !== "" ? " (" + error + ") ": ""))
    }

    /* c++ precre variant
     static const QRegularExpression assignment_regex{R"(var\s*([[:alpha:]]\w*)\s*:=\s*([[:digit:]]*);)"};
      We shift the variable handling to javascript.
  */

    /* add to app wide list to strip our syntax */
    function getVariables() {
        variablesListModel.clear()
        // get the internal vars common to all
        // var variables = calculator.getVariables()
        // for (var i in variables)
        //   variablesListModel.append({variable: variables[i]})

        const regex = /var\s*(\w*)\s*:=\s*(\d*);/gm;
        var m
        while ((m = regex.exec(varstxt)) !== null) {
            // This is necessary to avoid infinite loops with zero-width matches
            if (m.index === regex.lastIndex) {
                regex.lastIndex++;
            }
            // The result can be accessed through the `m`-variable.
            // add our special cases
            variablesListModel.append({variable: {"variable": m[1], "value": m[2] } })
        }
        const regex2 = /(\w*)\s*:=\s*(\d*);/gm;
        while ((m = regex2.exec(varstxt)) !== null) {
            if (m.index === regex.lastIndex) {
                regex2.lastIndex++;
            }
            variablesListModel.append({variable: {"variable": m[1], "value": m[2] } })
        }
    }
    /* strip var from the result formula to present */
    function stripVariables() {
        const regex = /var\s*(\w*)\s*:=\s*(\d*);/gm;
        var m
        while ((m = regex.exec(varstxt)) !== null) {
            // This is necessary to avoid infinite loops with zero-width matches
            if (m.index === regex.lastIndex) {
                regex.lastIndex++;
            }
            // The result can be accessed through the `m`-variable.
            // add our special cases
            variablesListModel.append({variable: {"variable": m[1], "value": m[2] } })
        }
    }

    /* strip var from the result formula to present */
    function filterVariables(text) {
        const re0 = /·/g;
        const re1 = /π/g;
        const re2 = /√/g;
        const re3 = /φ/g;
        const re5 = /deg/g;
        const newtxt = text.replace(re0, "*")
        newtxt = newtxt.replace(re1, "pi")
        newtxt = newtxt.replace(re2, "sqrt")
        newtxt = newtxt.replace(re3, "phi")
        newtxt = newtxt.replace(re5, "rad2deg")
        return newtxt
    }

    SilicaListView {
        anchors.fill: parent
        id: listView
        focus: false

        VerticalScrollDecorator { flickable: listView }

        PullDownMenu {
            RemorsePopup { id: remorse_output }
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }
            MenuItem {
                text: qsTr("Operators & Functions")
                onClicked: pageStack.push(Qt.resolvedUrl("../components/ExprtkMenu.qml"))
            }
            /*MenuItem {
                text: qsTr("Scientific calculator")
                onClicked: pageStack.replace(Qt.resolvedUrl("MainPage.qml"))
            }*/

        }
        PushUpMenu {
            MenuItem {
                text: qsTr("Prototype functions")
                onClicked: pageStack.push(Qt.resolvedUrl("ExprtkPrototypes.qml"))
            }
            MenuItem {
                RemorsePopup { id: remorse_variables }
                text: qsTr("Remove all output")
                onClicked: remorse_output.execute(qsTr("Removing all output"),
                                                  function() {
                                                      resultsListModel.clear()
                                                  } )
            }
        }

        Component {
            id: headerComponent
            Item {
                id: headerComponentItem
                anchors.horizontalCenter: exprtkPage.Center
                anchors.top: parent.Top
                anchors.bottomMargin: 3 * Theme.paddingLarge
                height: pageHeader.height + formfield.height + vars.height + 3 * Theme.paddingLarge
                width: exprtkPage.width
                PageHeader {
                    id: pageHeader
                    title: qsTr("Programmable calculator")
                }
                QueryField {
                    id: vars
                    anchors.top: pageHeader.bottom
                    width: listView.width
                    text: varstxt
                    placeholderText: qsTr("Variables")
                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhPreferNumbers
                    EnterKey.enabled: text.length > 0
                    EnterKey.onClicked: {
                        varstxt = text
                        formtxt = formfield.text
                        settings.recentVars = varstxt
                        settings.lastFormula = formtxt
                        var txt = filterVariables(varstxt) + " " + filterVariables(formtxt)
                        var res = calculator.exprtk(txt)
                        res.variable = text
                        res.formula = formfield.text
                        if (res.iresults.length > 0 ) {
                            var resultn = ""
                            for (x in res.iresults) {
                                resultn +=  res.iresults[x]
                                if (x<res.iresults.length-1)
                                    resultn += ", "
                            }
                            res.result = resultn
                        }
                        resultsListModel.insert(0, res)
                        getVariables()
                    }
                }
                QueryArea {
                    id: formfield
                    anchors.top: vars.bottom
                    width: listView.width
                    height: Theme.buttonWidthSmall
                    text: formtxt
                    placeholderText: qsTr("Mathematical expression")
                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhPreferNumbers
                    EnterKey.enabled: text.length > 0
                }
                IconButton {
                    id: accept
                    width: icon.width
                    height: icon.height
                    icon.source: "image://theme/icon-m-acknowledge"
                    anchors {
                        top: formfield.bottom
                        right: parent.right
                        topMargin: Theme.paddingSmall
                        rightMargin: Theme.paddingSmall + 5
                    }
                    onClicked: {
                        vars.EnterKey.clicked(true)
                    }
                }

            }
        }

        header: headerComponent

        model: resultsListModel

        delegate: ListItem {
            width: parent.width
            contentWidth: parent.width
            contentHeight: result_text.height + Theme.paddingLarge
            menu: contextMenu
            Text {
                id: result_text
                focus: false
                x: Theme.horizontalPageMargin
                y: 0.5 * Theme.paddingLarge
                width: parent.width - 2 * Theme.horizontalPageMargin
                anchors.topMargin: Theme.paddingMedium
                anchors.bottomMargin: Theme.paddingMedium
                color: Theme.primaryColor
                wrapMode: TextEdit.Wrap
                font.pixelSize: Theme.fontSizeMedium
                horizontalAlignment: TextEdit.AlignLeft
                text: format(formula, variable, result, error)
                //text: result
            }
            Component {
                id: contextMenu
                ContextMenu {
                    MenuItem {
                        text: qsTr("Copy result")
                        onClicked: Clipboard.text = resultsListModel.get(model.index).result
                    }
                    MenuItem {
                        text: qsTr("Copy formula")
                        onClicked: Clipboard.text = resultsListModel.get(model.index).formula
                    }
                    MenuItem {
                        text: qsTr("Remove output")
                        onClicked: resultsListModel.remove(model.index)
                    }
                }
            }
        }
        IconButton {
            id: help
            width: icon.width
            height: icon.height
            icon.source: "image://theme/icon-m-question"
            anchors {
              bottom: parent.bottom
              right: parent.right
              bottomMargin: Theme.paddingMedium
              rightMargin: Theme.paddingMedium
            }
            onClicked:  pageStack.push(Qt.resolvedUrl("../components/ExprtkMenu.qml"))
        }

    }

    onStatusChanged: {
        if (status === PageStatus.Active) {
            navigationState.name = "exprtk"
            getVariables()
            pageStack.pushAttached(Qt.resolvedUrl("Variables.qml"))
        }
    }

    Component.onDestruction: {
        //console.log("MainPage off")
    }
    Component.onCompleted: {
        navigationState.name = "exprtk"

        console.log(stat.engineLoaded)
    }

}
