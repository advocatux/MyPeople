import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import QtQuick.LocalStorage 2.0
import "./storage.js" as Storage


/* Ask a confirmation at delete People operation */
Dialog {
    id: dialogue
    title: "Confirmation"
    modal:true
    text:"" /* value passed as param by the caller */

    Button {
       text: i18n.tr("Cancel")
       onClicked: PopupUtils.close(dialogue)
    }

    Button {
        text: i18n.tr("Execute")
        onClicked: {
            PopupUtils.close(dialogue)
            Storage.deletePeopleById(personDetailsPage.id);

            Storage.deleteAllMeetingPeople(personDetailsPage.personName, personDetailsPage.personSurname);
            Storage.getTodayMeetings();
            Storage.getTodayBirthDays();

            PopupUtils.open(operationResultDialogue)
            Storage.loadAllPeople();

            adaptivePageLayout.removePages(personDetailsPage)
        }
    }
}


