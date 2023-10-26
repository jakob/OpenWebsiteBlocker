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
			Text("OpenWebsiteBlocker").font(.title).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading).padding(.horizontal)
			Spacer()
			Text("Blocked Sites:").frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading).padding(.horizontal)
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
#if os(macOS)
			.listStyle(.bordered)
			.padding(.horizontal)
#endif
        }
		HStack {
			TextField("example.com", text: $newDomain)
			Button("Add Domain") {
				var domains = Set(blockedDomainsArray)
				domains.insert(newDomain)
				blockedDomains = domains.joined(separator: "\n")
			}.disabled(newDomain.isEmpty)
		}.padding(.horizontal)
		Divider().padding(.horizontal)
		Text("The selected websites will be blocked by Safari when the OpenWebsiteBlocker extension is enabled. Changes take effect after disabling + enabling the extension.").font(.caption).foregroundStyle(Color.secondary).multilineTextAlignment(.leading).padding(.horizontal)
#if os(macOS)
		HStack {
			Spacer()
			Button("Show Safari Extension Preferences") {
				SFSafariApplication.showPreferencesForExtension(withIdentifier: extensionBundleIdentifier)
			}.controlSize(.small)
		}.padding(.horizontal)
#endif
		Spacer()
    }
}

#Preview {
    ContentView()
}

extension AppStorage {
	
}
