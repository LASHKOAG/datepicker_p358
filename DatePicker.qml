import QtQuick 2.0

/*
За основу взято тут
https://www.ics.com/blog/creating-qml-controls-scratch-datepicker
*/

Rectangle{
    id: recForm
    width: 600;  height: 300
    clip: true
    border.color: "green"
    border.width: 3
    radius: 10

    signal clicked(date date);  // onClicked: print('onClicked', date.toDateString())

    //изменть цвет рамки текущей даты
    property color colorBoxToday: "green"

    function set(date) { // new Date(2019, 10 - 1, 4)
        selectedDate = new Date(date)
        //Позиционирует представление таким образом, чтобы index находилось в позиции, указанной mode:
        //positionViewAtIndex(int index, PositionMode mode)
        root.positionViewAtIndex((selectedDate.getFullYear()) * 12 + selectedDate.getMonth(), ListView.Center) // index from month year
    }

    property date selectedDate: new Date()

    //масштаб стрелок "<-- -->"
    property real arrowsSizeRatio: 0.9

    ListView {
        id: root
        width: recForm.width - (recForm.border.width*2);  height: recForm.height - (recForm.border.width*2)
        anchors.top: recForm.top
        anchors.topMargin: recForm.border.width
        anchors.left: recForm.left
        anchors.leftMargin: recForm.border.width
        anchors.right: recForm.right
        anchors.rightMargin: recForm.border.width
        snapMode:    ListView.SnapOneItem
        orientation: Qt.Horizontal
        clip:        true

        model: 3000 * 12 // index == months since January of the year 0

        delegate: Item {
            property int year:      Math.floor(index / 12)
            property int month:     index % 12 // 0 January
            property int firstDay:  new Date(year, month, 1).getDay() // 0 Sunday to 6 Saturday

            width: root.width;  height: root.height

            Column {
                //название месяца и год по центру
                /*Item { // month year header
                    width: root.width;  height: root.height - grid.height

                    Text { // month year
                        anchors.centerIn: parent
                        //text: ['January', 'February', 'March', 'April', 'May', 'June',
                        //'July', 'August', 'September', 'October', 'November', 'December'][month] + ' ' + year    //original
                        text: ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
                            'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'][month] + ' ' + year
                        font {pixelSize: 0.5 * grid.cellHeight}
                    }
                }*/

                //прямоугольник на всю форму, внутри располагаются еще три прямоугольника:
                //стрелка влево, месяц год, стрелка вправо
                Rectangle{
                    id: recTop
                    width: root.width
                    height: 50
                    radius: 10
                    Rectangle {
                        id: recLeftArrow
                        width: 100
                        height: recTop.height
                        anchors.left: recTop.left
                        anchors.leftMargin: 10
                        radius: 10
                        Text {
                            id: textArrowLeft
                            anchors.centerIn: parent
                            text: "\uf177"   // arrow left <--
                            font.family: "FontAwesome"
                            font {pixelSize: arrowsSizeRatio * grid.cellHeight}
                            font.bold: true
                        }
                        MouseArea {
                            id: maLeftArrow
                            anchors.fill: parent
                            onClicked: {
                                //                            positionViewAtIndex((year) * 12 + month, ListView.Center)
                                month--
                                if(month < 0){
                                    month = 11
                                    year--
                                    if(year < 1971){
                                        year = 1970
                                        month = 0
                                    }
                                }

                            }
                        }
                    }

                    Rectangle {
                        id: recMiddleText
                        width: recTop.width - recLeftArrow.width - recRightArrow.width
                        height: recTop.height
                        anchors.left: recLeftArrow.right

                        Text { // отображение month + year
                            id: textMonthYear
                            anchors.centerIn: parent
                            text: ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
                                'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'][month] + ' ' + year
                            font.family: "FontAwesome"
                            font.bold: true
                            font {pixelSize: 0.7 * grid.cellHeight}//0.5
                        }
                    }

                    Rectangle {
                        id: recRightArrow
                        width: recLeftArrow.width
                        height: recTop.height
                        anchors.right: recTop.right
                        anchors.rightMargin: 10
                        radius: 10
                        Text {
                            id: textArrowRight
                            anchors.centerIn: parent
                            text: "\uf178"   // arrow right -->
                            font.family: "FontAwesome"
                            font {pixelSize: arrowsSizeRatio * grid.cellHeight}//0.5
                            font.bold: true
                        }
                        MouseArea {
                            id: maRightArrow
                            anchors.fill: parent
                            onClicked: {
                                month++
                                if(month > 11){
                                    month = 0;
                                    year++
                                }
                                root.positionViewAtIndex((year) * 12 + month, ListView.Center)
                            }
                        }
                    }
                }


                // 1 month calender сетка одного месяца
                Grid {
                    id: grid
                    width: root.width;  height: 0.775 * root.height
                    property real cellWidth:  (width  / columns);
                    property real cellHeight: (height / rows) + 2 // width and height of each cell in the grid.

                    columns: 7 // days
                    //                rows:    7  //original
                    rows:    8

                    Repeater {
                        model: grid.columns * grid.rows // 49 cells per month  ..56

                        delegate: Rectangle { // index is 0 to 48
                            //ToDo это место поправлено рукой
                            property int day:  index - 7 // 0 = top left below Sunday (-7 to 41)
                            //                        property int date: day - firstDay + 1 // 1-31     //original
                            property int date: day - firstDay - 5

                            width: grid.cellWidth;  height: grid.cellHeight
                            border.width: 0.3 * radius
                            border.color: new Date(year, month, date).toDateString() === selectedDate.toDateString()  &&  textDay.text  &&  day >= 0?
                                              colorBoxToday : 'transparent' // selected
                            radius: 0.02 * root.height
                            opacity: !mouseArea.pressed? 1: 0.3  //  pressed state

                            Text {
                                id: textDay
                                anchors.centerIn: parent
                                font.family: "FontAwesome"
                                font.pixelSize: day < 0 ? 0.6 * parent.height : 0.65 * parent.height//0.5
                                font.bold: day < 0
                                //                                font.bold: new Date(year, month, date).toDateString() == new Date().toDateString() // today
                                //                                color: new Date(year, month, date).toDateString() == new Date().toDateString() ? "green" : "black" // today
                                text: {
                                    //if(day < 0)['S', 'M', 'T', 'W', 'T', 'F', 'S'][index] // Su-Sa original
                                    if(day < 0){
                                        ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'][index] // Su-Sa
                                    }
                                    else if(new Date(year, month, date).getMonth() === month)  date // 1-31
                                    else ''
                                }
                            }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                enabled: textDay.text  &&  day >= 0
                                onClicked: {
                                    selectedDate = new Date(year, month, date)
                                    recForm.clicked(selectedDate)
                                }
                            }
                        }
                    }
                }
            }
        }

        // Component.onCompleted: set(new Date()) // today (otherwise Jan 0000)
    }

}
