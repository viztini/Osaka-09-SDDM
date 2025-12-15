import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtMultimedia
import Qt5Compat.GraphicalEffects
import "Components"

Item {
    id: root
    width: Screen.width
    height: Screen.height

    FontLoader {
        id: segoeui
        source: Qt.resolvedUrl("fonts/segoeui.ttf")
    }

    FontLoader {
        id: segoeuil
        source: Qt.resolvedUrl("fonts/segoeuil.ttf")
    }

    Rectangle {
        id: background
        anchors.fill: parent
        width: parent.width
        height: parent.height

        MediaPlayer {
            id: startupSound
            autoPlay: true
            source: Qt.resolvedUrl("Assets/Startup-Sound.wav")
            audioOutput: AudioOutput {}
        }

        Image {
            anchors.fill: parent
            width: parent.width
            height: parent.height
            source: config.background

            Rectangle {
                width: parent.width
                height: parent.height
                color: "transparent"
            }
        }
    }

    Rectangle {
        id: startupPanel
        color: "transparent"
        anchors.fill: parent

        visible: listView2.count > 1 ? true : false
        enabled: listView2.count > 1 ? true : false

        Component {
            id: userDelegate2

            UserList {
                id: userList
                name: (model.realName === "") ? model.name : model.realName
                icon: "/var/lib/AccountsService/icons/" + model.name

                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        listView2.currentIndex = index
                        listView2.focus = true
                        listView.currentIndex = index
                        listView.focus = true
                        centerPanel.visible = true
                        centerPanel.enabled = true
                        startupPanel.visible = false
                        startupPanel.enabled = false
                    }
                }
            }
        }

        Rectangle {
            //width: user 60 + spacing 120 + user 60 + spacing 120 + user 60
            width: 180 * listView2.count
            height: 125
            color: "transparent"
            clip: true

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

            Item {
                id: usersContainer2
                width: parent.width
                height: parent.height

                Button {
                    id: prevUser2
                    visible: false
                    enabled: false
                    width: 60

                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                    }
                }

                ListView {
                    id: listView2
                    height: parent.height
                    focus: true
                    model: userModel
                    currentIndex: userModel.lastIndex
                    delegate: userDelegate2
                    orientation: ListView.Horizontal
                    interactive: false
                    spacing: 120

                    anchors {
                        left: prevUser2.right
                        right: nextUser2.left
                    }
                }

                Button {
                    id: nextUser2
                    visible: true
                    width: 0
                    enabled: false

                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                    }
                }
            }
        }
    }

    Item {
        id: centerPanel
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: root.width / 1.75
        visible: listView2.count > 1 ? false : true
        enabled: listView2.count > 1 ? false : true
        z: 2

        Item {
            Component {
                id: userDelegate                

                FocusScope {
                    anchors.centerIn: parent
                    name: (model.realName === "") ? model.name : model.realName
                    icon: "/var/lib/AccountsService/icons/" + model.name

                    property alias icon: icon.source

                    property alias name: name.text

                    property alias password: passwordField.text

                    property int session: sessionPanel.session

                    width: 296
                    height: 500

                    Connections {
                      target: sddm

                        function onLoginFailed() {
                            truePass.visible = false

                            falsePass.visible = true
                            falsePass.focus = true
                        }

                        function onLoginSucceeded() {}
                    }

                    Rectangle {
                        width: Screen.width
                        height: Screen.height
                        color: "transparent"

                        Image {
                            anchors.fill: parent
                            width: parent.width
                            height: parent.height
                            source: config.background
                        }

                        x: {
                            if(1680 === Screen.width)
                                -Screen.width / 2 + 28
                            else if(1600 === Screen.width)
                                -Screen.width / 2 + 34
                            else
                                -Screen.width / 2 + 11
                        }

                        // bad idea? yeah but it will work for most of the people. try to come up with something better than this.

                        y: -Screen.height/2
                    }

                    Image {
                        id: containerimg

                        width: 193
                        height: 194

                        z: 5

                        anchors {
                            left: parent.left
                            leftMargin: -75
                            top: parent.top
                            topMargin: -187
                        }

                        source: "Assets/userframe.png"
                    }

                    Image {
                        id: icon
                        width: 128
                        height: 128
                        smooth: true
                        visible: false

                        onStatusChanged: {
                            if (icon.status == Image.Error)
                                icon.source = "Assets/user1.png"
                            else
                                "/var/lib/AccountsService/icons/" + name
                        }

                        x: -(icon.width / 2) + 22
                        y: -(icon.width * 2) + (icon.width * 0.8)
                        z: 4
                    }

                    OpacityMask {
                        id: opacitymask
                        visible: true
                        anchors.fill: icon
                        source: icon
                        maskSource: mask
                    }

                    Item {
                        id: mask
                        width: icon.width
                        height: icon.height
                        layer.enabled: true
                        visible: false

                        Rectangle {
                            width: icon.width
                            height: icon.height
                            color: "black"
                        }
                    }

                    Text {
                        id: name
                        color: "white"
                        font.pointSize: 20
                        font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
                        renderType: Text.NativeRendering
                        font.kerning: false

                        anchors {
                            horizontalCenter: icon.horizontalCenter
                            top: icon.bottom
                            topMargin: 32
                        }

                        layer.enabled: true
                        layer.effect: DropShadow {
                            verticalOffset: 1
                            horizontalOffset: 1
                            color: "#99000000"
                            radius: 2
                            samples: 2
                        }
                    }

                    PasswordField {
                        id: passwordField
                        x: -90

                        anchors {
                            topMargin: 8
                            top: name.bottom
                        }

                        Keys.onReturnPressed: {
                            truePass.visible = true

                            rightPanel.visible = false
                            leftPanel.visible = false

                            passwordField.visible = false
                            passwordField.enabled = false

                            opacitymask.visible = false
                            name.visible = false

                            containerimg.visible = false

                            switchUser.visible = false
                            switchUser.enabled = false

                            capsOn.z = -1

                            sddm.login(model.name, password, session)
                        }

                        Keys.onEnterPressed: {
                            truePass.visible = true

                            rightPanel.visible = false
                            leftPanel.visible = false

                            passwordField.visible = false
                            passwordField.enabled = false

                            opacitymask.visible = false
                            name.visible = false

                            containerimg.visible = false

                            switchUser.visible = false
                            switchUser.enabled = false

                            capsOn.z = -1

                            sddm.login(model.name, password, session)
                        }

                        LoginButton {
                            id: loginButton
                            visible: true

                            x: passwordField.width + 8
                            y: -4

                            onClicked: {
                                truePass.visible = true

                                rightPanel.visible = false
                                leftPanel.visible = false

                                passwordField.visible = false
                                passwordField.enabled = false

                                opacitymask.visible = false
                                name.visible = false

                                containerimg.visible = false

                                switchUser.visible = false
                                switchUser.enabled = false

                                capsOn.z = -1

                                sddm.login(model.name, password, session)
                            }
                        }
                    }

                    FalsePass {
                        id: falsePass
                        visible: false

                        anchors {
                            top: icon.bottom
                            topMargin: 50
                        }
                    }

                    TruePass {
                        id: truePass
                        visible: false

                        anchors {
                            left: parent.left
                            leftMargin: 25
                            topMargin: -150
                            top: name.bottom
                        }
                    }

                    CapsOn {
                        id: capsOn
                        visible: false
                        z: 2

                        state: keyboard.capsLock ? "on" : "off"

                        states: [
                            State {
                                name: "on"
                                PropertyChanges {
                                    target: capsOn
                                    visible: true
                                }
                            },

                            State {
                                name: "off"
                                PropertyChanges {
                                    target: capsOn
                                    visible: false
                                    z: -1
                                }
                            }
                        ]

                        anchors {
                            horizontalCenter: icon.horizontalCenter
                            topMargin: 5
                            top: passwordField.bottom
                        }
                    }
                }

            }

            Button {
                id: prevUser
                anchors.left: parent.left
                enabled: false
                visible: false
            }

            ListView {
                id: listView
                focus: listView.count > 1 ? false : true
                model: userModel
                delegate: userDelegate
                currentIndex: userModel.lastIndex
                interactive: false

                anchors {
                    left: prevUser.right
                    right: nextUser.left
                }
            }

            Button {
                id: nextUser
                anchors.right: parent.right
                enabled: false
                visible: false
            }
        }

        Button {
            id: switchUser
            width: 108
            height: 27
            hoverEnabled: true

            visible: listView2.count > 1 ? true : false
            enabled: listView2.count > 1 ? true : false

            onClicked: {
                centerPanel.visible = false
                centerPanel.enabled = false

                startupPanel.visible = true
                startupPanel.enabled = true
            }

            anchors {
                left: parent.left
                leftMargin: -175
                top: parent.bottom
                topMargin: 150
            }

            Text {
                text: "Switch user"
                font.pointSize: 11.5
                font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
                renderType: Text.NativeRendering
                color: "white"

                anchors.centerIn: parent
            }

            background: Rectangle {
                id: switchUserbg
                color: "transparent"

                Image {
                    id: switchImg

                    source: {
                        if (switchUser.pressed) return "Assets/switch-user-button-active.png"
                        if (switchUser.hovered && switchUser.focus) return "Assets/switch-user-button-hover-focus.png"
                        if (switchUser.hovered && !switchUser.focus) return "Assets/switch-user-button-hover.png"
                        if (!switchUser.hovered && switchUser.focus) return "Assets/switch-user-button-focus.png"
                        return "Assets/switch-user-button.png"
                    }
                }
            }
        }
    }

    Image {
        source: config.branding
        z: 2

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 25
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Item {
        id: rightPanel
        z: 2

        anchors {
            bottom: parent.bottom
            right: parent.right
            rightMargin: 92
            bottomMargin: 62
        }

        PowerPanel {
            id: powerPanel
        }
    }

    Item {
        id: leftPanel
        z: 2

        anchors {
            bottom: parent.bottom
            left: parent.left
            leftMargin: 34
            bottomMargin: 62
        }

        SessionPanel {
            id: sessionPanel
        }
    }
}
