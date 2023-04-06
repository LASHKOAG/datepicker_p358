import QtQuick 2.15
//import P358 1.0
import QtQuick.Controls 2.15
///////////////////////////////////////////////////////////////////
//_window_width: и _window_height: обязательны к установлению, 1024 х 768 - значение по умолчанию
///////////////////////////////////////////////////////////////////
/*
How to usage:

    LineInputDate {
        id: _date
        anchors.top: parent.top
        anchors.topMargin: 550
        anchors.left: parent.left
        anchors.leftMargin: 50
        _window_width: _window.width
        _window_height: _window.height
    }

    LineInputDate {
        id: _date2
        y: 100
        x: 700
        _window_width: _window.width
        _window_height: _window.height
    }
*/

Item {
    id: container
    property alias text: lineDateInput.text
    property alias input: lineDateInput
    property bool validDate: true
    property date dateValue
    width: 180; height: 28

    property int _window_width: 1024
    property int _window_height: 768

    //отступ от края формы для эстетики
    property int offsetFromSide: 50

    //применяется и для рамки TextField (id: lineDateInput) и рамки datePicker одновременно
    property color colorBorder: "green"

    //для рамки текущего дня применять свойства из datePicker -> colorBoxToday
    //изменть цвет рамки текущей даты
    //datePicker.colorBoxToday = "black" in Component.onCompleted:

    //показывать DatePicker таким образом, чтобы не перекрывать LineInputDate и не выходить за рамки формы
    function set_XY_Position_DatePicker(){
        setPosition_X_DatePicker()
        setPosition_Y_DatePicker()
    }

    //решение как показывать DatePicker по оси Y:
    function setPosition_Y_DatePicker(){
        if(container.y - offsetFromSide >= datePicker.height){
            //место хватило сверху
            datePicker.anchors.bottom = container.top
        }
        else{
            //место сверху не хватило, будет в нижней части
            datePicker.anchors.top = container.bottom
        }
    }

    //решение как показывать DatePicker по оси X:
    function setPosition_X_DatePicker(){
        var distance_left = (container.x - offsetFromSide)
        var distance_right = (_window_width - container.x) - offsetFromSide

        if(distance_left >= (datePicker.width - container.width)){
            //места хватает слева
            datePicker.anchors.right = container.right
        }
        else if(distance_right >= (datePicker.width)){
            //места не хватает слева
            //но хватает справа
            datePicker.anchors.left = container.left
        }
        else{
            //места не хватило ни слева ни справа
            datePicker.anchors.horizontalCenter = container.horizontalCenter
        }
    }

    TextField {
        id: lineDateInput
        font.pixelSize: 0.5*container.height    //16
        font.bold: true
        font.family: "FontAwesome"
        width: parent.width-16
        anchors.fill: parent
        focus: false
        horizontalAlignment: TextInput.AlignHCenter
        verticalAlignment: TextInput.AlignVCenter
        //            style: Text.Raised; styleColor: "black"
        text: Qt.formatDate(new Date(), 'dd.MM.yyyy')
        //        wrapMode: Text.WordWrap //перенос строк
        readOnly: true

        background: Rectangle {
            //                    implicitWidth: 100
            //                    implicitHeight: 40
            //                    color: button.down ? "#d6d6d6" : "#f6f6f6"
            //                    border.color: "#26282a"
            border.color: colorBorder
            border.width: 3
            radius: 10
        }

        onFocusChanged: {
            if(!lineDateInput.focus){
                datePicker.visible = false
                container.z = 0
            }
        }
    }
    MouseArea {
        id: maLineDateInput
        anchors.fill: container
        onClicked: {
            setDateFromUser()
        }
    }

    DatePicker {
        id: datePicker
        visible: lineDateInput.focus
        border.color: colorBorder

        Component.onCompleted: set(new Date()) // today
        onClicked:{
            lineDateInput.text = Qt.formatDate(date, 'dd.MM.yyyy')
            //print('onClicked', Qt.formatDate(date, 'M/d/yyyy'))
            datePicker.visible = false
            lineDateInput.visible = true
            lineDateInput.focus = !lineDateInput.focus
        }
    }

    function dateValid(ADateString, AFormat)
    {
        var res = true
        //var d = Date.parse(ADateString);
        //res = !isNaN(d);
        //console.log(ADateString + "; " +res + "; " + n)
        return res
    }

    function setDateFromUser(){
        lineDateInput.focus = !lineDateInput.focus
        datePicker.visible = lineDateInput.focus
        container.z = datePicker.visible ? 100 : 0
    }

    Component.onCompleted:{
        set_XY_Position_DatePicker()
        /*
        how to change color borders:
        изменть цвет рамки текущей даты
        datePicker.colorBoxToday = "black"
        */
    }

}


