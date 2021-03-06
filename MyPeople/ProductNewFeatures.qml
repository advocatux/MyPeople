import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0


/* Display a dialog with the new features list added in the current Application version */

 Dialog {
        id: newFeaturesDialogue
        title: i18n.tr("What's new in this version")
        Row {
            spacing: units.gu(1)
            TextArea {
                width: parent.width
                height: units.gu(20)
                enabled: false
                autoSize: true
                horizontalAlignment: TextEdit.AlignHCenter
                placeholderText: "* Meeting, appointments management functions<br/> * Added telegram input field<br/> * Various bug fixes<br/> * New configuration page"
            }
        }

        Row {
            spacing: units.gu(1)
            Label {
                text: "Don't show again"
            }
            CheckBox {
                id: hideNewsListNextTime
                checked: false
                onClicked: {
                    if(hideNewsListNextTime.checked){
                        settings.isFirstUse = false
                        settings.isNewVersion = false
                    }else{
                        settings.isFirstUse = true
                        settings.isNewVersion = true
                    }
                }
            }
        }

        Row{
            spacing: units.gu(1)
            /* placeholder */
            Rectangle {
                color: "transparent"
                width: units.gu(8)
                height: units.gu(3)
            }
            Button {
                text: "Close"
                onClicked: PopupUtils.close(newFeaturesDialogue)
            }
        }
    }


