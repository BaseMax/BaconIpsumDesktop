// Copyright (C) 2022 Kambiz Asadzadeh
// SPDX-License-Identifier: LGPL-3.0-only

import QtQuick
import QtQuick.Window
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

ApplicationWindow {
    id: appRoot
    width: 800
    height: 600
    maximumWidth: 800
    maximumHeight: 600
    visible: true
    title: qsTr("Bacon Ipsum")
    color: "#ffffff"

    QtObject {
        id: appObject
        readonly property string apiUrl : "https://baconipsum.com/api/?"
        readonly property string apiKey : "";
        readonly property string method : "POST";

        property int paras : control.value;
        property string result : "";

    }

    FontSystem { id: fontSystem; }

    //! Remove extra double quote for some json outputs.
    function stringFixer(variable)
    {
        var a1 = variable.replace(/['"]+/g, '\n');

        return a1
    }

    function dataRequest(type)
    {
        var req = new XMLHttpRequest();
        req.open(appObject.method, appObject.apiUrl + "&type=meat-and-filler&paras="+appObject.paras+"&format=text");
        req.onreadystatechange = function() {
            if (req.readyState === XMLHttpRequest.DONE) {
                let result = JSON.stringify(req.responseText);
                //Data
                appObject.result = stringFixer(result)
            }
            busyIndicator.running = false;
            mainItem.implicitHeight = 270
            finalResultRow.visible = true
        }
        req.onerror = function(){
            console.log("Error!")
        }
        req.send()
    }

    Pane {
        anchors.fill: parent
        background: appRoot.background

        ColumnLayout {
            width: parent.width
            Layout.fillWidth: true
            anchors.centerIn: parent

            spacing: 16

            Text {
                font.family: fontSystem.getContentFontBold.name
                font.pixelSize: fontSystem.h1
                font.bold: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                text: qsTr("The Bacon Ipsum")
                color: "#171c26"
            }
            Text {
                font.family: fontSystem.getContentFont.name
                font.pixelSize: fontSystem.h5
                font.bold: false
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                text: qsTr("A REST interface for generating meaty lorem ipsum text and can be used by any application.")
                color: "#171c26"
            }
            Item {
                id: mainItem
                width: 480
                implicitHeight: 120
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Behavior on implicitHeight {
                    NumberAnimation { duration: 200; }
                }

                RectangularGlow {
                    id: effect
                    anchors.fill: mainBorder
                    glowRadius: 32
                    spread: 0.1
                    color: "#f2f1fb"
                    cornerRadius: mainBorder.radius + glowRadius
                }

                Rectangle {
                    id: mainBorder
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    anchors.fill: parent
                    color: "#ffffff"
                    border.width: 1
                    border.color: "#f2f2f2"
                    radius: 15
                }

                ColumnLayout {
                    width: parent.width
                    Layout.fillWidth: true
                    Item { height: 20; }

                    Rectangle {
                        width: parent.width / 1.2
                        height: 64
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        color: "#f1f1f1"
                        radius: 10
                        ColumnLayout {
                            anchors.fill: parent
                            Item { width: 10; }
                            RowLayout {
                                width: parent.width
                                Layout.fillWidth: true
                                spacing: 0
                                Item { width: 15; }
                                Text {
                                    font.family: fontSystem.getContentFont.name
                                    font.pixelSize: 14
                                    text: qsTr("Total of Paragraphs")
                                }

                                Item { width: 10;}

                                SpinBox {
                                    id: control
                                    value: 1
                                    editable: true

                                    contentItem: TextInput {
                                        z: 2
                                        text: control.textFromValue(control.value, control.locale)

                                        font: control.font
                                        color: "#171c26"
                                        selectionColor: "#171c26"
                                        selectedTextColor: "#ffffff"
                                        horizontalAlignment: Qt.AlignHCenter
                                        verticalAlignment: Qt.AlignVCenter

                                        readOnly: !control.editable
                                        validator: control.validator
                                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                                    }

                                    up.indicator: Rectangle {
                                        x: control.mirrored ? 0 : parent.width - width
                                        height: parent.height
                                        implicitWidth: 40
                                        implicitHeight: 40
                                        radius: 11
                                        color: control.up.pressed ? "#e4e4e4" : "#f6f6f6"
                                        border.color: "#ccc"

                                        Text {
                                            text: "+"
                                            font.pixelSize: control.font.pixelSize * 2
                                            color: "#171c26"
                                            anchors.fill: parent
                                            fontSizeMode: Text.Fit
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                    }

                                    down.indicator: Rectangle {
                                        x: control.mirrored ? parent.width - width : 0
                                        height: parent.height
                                        implicitWidth: 40
                                        implicitHeight: 40
                                        radius: 11
                                        color: control.down.pressed ? "#e4e4e4" : "#f6f6f6"
                                        border.color: "#ccc"

                                        Text {
                                            text: "-"
                                            font.pixelSize: control.font.pixelSize * 2
                                            color: "#171c26"
                                            anchors.fill: parent
                                            fontSizeMode: Text.Fit
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                    }

                                    background: Rectangle {
                                        implicitWidth: 130
                                        border.color: "#ccced0"
                                        radius: 11
                                        layer.enabled: true
                                        layer.effect: DropShadow {
                                            transparentBorder: true
                                            horizontalOffset: 0
                                            verticalOffset: 3
                                            color: "#ccced0"
                                            radius: 16
                                            samples: 32
                                            spread: 0.0
                                        }
                                    }

                                }

                                Item { width: 15; }

                                Button {
                                    id: shortButton
                                    implicitWidth: 100
                                    implicitHeight: 38
                                    font.family: fontSystem.getContentFont.name
                                    font.pixelSize: fontSystem.h5
                                    text: "Generate"

                                    layer.enabled: true
                                    layer.effect: DropShadow {
                                        transparentBorder: true
                                        horizontalOffset: 0
                                        verticalOffset: 3
                                        color: "#ccc"
                                        radius: 16
                                        samples: 32
                                        spread: 0.0

                                    }

                                    background: Rectangle {
                                        id: shortButtonBack
                                        anchors.fill: parent
                                        color: "#171c26"
                                        radius: 5
                                        z: 2
                                    }
                                    contentItem: Text {
                                        text: shortButton.text
                                        font.bold: false
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        opacity: enabled ? 1.0 : 0.3
                                        color: "#fff"
                                        anchors.fill: parent
                                        elide: Text.ElideRight
                                        scale: shortButton.down ? 0.9 : 1.0
                                        z: 3
                                        Behavior on scale {
                                            NumberAnimation {duration: 70;}
                                        }
                                    }

                                    onClicked: {
                                        busyIndicator.running = true;
                                        dataRequest();
                                    }

                                }

                                Item { Layout.fillWidth: true; }
                            }
                            Item { width: 10; }
                        }
                    }

                    ColumnLayout {
                        id: finalResultRow
                        width: parent.width
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        visible: false
                        spacing: 0
                        ScrollView {
                            id: view
                            anchors.fill: parent
                            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                            ScrollBar.vertical.policy: ScrollBar.AlwaysOn
                            anchors.margins: 5
                            background: Rectangle {
                            }
                            TextArea {
                                id: contentArea
                                font.family: fontSystem.getContentFont.name
                                font.pixelSize: appStyle.t1
                                font.bold: false
                                font.weight: Font.Normal
                                text: appObject.result
                                color: appStyle.foregroundActivated
                                wrapMode: Text.WordWrap
                                textFormat: TextEdit.AutoText
                                topPadding: -10
                                bottomPadding: 30
                                
                            }

                        }
                    }
                }
                Item {}
            }
            Text {
                font.family: fontSystem.getContentFont.name
                font.pixelSize: 10
                font.bold: false
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                onLinkActivated: Qt.openUrlExternally(link)
                text: '<html><style type="text/css"></style>Created by <strong><a href="https://github.com/KambizAsadzadeh">Kambiz Asadzadeh</a></strong>, based on C++ & Qt Quick.</html>'
                color: "#85878d"
            }
        }


        BusyIndicator {
            id: busyIndicator
            width: 48
            height: 48
            running: false
            anchors.bottom: parent.bottom
            contentItem: Item {
                implicitWidth: 16
                implicitHeight: 16

                Item {
                    id: itemProgress
                    x: parent.width / 2 - 16
                    y: parent.height / 2 - 16
                    width: 32
                    height: 32
                    opacity: busyIndicator.running ? 1 : 0

                    Behavior on opacity {
                        OpacityAnimator {
                            duration: 250
                        }
                    }

                    RotationAnimator {
                        target: itemProgress
                        running: busyIndicator.visible && busyIndicator.running
                        from: 0
                        to: 360
                        loops: Animation.Infinite
                        duration: 1250
                    }

                    Repeater {
                        id: repeater
                        model: 3

                        Rectangle {
                            x: itemProgress.width / 2 - width / 2
                            y: itemProgress.height / 2 - height / 2
                            implicitWidth: 5
                            implicitHeight: 5
                            radius: 2.5
                            color: "#171c26"
                            transform: [
                                Translate {
                                    y: -Math.min(itemProgress.width, itemProgress.height) * 0.5 + 7
                                },
                                Rotation {
                                    angle: index / repeater.count * 360
                                    origin.x: 2.5
                                    origin.y: 2.5
                                }
                            ]
                        }
                    }
                }
            }
        }

    }
}
