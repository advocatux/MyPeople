import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0

/* replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.3 as ListItem

import "./storage.js" as Storage


/*
    Search meetings with ANY people inside a date range
*/
Column{

    id: searchMeetingColum
    anchors.fill: parent
    spacing: units.gu(3)

    /* transparent placeholder: required to place the content under the header */
    Rectangle {
        color: "transparent"
        width: parent.width
        height: units.gu(5)
    }

    /* label to show search result */
    Row{
        id: expenseFoundTitle
        x: searchMeetingColum.width/3
        Label{
            id: meetingFoundLabel
            /* using the 'count' field of the Listview instead of ListModel we have an auto-refresh wen a meeting is deleted */
            text : "<b>Found: </b>"+ allPeopleMeetingSearchResultList.count +"<b> meeting(s) (listed in chronological order)</b>"
        }
    }

    Row{
        id: searchCriteriaRow
        spacing: units.gu(1.1)
        x: units.gu(1)

        Label {
            id: expenseDateFromLabel
            anchors.verticalCenter: meetingDateFromButton.verticalCenter
            text: i18n.tr("From:")
        }

        /*
           A PopOver containing a DatePicker, necessary use a PopOver a container due to a bug on setting minimum date
           with a simple DatePicker Component
        */
        Component {
            id: popoverDateFromPickerComponent

            Popover {
                id: popoverDateFromPicker

                DatePicker {
                    id: timeFromPicker
                    mode: "Days|Months|Years"
                    minimum: {
                        var time = new Date()
                        time.setFullYear('2000')
                        return time
                    }
                    /* when Datepicker is closed, is updated the date shown in the button */
                    Component.onDestruction: {
                        meetingDateFromButton.text = Qt.formatDateTime(timeFromPicker.date, "dd MMMM yyyy")
                    }
                }
            }
        }

        /* open the popOver component with a DatePicker */
        Button {
            id: meetingDateFromButton
            width: units.gu(18)
            text: Qt.formatDateTime(new Date(), "dd MMMM yyyy")
            onClicked: {
                PopupUtils.open(popoverDateFromPickerComponent, meetingDateFromButton)
            }
        }

        Label {
            id: expenseDateToLabel
            anchors.verticalCenter: meetingDateToButton.verticalCenter
            text: i18n.tr("To:")
        }

        /* a PopOver containing a DatePicker, necessary use a PopOver a container due to a bug on setting minimum date
           with a simple DatePicker Component
        */
        Component {
            id: popoverDateToPickerComponent
            Popover {
                id: popoverDateToPicker

                DatePicker {
                    id: timeToPicker
                    mode: "Days|Months|Years"
                    minimum: {
                        var time = new Date()
                        time.setFullYear(time.getFullYear())
                        return time
                    }
                    /* when Datepicker is closed, is updated the date shown in the button */
                    Component.onDestruction: {
                        meetingDateToButton.text = Qt.formatDateTime(timeToPicker.date, "dd MMMM yyyy")
                    }
                }
            }
        }

        /* open the popOver component with a DatePicker */
        Button {
            id: meetingDateToButton
            width: units.gu(18)
            text: Qt.formatDateTime(new Date(), "dd MMMM yyyy")
            onClicked: {
                PopupUtils.open(popoverDateToPickerComponent, meetingDateToButton)
            }
        }

        Component {
             id: meetingTypeSelectorDelegate
             OptionSelectorDelegate { text: name; subText: description; }
        }

        /* The meeting status shown in the combo box */
        ListModel {
             id: meetingTypeModel
             ListElement { name: "<b>Scheduled</b>"; description: "meetings to participate"; }
             ListElement { name: "<b>Archived</b>"; description: "participated old meetings"; }
        }

        Label {
            id: meetingStatusItemSelectorLabel
            anchors.verticalCenter: meetingTypeItemSelector.Center
            text: i18n.tr("Meeting status:")
        }

        Rectangle{
            width:units.gu(30)
            height:units.gu(7)

            ListItem.ItemSelector {
                id: meetingTypeItemSelector
                delegate: meetingTypeSelectorDelegate
                model: meetingTypeModel
                containerHeight: itemHeight * 3
            }
        }

        Button {
            id: searchMeetingButton
            text: "Search"
            color: UbuntuColors.orange
            onClicked: {
                var meetingStatus = "SCHEDULED";

                if (meetingTypeModel.get(meetingTypeItemSelector.selectedIndex).name === "<b>Archived</b>") {
                   meetingStatus = "ARCHIVED";
                }

               /* search meetings and fill the ListModel to display */
               Storage.searchMeetingByTimeRange(meetingDateFromButton.text,meetingDateToButton.text,meetingStatus);

               searchAnyMeetingPage.dateFrom = meetingDateFromButton.text;
               searchAnyMeetingPage.dateTo = meetingDateToButton.text;
               searchAnyMeetingPage.meetingStatus = meetingStatus;
             }
          }
        }   
}
