import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import QtQuick.LocalStorage 2.0
import "./storage.js" as Storage


/* Ask a confirmation before updating a Meeting */
Dialog {
    id: dialogue
    title: "Confirmation"
    modal:true

    property string meetingId;

    Button {
       text: i18n.tr("Cancel")
       onClicked: PopupUtils.close(dialogue)
    }

    Button {
        text: i18n.tr("Execute")
        onClicked: {
            PopupUtils.close(dialogue)

            //console.log("Meeting to update has id: "+meetingId +" and status to save is: "+meetingStatusToSave);

            /* compose the full date because in the UI come from two different components */
            var meetingFullDate = editMeetingDateButton.text +" "+meetingTimeButton.text;

            Storage.updateMeeting(nameField.text,surnameField.text,meetingSubjectField.text,meetingPlaceField.text,meetingFullDate,meetingNote.text,editMeetingPage.id,meetingStatusToSave);

            PopupUtils.open(operationResultDialogue)

            adaptivePageLayout.removePages(editMeetingPage)
        }
    }
}

