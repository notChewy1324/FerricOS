/* FerricOS install slideshow — Quiet Ferric.
   Flat fields, 1px seams, instrument-panel labels. No blur, no glow. */
import QtQuick 2.0;
import calamares.slideshow 1.0;

Presentation {
    id: presentation

    property int seam: 1
    property string bg: "#0C0B0A"
    property string surface: "#11100E"
    property string seamCol: "#2E2A26"
    property string text: "#C9BFB2"
    property string muted: "#544C44"
    property string accent: "#D85A30"
    property string cream: "#E8DCC8"

    Timer {
        interval: 12000
        running: presentation.activatedInCalamares
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }

    function onActivate() {}
    function onLeave() {}

    Slide {
        Rectangle {
            anchors.fill: parent
            color: presentation.bg
            Rectangle { width: parent.width; height: presentation.seam; color: presentation.seamCol; y: parent.height * 0.72 }
            Text {
                x: parent.width * 0.1; y: parent.height * 0.30
                color: presentation.muted
                font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14
                text: "INSTALL // 01"
            }
            Text {
                x: parent.width * 0.1; y: parent.height * 0.38
                width: parent.width * 0.8; wrapMode: Text.WordWrap
                color: presentation.cream
                font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 26
                text: "Magnetic media, modern metal."
            }
            Text {
                x: parent.width * 0.1; y: parent.height * 0.50
                width: parent.width * 0.8; wrapMode: Text.WordWrap
                color: presentation.text
                font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 16
                text: "FerricOS is rolling-release Arch underneath — pacman, the AUR ecosystem, and monthly ISO refreshes."
            }
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: presentation.bg
            Rectangle { width: parent.width; height: presentation.seam; color: presentation.seamCol; y: parent.height * 0.72 }
            Rectangle { width: 8; height: 8; color: presentation.accent; x: parent.width * 0.618 - 4; y: parent.height * 0.72 - 4 }
            Text {
                x: parent.width * 0.1; y: parent.height * 0.30
                color: presentation.muted
                font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14
                text: "INSTALL // 02"
            }
            Text {
                x: parent.width * 0.1; y: parent.height * 0.38
                width: parent.width * 0.8; wrapMode: Text.WordWrap
                color: presentation.cream
                font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 26
                text: "One quiet desktop."
            }
            Text {
                x: parent.width * 0.1; y: parent.height * 0.50
                width: parent.width * 0.8; wrapMode: Text.WordWrap
                color: presentation.text
                font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 16
                text: "Hyprland, waybar, kitty, fuzzel, mako — tuned to the Quiet Ferric palette. 1px seams. No glow. Boot to desktop, one continuous instrument."
            }
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: presentation.bg
            Rectangle { width: parent.width; height: presentation.seam; color: presentation.seamCol; y: parent.height * 0.72 }
            Text {
                x: parent.width * 0.1; y: parent.height * 0.30
                color: presentation.muted
                font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14
                text: "INSTALL // 03"
            }
            Text {
                x: parent.width * 0.1; y: parent.height * 0.38
                width: parent.width * 0.8; wrapMode: Text.WordWrap
                color: presentation.cream
                font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 26
                text: "Yours after reboot."
            }
            Text {
                x: parent.width * 0.1; y: parent.height * 0.50
                width: parent.width * 0.8; wrapMode: Text.WordWrap
                color: presentation.text
                font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 16
                text: "Updates flow from Arch plus the [ferric] repo. Developed by Cam Garrison.  //  signal acquired — tape head engaged."
            }
        }
    }
}
