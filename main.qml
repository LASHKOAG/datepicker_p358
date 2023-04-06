import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id:_window
    width: 1024
    height: 768
    visible: true
    title: qsTr("DatePicker")

    LineInputDate {
        id: _date3
        y: 150
        x: 50

        _window_width: _window.width
        _window_height: _window.height
    }

    LineInputDate {
        id: _date
//        anchors.top: parent.top
//        anchors.topMargin: 550
//        anchors.left: parent.left
//        anchors.leftMargin: 50
        y: 350
        x: 550
        _window_width: _window.width
        _window_height: _window.height
//        text: Qt.formatDate(new Date(), 'dd.MM.yyyy')
        text: "12" //test
    }

    LineInputDate {
        id: _date2
//        y: 100
//        x: 700
        y: 550
        x: 450

        _window_width: _window.width
        _window_height: _window.height
    }



//    ComboBox{
//        id: cb
//        width: 300
//        height: 150
//        x: 600
//        y:150
//        model: ["First", "Second", "Third"]
//    }

//    ComboBox{
//        id: cb2
//        width: 300
//        height: 150
//        x: 250
//        y:150
//        model: ["1", "2", "3"]
//    }

}
