import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQuick 2.12

//import "fs.js" as FileIO

Window {
    function readData() {
        var dirTree = {type: "d", name: "root", path: "/", fName: null, children: []};
        var xhr = new XMLHttpRequest;
        xhr.open("GET", "https://raw.githubusercontent.com/linuxkettle/AppShop/apps/ls");
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE) {
                var response = xhr.responseText;
                console.log(response)
                // use file contents as required
            }
        };
        xhr.send();
    }
    id: win
    x: 50
    y: 50
    width: 1000
    height: 550
    visible: true
    title: qsTr("App Shop")
    onWindowTitleChanged: readData() // Seems to be the only way to run something on startup, am I missing something?
    AbstractButton {
        id: f_Browse
        x: win.width / 2 - 180//1
        y: win.height - height
        width: 180
        height: 24
        padding: 0
        onClicked: {home.visible = true; f_Browse.background.color = "#aaaaaa"; f_Updates.background.color = "#eeeeee"}
        background: Rectangle {
            color: "#aaaaaa"
            border.color: "#888888"
            radius: 2
        }
        Label {
            padding: 0
            x: 0
            y: 0
            width: 180
            height: 24
            font.bold: true
            text: qsTr("Browse Apps")
            horizontalAlignment: "AlignHCenter"
            verticalAlignment: "AlignVCenter"
        }
    }
    AbstractButton {
        id: f_Updates
        x: win.width / 2// + 1
        y: win.height - height
        width: 180
        height: 24
        padding: 0
        onClicked: {home.visible = false; f_Browse.background.color = "#eeeeee"; f_Updates.background.color = "#aaaaaa"}
        background: Rectangle {
            color: "#eeeeee"
            border.color: "#888888"
            radius: 2
        }
        Label {
            padding: 0
            x: 0
            y: 0
            width: 180
            height: 24
            font.bold: true
            text: qsTr("Updates")
            horizontalAlignment: "AlignHCenter"
            verticalAlignment: "AlignVCenter"
        }
    }
    TextField {
        padding: 0
        id: search
        x: 0
        y: 0
        width: win.width
        height: 22
        placeholderText: qsTr("Search apps")
    }
    Frame {
        id: home
        x: 1
        y: 24
        width: win.width - 2
        height: win.height - search.height - f_Browse.height - 4
        padding: 0
        AbstractButton {
            onClicked: function() {
                console.log("Ad clicked")
            }
            padding: 0
            id: featuredApp
            x: 2
            y: 2
            width: home.width - 4
            height: 250
            background: Rectangle {
                gradient: Gradient {
                    /* Colourful! *
                    GradientStop { position: 0.0; color: "red" }
                    GradientStop { position: 0.33; color: "blue" }
                    GradientStop { position: 0.5; color: "green" }
                    GradientStop { position: 0.66; color: "yellow" }
                    GradientStop { position: 0.75; color: "orange" }
                    GradientStop { position: 1.0; color: "red" }/* */
                    GradientStop { position: 0; color: "white" }
                    GradientStop { position: 1; color: "#00a0ff" }/* */
                    orientation: Gradient.Horizontal
                }
            }
            Text {
                x: 130
                width: featuredApp.width - 131
                y: 2
                height: 50
                font.pointSize: 24
                font.bold: true
                //color: "#eee"
                id: appName
                text: qsTr("App Shop")
            }
            Text {
                id: description
                x: 130
                width: featuredApp.width - 131
                y: 50
                height: featuredApp.height - 50
                font.pointSize: 14
                text: "<div style='overflow: auto;'><p>\
An easy way to browse from a rapidly-growing collection of apps that you can d\
ownload and install with one click, and update your apps and the system.</p></\
div>"
                wrapMode: Text.WordWrap
                //color: "#eee"
            }
            Image {
                x: 0
                y: featuredApp.height / 2 - 64
                width: 128
                height: 128
                source: "file:///usr/local/share/icons/elementary-xfce/apps/12\
8/gnome-app-install.png"
            }
        }
        // don't uncomment the line below
        //padding: 0 // IMPORTANT, DO NOT COMMENT OUT
        Text {
            x: 2
            y: 252
            width: home.width - 4
            height: 20
            text: "Or browse from these categories:"
            font.pointSize: 12
            font.bold: true
            verticalAlignment: Text.AlignVCenter
        }
        Frame {
            x: 2
            y: 274
            width: home.width - 4
            height: home.height - 276
        }
    }
}
