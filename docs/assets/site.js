/* DMG-CPU Research site script: light/dark theme toggle. */
(function () {
  "use strict";

  var STORAGE_KEY = "dmgcpu-theme";

  function currentTheme() {
    var t = null;
    try { t = localStorage.getItem(STORAGE_KEY); } catch (e) { /* ignore */ }
    if (t === "light" || t === "dark") return t;
    try {
      return window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches
        ? "dark" : "light";
    } catch (e) { return "light"; }
  }

  function applyTheme(theme, persist) {
    document.documentElement.setAttribute("data-theme", theme);
    var btn = document.getElementById("theme-toggle");
    if (btn) {
      btn.setAttribute("aria-pressed", String(theme === "dark"));
      btn.setAttribute("aria-label", theme === "dark"
        ? "Switch to light theme" : "Switch to dark theme");
    }
    if (persist) {
      try { localStorage.setItem(STORAGE_KEY, theme); } catch (e) { /* ignore */ }
    }
  }

  function init() {
    applyTheme(currentTheme(), false);
    var btn = document.getElementById("theme-toggle");
    if (!btn) return;
    btn.addEventListener("click", function () {
      var next = document.documentElement.getAttribute("data-theme") === "dark"
        ? "light" : "dark";
      applyTheme(next, true);
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
