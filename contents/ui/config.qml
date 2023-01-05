/*
 * Copyright (C) 2019 by Piotr Markiewicz p.marki@wp.pl
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation;
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>
 */
import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.2

Item {
    id: configPage

    property string cfg_iconOn: plasmoid.configuration.iconOn
    property string cfg_iconOff: plasmoid.configuration.iconOff

    
    
    ColumnLayout {
        GridLayout {
            columns: 2
            Label {
                Layout.row: 3
                Layout.column: 0
                text: i18n("Redeye active icon")
            }
            IconPicker {
                Layout.row: 3
                Layout.column: 1
                currentIcon: cfg_iconOn
                defaultIcon: "redeyes"
                    onIconChanged: cfg_iconOn = iconName
                    enabled: true
            }
            Label {
                Layout.row: 6
                Layout.column: 0
                text: i18n("Inactive icon")
            }
            IconPicker {
                Layout.row: 6
                Layout.column: 1
                currentIcon: cfg_iconOff
                defaultIcon: "view-visible"
                    onIconChanged: cfg_iconOff = iconName
                    enabled: true
            }

        }   
    }
}
