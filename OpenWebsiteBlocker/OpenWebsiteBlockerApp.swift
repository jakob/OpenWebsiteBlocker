//
//  OpenWebsiteBlockerApp.swift
//  OpenWebsiteBlocker
//
//  Created by Jakob Egger on 25.10.23.
//

import SwiftUI
import SafariServices

let extensionBundleIdentifier = "at.eggerapps.OpenWebsiteBlocker.Extension"

@main
struct OpenWebsiteBlockerApp: App {
	
	var body: some Scene {
		MenuBarExtra(content: {
			ContentView()
		}, label: {
			Image(systemName: "globe")
		}).menuBarExtraStyle(.window)
    }
	
	init() {
		updateExtensionState()
	}
}

func updateExtensionState() {
	SFSafariExtensionManager.getStateOfSafariExtension(withIdentifier: extensionBundleIdentifier) { (state, error) in
		guard let state = state, error == nil else {
			print("Checking extension state failed: \(error?.localizedDescription)")
			// Insert code to inform the user that something went wrong.
			return
		}
		print("Extension enabled: \(state.isEnabled)")
	}

}

