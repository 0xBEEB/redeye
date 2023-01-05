/*
 * Copyright (C) 2023 by Briar Schreiber <briarrose@mailbox.org>
 * Copyright (C) 2019 by Piotr Markiewicz <p.marki@wp.pl>
 * Copyright (C) 2019 by Roland Pallai <pallair78@magex.hu>
 * 
 * Credits to Norbert Eicker <norbert.eicker@gmx.de>
 * https://github.com/neicker/on-off-switch
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
import QtQuick.Controls 1.4
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: root

    property bool inhibitated: false
    property bool has_inhibitions: false

    //
    property int cookie: -1
    
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation


    property QtObject pmSource: PlasmaCore.DataSource {
      engine: "powermanagement"
      connectedSources: ["PowerDevil"]

      onSourceAdded: {
        disconnectSource(source);
        connectSource(source);
      }

      onSourceRemoved: {
        disconnectSource(source);
      }

      onDataChanged: {
        if (typeof pmSource.data["Inhibitions"] !== "undefined") {
          var has_inhibitions = false;
          console.error("current inhibitions:");
          for(var key in pmSource.data["Inhibitions"]) {
              console.error(key);
              has_inhibitions = true;
          }
          root.has_inhibitions = has_inhibitions;
        }
        if (!root.inhibitated) {  // aka. monitoring mode
          root.mainItem.icon.source = plasmoid.configuration.iconOff
        }
      }
    }

    Plasmoid.compactRepresentation: RowLayout {
        id: mainItem
        spacing: 0
        Item {
            Layout.fillWidth: true
        }
        PlasmaCore.IconItem {
            id: icon
            Layout.fillHeight: true
            Layout.fillWidth: true
            source: root.inhibitated ? plasmoid.configuration.iconOn : plasmoid.configuration.iconOff
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    if (root.inhibitated) {
                        var service = root.pmSource.serviceForSource("PowerDevil")
                        var op = service.operationDescription("stopSuppressingScreenPowerManagement");
                        op.cookie = root.cookie;
                        var job = service.startOperationCall(op);
                        job.finished.connect(function(job) {
                            console.error("inhibitation disabled");
                            root.inhibitated = false;
                            root.cookie = -1;
                            root.mainItem.icon.source = plasmoid.configuration.iconOff
                        });
                    } else {
                        var service = root.pmSource.serviceForSource("PowerDevil")
                        var op = service.operationDescription("beginSuppressingScreenPowerManagement");
                        op.reason = "Redeye is activated";
                        var job = service.startOperationCall(op);
                        job.finished.connect(function(job) {
                            console.error("inhibitation enabled");
                            root.inhibitated = true;
                            root.cookie = job.result;
                            // updateIcon();
                            root.mainItem.icon.source = plasmoid.configuration.iconOn
                        });
                    }
                }
            }
        }
    }


}
