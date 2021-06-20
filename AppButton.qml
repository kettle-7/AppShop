import QtQuick.Controls 2.0
import QtQuick 2.0

AbstractButton {
    width: 68
    height: 83

    onClicked: {
        this.clicky()
    }
    property var clicky: {
        console.warn("Buttons should really call a function when they are clicked.")
    }
    property Image btnIcon: Image {
        x: 2
        y: 2
        width: 64
        height: 64
        id: appIcon
        source: "https://www.google.com/favicon.ico" // Random picture from the internet
    }
    property Text name: Text {
        id: appName
        x: 2
        y: 66
        width: 64
        height: 20
    }
}
