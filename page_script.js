// This script runs in the page context (not isolated)
(function() {
  console.log("[CopyToPrimary] Page script injected");

  // Intercept Clipboard API
  if (navigator.clipboard && navigator.clipboard.writeText) {
    const originalWriteText = navigator.clipboard.writeText.bind(navigator.clipboard);

    navigator.clipboard.writeText = function(text) {
      console.log("[CopyToPrimary] Clipboard API intercepted in page context, text:", text.substring(0, 50));

      // Dispatch custom event to content script
      window.dispatchEvent(new CustomEvent('__copyToPrimaryEvent', { detail: text }));

      return originalWriteText(text);
    };

    console.log("[CopyToPrimary] Clipboard API hooked successfully");
  }

  // Intercept execCommand for legacy copy
  const originalExecCommand = document.execCommand.bind(document);
  document.execCommand = function(command, ...args) {
    if (command === 'copy') {
      const text = document.getSelection().toString();
      console.log("[CopyToPrimary] execCommand('copy') intercepted");
      window.dispatchEvent(new CustomEvent('__copyToPrimaryEvent', { detail: text }));
    }
    return originalExecCommand(command, ...args);
  };
})();

