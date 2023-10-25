//
//  SafariWebExtensionHandler.swift
//  OpenWebsiteBlocker Extension
//
//  Created by Jakob Egger on 25.10.23.
//

import SafariServices
import os.log


class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let request = context.inputItems.first as? NSExtensionItem

        let profile: UUID?
        if #available(iOS 17.0, macOS 14.0, *) {
            profile = request?.userInfo?[SFExtensionProfileKey] as? UUID
        } else {
            profile = request?.userInfo?["profile"] as? UUID
        }

        let message: Any?
        if #available(iOS 17.0, macOS 14.0, *) {
            message = request?.userInfo?[SFExtensionMessageKey]
        } else {
            message = request?.userInfo?["message"]
        }

		let response = NSExtensionItem()

		if message as? String == "BlockedDomains" {
			if let sharedDefaults = UserDefaults(suiteName: "at.eggerapps.OpenWebsiteBlocker.Shared") {
				if let blockedDomains = sharedDefaults.stringArray(forKey: "BlockedDomains") {
					os_log(.default, "Extension requested BlockedDomains, returning: \(blockedDomains, privacy: .public)")
					response.userInfo = [ SFExtensionMessageKey: blockedDomains ]
				} else {
					os_log(.error, "No blocked domains configured")
				}
			} else {
				os_log(.error, "Can't access shared defaults")
			}
		} else {
			os_log(.error, "Received invalid message from extension: \(String(describing:message), privacy: .public)")
		}

        context.completeRequest(returningItems: [ response ], completionHandler: nil)
    }

}
