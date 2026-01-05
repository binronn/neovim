import QtQuick 
import QtQuick.Controls

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Simple QML Demo")

    Text {
        id: helloText
        text: qsTr("Hello, QML!")
        anchors.centerIn: parent
    }

    Button {
        text: qsTr("Click Me")
        anchors.top: helloText.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            helloText.text = qsTr("Button Clicked!")
        }
    }
}

