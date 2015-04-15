import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import QtQuick.XmlListModel 2.0

Window {
    id: root
    title: qsTr("Imgs")
    property string currentIndexActualImage
    signal sourceChanged

    visible: true


    XmlListModel {
        id: xmlModel
        source: "https://api.flickr.com/services/rest/?" +
                "min_taken_date=2000-01-01+0:00:00&" +
                "extras=date_taken&" +
                "method=flickr.photos.search&" +
                "per_page=90&" +
                "sort=date-taken-desc&" +
                "text=" + searchText.text + "&" +
                "api_key=e36784df8a03fea04c22ed93318b291c&";
        query: "/rsp/photos/photo"

        XmlRole { name: "title"; query: "@title/string()" }
        XmlRole { name: "datetaken"; query: "@datetaken/string()" }
        XmlRole { name: "farm"; query: "@farm/string()" }
        XmlRole { name: "server"; query: "@server/string()" }
        XmlRole { name: "id"; query: "@id/string()" }
        XmlRole { name: "secret"; query: "@secret/string()" }
    }

    Component {
        id: flickrItemDelegate
        Image {
            id: image
            width: grid.cellWidth; height: grid.cellHeight
            //opacity: status === Image.Ready ? 1.0 : 0.0
            fillMode: Image.PreserveAspectCrop
            source: "https://farm" + farm + ".static.flickr.com/" + server +"/" + id +"_" + secret + "_s.jpg"

            Behavior on opacity { NumberAnimation { duration: 500 } }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    currentIndexActualImage = "https://farm" + farm + ".static.flickr.com/" + server +"/" + id +"_" + secret + "_b.jpg"
                    root.sourceChanged()
                }
            }

        }
    }


    ColumnLayout {
        id: flickr
        anchors { fill: parent; margins: 20 }
        spacing: 10

        TextField {
            id: searchText
            Layout.preferredHeight: 128
            Layout.fillWidth: true
            text: "Amritapuri College"
            placeholderText: "Search ..."
        }

        GridView {
            id: grid
            Layout.fillWidth: true
            Layout.fillHeight: true
            cacheBuffer: height * 3

            clip: true
            cellWidth: grid.width/4; cellHeight: cellWidth

            model: xmlModel
            delegate: flickrItemDelegate
        }
    }

    Image {
        id: actualImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source:currentIndexActualImage
        ProgressBar {
            id: imageLoadingProgress
            anchors.centerIn: parent
            width: parent.width *3/4
            height: 200
            visible: value != maximumValue && actualImage.status === Image.Loading
            value: actualImage.progress * 100
            maximumValue: 100
        }
    }
}


