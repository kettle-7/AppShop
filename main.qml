import io.github.linuxkettle.AppShop 0.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.12
//import QtQuick.Layouts 1.15
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick 2.12

//import "fs.js" as FileIO

Window {
    property Curler cr: Curler {}
    function parse(response, path="https://raw.githubusercontent.com/linuxkettle/AppShop/apps") {
        /******************************************************************************************************************
        * Minimal implementation of a basic programming language I made a while ago for data storage and simple programs. *
        ******************************************************************************************************************/
        var data = {
            name: "<anonymous>",
            subtrees: [],
            apps: [],
            value: "<empty>",
            extra: [],
            fields: [],
            path: path
        }
        var lines = response.split('\n')
        var e3 = false;             // Have we encountered three equal signs, no by default.
        var e3Name = "Description"; // Most common place for e3
        var e3Value = "";           // An empty string. Useful for when you want a necklace without beads, or a chain without any links.
        for (var line in lines) {
            var ln = lines[line];
            if (e3) {
                if (ln === "===") {
                    data.fields.push([e3Name, e3Value]);
                    e3 = false;
                    e3Value = "";
                }
                else {
                    if (e3Value === "") {
                        e3Value = ln
                    }
                    else {
                        e3Value += ln + "\n"
                    }
                }
            }
            else if (!(ln === "" || ln[0] === "#")) {
                var words = [];
                var q = false
                var w = ""
                for (var cN in ln) {
                    var c = ln[cN];
                    if (c === '"') {
                        if (q) {
                            q = false;
                        }
                        else {
                            q = true;
                        }
                    }
                    else if (c === " ") {
                        if (q) {
                            w += " ";
                        }
                        else {
                            words.push(w)
                            w = "";
                        }
                    }
                    else {
                        w += c;
                    }
                }
                if (w !== "") {
                    words.push(w);
                }
                var com = words[0];
                var args = [];
                for (var i = 1; i < words.length; i++) {
                    args.push(words[i]);
                }
                var R
                switch(com) {
                    case "d":
                        R = cr.downloadFile(path + "/" + args[1] + "/ls");
                        var o = parse(R, path + "/" + args[1])
                        o.category = args[0]
                        data.subtrees.push(o);
                        break;
                    case "a":
                        R = cr.downloadFile(path + "/" + args[0] + ".meta");
                        data.apps.push(parse(R, path));
                        break;
                    default:
                        if (args.length !== 0) {
                            if (args[0] === "===") {
                                e3Name = com;
                                e3Value = "";
                                e3 = true;
                            }
                            else data.fields.push([com, args.join(" ")]);
                        }
                        break;
                }
            }
        }
        return data;
    }
    function startUp() {
        var dirTree = {};
        var R = cr.downloadFile("https://raw.githubusercontent.com/linuxkettle/AppShop/main/apps/ls");
        dirTree = parse(R, "https://raw.githubusercontent.com/linuxkettle/AppShop/main/apps");
        function printData(data, indent="") {
            console.log(indent + "Data Structure at "+data.path+":");
            indent += "| ";
            if (data.apps.length !== 0) {
                console.log(indent + "Apps:")
                for (var appN in data.apps) {
                    var app = data.apps[appN];
                    printData(app, indent + "| ")
                }
            }
            if (data.fields.length !== 0) {
                for (var fN in data.fields) {
                    var f = data.fields[fN];
                    console.log(indent + f[0].toString() + ": " + f[1].toString())
                }
            }
            if (data.subtrees.length !== 0) {
                console.log(indent + "Subfolders:")
                for (var treeN in data.subtrees) {
                    var tree = data.subtrees[treeN];
                    printData(tree, indent + "| ")
                }
            }
        }
        function getCategories(data) {
            var cats = []
            if (data.subtrees.length !== 0) {
                for (var treeN in data.subtrees) {
                    var tree = data.subtrees[treeN];
                    var subCats = getCategories(tree)
                    for (var subCatN in subCats) {
                        cats.push(subCats[subCatN])
                    }
                }
            }
            if (data.category !== undefined && data.category.indexOf("lib_") === -1) {
                cats.push({Category: data.category, Tree: data})
            }
            return cats
        }
        var cats = getCategories(dirTree)
        var catnum = cats.length
        var columns = 3
        switch (0) {
        case catnum % 3:
            columns = 3
            break
        case catnum % 4:
            columns = 4
            break
        case catnum % 2:
            columns = 2
            break
        }
        var row = 0
        var column = 0
        this.pointers = [[],[]]
        for (var catN in cats) {
            function thing () { // Make local variables local. I'm not sure if this is needed in JS but it's there anyway.
                let cat = cats[catN]
                let x = row
                let btn = categoryButton.createObject(catArea, {})
                btn.text = cat.Category//.replace(/&/g, "&&")
                btn.parent = catArea
                btn.font.pointSize = 12
                btn.visible = true
                btn.y = 2
                btn.width = Qt.binding(function() {
                    return(Math.floor(catArea.width / columns) - 5)
                })
                btn.x = Qt.binding(function() {
                    return(Math.floor(catArea.width / columns) * x) + 2
                })
                row += 1
                if (row === 3) {
                    row = 0
                }
                btn.onClicked.connect( function(){
                    showCategory(cat)
                })
            }
            thing()
        }
    }
    function showCategory(cat) {
        f_Browse.background.color = "#eeeeee"
        win.title = cat.Category + " | App Shop"
        home.visible = false
        updates.visible = false
        categoryView.visible = true
        while (appIcons.length > 0) {
            let i = appIcons.pop()
            i.destroy()
        }
        let data = cat.Tree
        let apps = data.subApps
        for (var C = 0; C < apps.length; C++) // No, QML!
        {
            let app = apps[C]
            let acorn = appIconButton.createObject(categoryView, {})
            appIcons.push(acorn)
            let name = "Untitled App"
            let version = "1.0"
            let hci = false // Variable to check if the icon has been changed from default
            for (var fN = 0; fN < app.fields.length; fN++) {
                var f = app.fields[fN]
                switch(f[0]) {
                case "Icon":
                    acorn.btnIcon.source = f[1]
                    hci = true
                }
            }
            if (!hci) acorn.btnIcon = QIcon.fromTheme("application-x-executable").pixmap(64, 64).toImage()
        }
    }
    property var appIcons: []
    property var pointers: []
    id: win
    x: 50
    y: 50
    width: 1000
    height: 550
    visible: true
    title: qsTr("App Shop")
    Component.onCompleted: startUp()
    Component {
        id: categoryButton
        RoundButton {
            radius: 5
            background: Rectangle {
                color: "#eeeeee"
                border.color: "#888888" // FIXME: The border doesn't show rounded like it should. Bug?
            }
        }
    }
    Component {
        id: appIconButton
        AppButton {}
    }

    AbstractButton {
        id: f_Browse
        x: win.width / 2 - 180//1
        y: win.height - height - 1
        width: 180
        height: 24
        padding: 0
        onClicked: {
            home.visible = true
            updates.visible = false
            f_Browse.background.color = "#aaaaaa"
            f_Updates.background.color = "#eeeeee"
            win.title = "App Shop"
        }
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
        y: win.height - height - 1
        width: 180
        height: 24
        padding: 0
        onClicked: {
            home.visible = false
            updates.visible = true
            f_Browse.background.color = "#eeeeee"
            f_Updates.background.color = "#aaaaaa"
            win.title = "Software Updates"
        }
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
        id: updates
        visible: false
        x: 1
        y: 24
        width: win.width - 2
        height: win.height - search.height - f_Browse.height - 4
        padding: 0
        Text {
            x: 1
            y: 5
            width: parent.width - 10
            height: 50
            text: "Coming Soon!"
            font.pointSize: 24
            font.bold: true
        }
        Text {
            x: 5
            y: 58
            width: parent.width - 10
            height: parent.height - 54
            text: "Sorry, this functionality is not yet in App Shop. Stay tuned!"
            font.pointSize: 11
        }
    }
    Frame {
        id: categoryView
        x: 1
        y: 24
        width: win.width - 2
        height: win.height - search.height - f_Browse.height - 4
        padding: 0
        visible: false
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
            id: catArea
            padding: 0
            x: 2
            y: 274
            width: home.width - 4
            height: home.height - 276
        }
    }
}
