//  © 2021 Ryan Ferrell. github.com/importRyan


import Foundation

public protocol DetailTemperatureVM: AnyObject, DetailConfiguring {

    var delegate: DetailTemperatureVMDelegate? { get set }

    var channels: [String] { get }
    var selectedChannelIndex: Int { get }
    var selectedChannelType: String { get }
    var temperature: String { get }

    var showPinDetail: Bool { get }
    var readPin: String { get }
    var enablePin: String { get }

    func start()

    // User Intents
    func selectChannel(at index: Int)
    func setReadPin(_ newValue: String)
    func setEnablePin(_ newValue: String)
    func readTemperature()
}

public protocol DetailTemperatureVMDelegate: AnyObject {
    func resetView()
    func refreshView()
}