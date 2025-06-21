import QtQuick
import QtLocation
import QtPositioning


Window {
           Plugin {
                      id: mapPlugin
                      name: "osm"
           }
           Shortcut {
               sequence: StandardKey.Cancel  // Escape key
               onActivated: Qt.quit()
           }
           width: 640
           height: 480
           visible: true
           visibility: Window.Fullscreen
           flags: Qt.FramelessWindowHint | Qt.Dialog | Qt.WindowStaysOnTopHint // Optional: Dialog to make it always on top
           color: "black" // Or any other color

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

                      Rectangle{
                                 id:decrementButtom
                                 anchors{
                                            left:carIcon.right
                                            top: parent.top
                                            bottom: parent.bottom
                                            leftMargin: 50
                                 }
                                 height: parent.height
                                 width: height / 2
                                 color: "black"
                                 Text{
                                            id:decrementText
                                            anchors.centerIn: parent
                                            text: "<"
                                            color:"#f0f0f0"
                                            font.pixelSize: 20
                                 }
                                 MouseArea {
                                         anchors.fill: parent
                                         onClicked: {
                                             driverHVAC.incrementTargetTemperature(-1)
                                         }
                                     }
                      }

                      Text{
                                 id:targetTemperatureText
                                 anchors{
                                        left:decrementButtom.right
                                        leftMargin: 10
                                        verticalCenter: parent.verticalCenter
                                 }
                                 color:"white"
                                 font.pixelSize: 20
                                 text: driverHVAC.targetTemperature.toString()

                      }

                      Rectangle{
                                 id:incrementButtom
                                 anchors{
                                            left:targetTemperatureText.right
                                            top: parent.top
                                            bottom: parent.bottom
                                            leftMargin: 10
                                 }
                                 height: parent.height
                                 width: height / 2
                                 color: "black"
                                 Text{
                                            id:incrementText
                                            anchors.centerIn: parent
                                            text: ">"
                                            color:"#f0f0f0"
                                            font.pixelSize: 20
                                 }
                                 MouseArea {
                                         anchors.fill: parent
                                         onClicked: {
                                             driverHVAC.incrementTargetTemperature(+1)
                                         }
                                     }
                      }

                      Rectangle{
                                 id:incrementAudioButtom
                                 anchors{
                                            right:parent.right
                                            top: parent.top
                                            bottom: parent.bottom
                                            rightMargin: 50
                                 }
                                 height: parent.height
                                 width: height / 2
                                 color: "black"
                                 Text{
                                            id:incrementAudioText
                                            anchors.centerIn: parent
                                            text: ">"
                                            color:"#f0f0f0"
                                            font.pixelSize: 20
                                 }
                                 MouseArea {
                                         anchors.fill: parent
                                         onClicked: {
                                             driverHVAC.incrementTargetTemperature(+1)
                                         }
                                     }
                      }

                      Image{
                                 id:audioIcon
                                 source:"qrc:/img/img/speaker-filled-audio-tool (2).png"
                                 anchors{
                                        right: incrementAudioButtom.left
                                        rightMargin: 10
                                        verticalCenter: parent.verticalCenter
                                 }
                                 height:parent.height * .65
                                 width: parent.height / 2
                      }

                      Rectangle{
                                 id:decrementAudioButtom
                                 anchors{
                                            right:audioIcon.left
                                            top: parent.top
                                            bottom: parent.bottom
                                            rightMargin: 10
                                 }
                                 height: parent.height
                                 width: height / 2
                                 color: "black"
                                 Text{
                                            id:decrementAudioText
                                            anchors.centerIn: parent
                                            text: "<"
                                            color:"#f0f0f0"
                                            font.pixelSize: 20
                                 }
                                 MouseArea {
                                         anchors.fill: parent
                                         onClicked: {
                                             driverHVAC.incrementTargetTemperature(-1)
                                         }
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
                                 text: systemHandler.outdoorTemp + "°F"
                                 anchors.verticalCenter: lockIcon.verticalCenter
                                 anchors.left: lockIcon.right
                                 anchors.leftMargin: 20
                                 color: "black"
                                 font.pixelSize: 16
                      }

                      // Current Time
                      Text {
                                 id: timeText
                                 text: systemHandler.currentTime
                                 anchors.verticalCenter: lockIcon.verticalCenter
                                 anchors.left: tempText.right
                                 anchors.leftMargin: 20
                                 color: "black"
                                 font.pixelSize: 16
                      }

                      // User Name
                      Text {
                                 id: userNameText
                                 text: systemHandler.userName
                                 anchors.verticalCenter: lockIcon.verticalCenter
                                 anchors.left: timeText.right
                                 anchors.leftMargin: 20
                                 color: "black"
                                 font.pixelSize: 16
                      }

                      Rectangle{
                                 id:navSearchBox
                                 width: parent.width * .45
                                 height: parent.width * 1/12
                                 anchors{
                                            left:lockIcon.left
                                            top:lockIcon.bottom
                                            topMargin: 10
                                 }
                                 radius: 3
                                 color:"white"

                                 Image{
                                            id: searchIcon
                                            source: "qrc:/img/img/search.png"
                                            anchors{
                                                       left:parent.left
                                                       leftMargin: 20
                                                       verticalCenter: parent.verticalCenter
                                            }

                                            height:parent.height * .45
                                            fillMode: Image.PreserveAspectFit
                                 }

                                 Text{
                                            id:serachNavigationPlaceholderText
                                            visible:inpuNavigationPlaceholderText.text === ""
                                            color:"Black"
                                            text:"Navigate"
                                            anchors{
                                                       left: searchIcon.right
                                                       leftMargin: 20
                                                       verticalCenter: parent.verticalCenter

                                            }


                                 }

                                 TextInput{
                                            id: inpuNavigationPlaceholderText
                                            clip: true
                                            anchors{
                                                       top:parent.top
                                                       right:parent.right
                                                       bottom:parent.bottom
                                                       left: searchIcon.right
                                                       leftMargin: 20


                                            }
                                            verticalAlignment:Text.AlignVCenter
                                 }
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
