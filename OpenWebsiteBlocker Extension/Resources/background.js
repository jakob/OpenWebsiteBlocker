function updateRules() {
	browser.runtime.sendNativeMessage("application.id", "BlockedDomains", async function(blockedDomains) {
		console.log("Received sendNativeMessage response:");
		console.log(blockedDomains);
		
		
		var oldRules = await browser.declarativeNetRequest.getDynamicRules()
		
		for (oldRule of oldRules) {
			console.log("removing dynamic rules " + oldRule);
			await browser.declarativeNetRequest.updateDynamicRules({ removeRuleIds: [ oldRule.id ] });
		}
		
		console.log("removing dynamic rules done!");
		
		for (i=0;i<blockedDomains.length;i++) {
			console.log("adding dynamic rule for " + blockedDomains[i]);
			var rule = {
				id: 1 + i,
				priority: 1,
				action: { type: "block" },
				condition: {
					resourceTypes: [ "main_frame" ],
					urlFilter: "||" + blockedDomains[i]
				}
			}
			console.log(rule);
			await browser.declarativeNetRequest.updateDynamicRules({ addRules: [ rule ] });
		}
		
		console.log("updateDynamicRules addRules done!");

	});

}

let port = browser.runtime.connectNative("application.id");
port.onMessage.addListener(function(message) {
	console.log("Received native port message:");
	console.log(message);
});

updateRules()
