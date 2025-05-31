import QtQuick
import QtLocation
import QtPositioning


Window {
    Plugin {
        id: mapPlugin
        name: "osm"
    }

    width: 640
    height: 480
    visible: true
    title: qsTr("Tesla Infotainment")

    Rectangle{
        id:bottomBar
        anchors{
            left:parent.left
            right:parent.right
            bottom:parent.bottom
        }
        color:"black"
        height: parent.height / 12

        Image{
           id: carIcon
           source: "qrc:/img/img/car (1).png"
           height: parent.height * .85
           fillMode: Image.PreserveAspectFit
           anchors{
           verticalCenter: parent.verticalCenter
           left: parent.left
           leftMargin: 20
           }
        }
    }

    Rectangle{
       id:rightScreen
       anchors{
           top:parent.top
           right:parent.right
           bottom:bottomBar.top
       }
       color : "orange"
       width:parent.width * 2/3

       Map{
           id: map
           anchors.fill: parent
           plugin: mapPlugin
           center: QtPositioning.coordinate(59.91, 10.75) // Oslo
           zoomLevel: 14
           property geoCoordinate startCentroid

           PinchHandler {
               id: pinch
               target: null
               onActiveChanged: if (active) {
                   map.startCentroid = map.toCoordinate(pinch.centroid.position, false)
               }
               onScaleChanged: (delta) => {
                   map.zoomLevel += Math.log2(delta)
                   map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
               }
               onRotationChanged: (delta) => {
                   map.bearing -= delta
                   map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
               }
               grabPermissions: PointerHandler.TakeOverForbidden
           }
           WheelHandler {
               id: wheel
               // workaround for QTBUG-87646 / QTBUG-112394 / QTBUG-112432:
               // Magic Mouse pretends to be a trackpad but doesn't work with PinchHandler
               // and we don't yet distinguish mice and trackpads on Wayland either
               acceptedDevices: Qt.platform.pluginName === "cocoa" || Qt.platform.pluginName === "wayland"
                                ? PointerDevice.Mouse | PointerDevice.TouchPad
                                : PointerDevice.Mouse
               rotationScale: 1/120
               property: "zoomLevel"
           }
           DragHandler {
               id: drag
               target: null
               onTranslationChanged: (delta) => map.pan(-delta.x, -delta.y)
           }
           Shortcut {
               enabled: map.zoomLevel < map.maximumZoomLevel
               sequence: StandardKey.ZoomIn
               onActivated: map.zoomLevel = Math.round(map.zoomLevel + 1)
           }
           Shortcut {
               enabled: map.zoomLevel > map.minimumZoomLevel
               sequence: StandardKey.ZoomOut
               onActivated: map.zoomLevel = Math.round(map.zoomLevel - 1)
           }
       }


       // Lock Icon
       Image {
           id: lockIcon
           width: parent.width / 20
           height: width
           fillMode: Image.PreserveAspectFit
           anchors {
               left: parent.left
               top: parent.top
               margins: 10
           }
           source: systemHandler.carLocked ? "qrc:/img/img/padlock.png" : "qrc:/img/img/unlock.png"

           MouseArea {
               anchors.fill: parent
               onClicked: systemHandler.carLocked = !systemHandler.carLocked
           }
       }



       // Outdoor Temp
       Text {
           id: tempText
           text: "Temp: " + systemHandler.outdoorTemp + "°F"
           anchors.verticalCenter: lockIcon.verticalCenter
           anchors.left: lockIcon.right
           anchors.leftMargin: 20
           color: "black"
           font.pixelSize: 16
       }

       // Current Time
       Text {
           id: timeText
           text: "Time: " + systemHandler.currentTime
           anchors.verticalCenter: lockIcon.verticalCenter
           anchors.left: tempText.right
           anchors.leftMargin: 20
           color: "black"
           font.pixelSize: 16
       }

       // User Name
       Text {
           id: userNameText
           text: "User: " + systemHandler.userName
           anchors.verticalCenter: lockIcon.verticalCenter
           anchors.left: timeText.right
           anchors.leftMargin: 20
           color: "black"
           font.pixelSize: 16
       }

    }

    Rectangle{
       id:leftScreen
       anchors{
           top:parent.top
           left:parent.left
           bottom:bottomBar.top
           right:rightScreen.left
       }
       color : "white"

       Image{
           id: carRender
           source:"qrc:/img/img/carRender.jpg";
           // anchors.centerIn: parent
           height:parent.height
           width:parent.width
           fillMode: Image.PreserveAspectFit
       }
    }
}
