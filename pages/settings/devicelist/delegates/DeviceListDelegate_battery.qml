/*
** Copyright (C) 2024 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS

DeviceListDelegate {
	id: root

	readonly property bool isParallelBms: numberOfBmses.valid

	quantityModel: !root.isParallelBms && state.valid && state.value === VenusOS.Battery_State_Pending
		   ? pendingModel
		   : defaultModel

	onClicked: {
		Global.pageManager.pushPage("/pages/settings/devicelist/battery/PageBattery.qml",
				{ bindPrefix: root.device.serviceUid })
	}

	QuantityObjectModel {
		id: pendingModel

		filterType: QuantityObjectModel.HasValue

		QuantityObject { object: CommonWords; key: "pending" }
		QuantityObject { object: voltage; unit: VenusOS.Units_Volt_DC }
		QuantityObject { object: soc; unit: VenusOS.Units_Percentage }
	}

	QuantityObjectModel {
		id: defaultModel

		filterType: QuantityObjectModel.HasValue

		QuantityObject { object: diagnosticChargeMode; key: "textValue"; unit: VenusOS.Units_None }
		QuantityObject { object: soc; unit: VenusOS.Units_Percentage }
		QuantityObject { object: voltage; unit: VenusOS.Units_Volt_DC }
		QuantityObject { object: current; unit: VenusOS.Units_Amp }
	}

	// Temporary display-only diagnostic: confirms which battery delegate is rendered.
	QtObject {
		id: diagnosticChargeMode
		readonly property string textValue: "TEST-FLOAT"
	}

	VeQuickItem {
		id: bmsChargeMode
		uid: root.device.serviceUid + "/Info/ChargeMode"
	}

	QtObject {
		id: filteredChargeMode
		readonly property string textValue: bmsChargeMode.valid && bmsChargeMode.value !== undefined && bmsChargeMode.value !== null
			? String(bmsChargeMode.value).split("|").filter(function(part) {
				return part.trim().toLowerCase() !== "linear mode"
			}).join(" | ").trim()
			: ""
	}

	VeQuickItem {
		id: numberOfBmses
		uid: root.device.serviceUid + "/NumberOfBmses"
	}

	VeQuickItem {
		id: state
		uid: root.device.serviceUid + "/State"
	}

	VeQuickItem {
		id: voltage
		uid: root.device.serviceUid + "/Dc/0/Voltage"
	}

	VeQuickItem {
		id: soc
		uid: root.device.serviceUid + "/Soc"
	}

	VeQuickItem {
		id: current
		uid: root.device.serviceUid + "/Dc/0/Current"
	}
}
