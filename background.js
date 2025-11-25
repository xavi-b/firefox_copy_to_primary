console.log("[CopyToPrimary] Background script loaded");

browser.runtime.onMessage.addListener((msg, sender, sendResponse) => {
  console.log("[CopyToPrimary] Received message:", msg);
  console.log("[CopyToPrimary] Sender:", sender);

  if (msg.type === "copy") {
    console.log("[CopyToPrimary] Processing copy request, text length:", msg.text?.length);

    // send to native host
    try {
      console.log("[CopyToPrimary] Connecting to native host: copy_to_primary_host");
      const port = browser.runtime.connectNative("copy_to_primary_host");

      port.onDisconnect.addListener(() => {
        if (browser.runtime.lastError) {
          console.error("[CopyToPrimary] Native host disconnected with error:", browser.runtime.lastError);
        } else {
          console.log("[CopyToPrimary] Native host disconnected successfully");
        }
      });

      console.log("[CopyToPrimary] Sending message to native host:", {text: msg.text});
      port.postMessage({text: msg.text});
      port.disconnect();
      console.log("[CopyToPrimary] Message sent successfully");

      sendResponse({success: true});
    } catch(e) {
      console.error("[CopyToPrimary] Error communicating with native host:", e);
      sendResponse({success: false, error: e.message});
    }
  }

  return true; // Important: keep message channel open for async response
});
