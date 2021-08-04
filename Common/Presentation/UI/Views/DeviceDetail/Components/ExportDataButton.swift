//  Created by Ryan Ferrell on 7/31/21.
//  Copyright © 2021 MbientLab. All rights reserved.
//

import SwiftUI

struct ExportDataButton: View {

    var label: String = "Export"
    var isEnabled: Bool
    var action: () -> Void

    var body: some View {
        Button { action() } label: {
            Label(label, systemImage: SFSymbol.send.rawValue)
                .fixedSize(horizontal: true, vertical: false)
                .lineLimit(1)
        }
        .opacity(isEnabled ? 1 : 0.5)
        .accessibilityLabel(label)
        .accessibilityAddTraits(.isButton)
        .disabled(!isEnabled)
        .allowsHitTesting(isEnabled)
    }
}
