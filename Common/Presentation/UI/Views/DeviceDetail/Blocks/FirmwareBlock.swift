//  Created by Ryan Ferrell on 7/31/21.
//  Copyright © 2021 MbientLab. All rights reserved.
//

import SwiftUI

struct FirmwareBlock: View {

    @ObservedObject var vm: FirmwareSUIVC

    var body: some View {
        VStack(spacing: .cardVSpacing) {
            LabeledItem(
                label: vm.offerUpdate ? "New Firmware" : "Status",
                content: status
            )

            if vm.offerUpdate {
                Button("Update Firmware") { vm.userRequestedUpdateFirmware() }
            }

            LabeledItem(
                label: "Revision",
                content: firmware
            )
        }
    }

    private var firmware: some View {
        Text(vm.firmwareRevision)
    }

    private var status: some View {
        HStack {
            Text(vm.firmwareUpdateStatus)
            Spacer()
            UpdateButton(didTap: vm.userRequestedCheckForFirmwareUpdates,
                         helpAccessibilityLabel: "Check Firmware Version")
        }
    }
}
