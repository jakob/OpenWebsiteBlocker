//
//  ContentView.swift
//  OpenWebsiteBlocker
//
//  Created by Jakob Egger on 25.10.23.
//

import SwiftUI
import SafariServices

struct ContentView: View {
	@AppStorage("BlockedDomains", store: UserDefaults(suiteName: "group.OpenWebsiteBlocker")) var blockedDomains = ""

	var blockedDomainsArray: [String] {
		Array(Set(blockedDomains.components(separatedBy: .newlines))).sorted().filter({ !$0.isEmpty })
	}
	@State var newDomain: String = ""
    var body: some View {
        VStack {
			Spacer()
			Text("Blocked Websites").font(.title)
			List(blockedDomainsArray, id:\.self) {
				domain in
				HStack {
					Text(domain)
					Spacer()
					Button(action: {
						var domains = Set(blockedDomainsArray)
						domains.remove(domain)
						blockedDomains = domains.joined(separator: "\n")
					}, label: {
						Image(systemName: "trash")
					})
					.buttonStyle(.borderless)
				}
			}
			.listStyle(.bordered)
			.padding(.horizontal)
        }
		HStack {
			TextField("example.com", text: $newDomain)
			Button("Add Domain") {
				var domains = Set(blockedDomainsArray)
				domains.insert(newDomain)
				blockedDomains = domains.joined(separator: "\n")
			}
		}.padding(.horizontal)
		Divider().padding(.horizontal)
		Button("Show Safari Extension Preferences") {
			SFSafariApplication.showPreferencesForExtension(withIdentifier: extensionBundleIdentifier)
		}
		Spacer()
		Text("Changes take effect after disabling + enabling the extension in Safari").font(.caption).foregroundStyle(Color.secondary)
		Spacer()
    }
}

#Preview {
    ContentView()
}

extension AppStorage {
	
}
