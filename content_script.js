console.log("[CopyToPrimary] Content script loaded on:", window.location.href);

// Function to send text to background script
function sendToPrimary(text) {
  if (!text || text.length === 0) {
    console.log("[CopyToPrimary] No text to copy, skipping");
    return;
  }

  console.log("[CopyToPrimary] Text detected, length:", text.length);
  console.log("[CopyToPrimary] Preview:", text.substring(0, 100) + (text.length > 100 ? "..." : ""));

  browser.runtime.sendMessage({type: "copy", text})
    .then(() => {
      console.log("[CopyToPrimary] Message sent to background successfully");
    })
    .catch((err) => {
      console.error("[CopyToPrimary] Error sending message to background:", err);
    });
}

// Listen for messages from the injected page script
window.addEventListener('__copyToPrimaryEvent', (e) => {
  console.log("[CopyToPrimary] Received event from page script");
  sendToPrimary(e.detail);
});

// Inject a script into the page context to intercept clipboard API
// Use extension URL to avoid CSP violations on sites like GitHub
const scriptUrl = browser.runtime.getURL('page_script.js');
const script = document.createElement('script');
script.src = scriptUrl;
script.onload = () => {
  console.log("[CopyToPrimary] Page script injected successfully");
  script.remove();
};
script.onerror = (err) => {
  console.error("[CopyToPrimary] Failed to inject page script:", err);
  script.remove();
};
(document.head || document.documentElement).appendChild(script);
