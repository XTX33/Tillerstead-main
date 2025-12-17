/* main.js — Tillerstead
   - Responsive, accessible nav (ESC, outside click, resize, touch)
   - High contrast mode toggle with localStorage
   - Smooth anchor scrolling (respects reduced motion)
   - Static-host form handling (GitHub Pages) + Netlify passthrough
   - Modern browser support with fallbacks
*/
(() => {
  // ...existing code...
  /* =========================
     HIGH CONTRAST MODE TOGGLE
     - Adds html.high-contrast class
     - Persists preference in localStorage
     - Re-runs contrast + autoContrast for recalculation
  ========================= */
  const HC_KEY = "ts:high-contrast";
  const contrastToggle = document.querySelector('[data-contrast-toggle]');

  const applyHighContrast = (enabled) => {
    document.documentElement.classList.toggle('high-contrast', !!enabled);
    if (contrastToggle) {
      contrastToggle.setAttribute('aria-pressed', String(!!enabled));
      contrastToggle.setAttribute('aria-label', enabled ? 'Disable high contrast mode' : 'Enable high contrast mode');
    }
    if (typeof window.applyContrast === 'function') window.applyContrast(enabled ? 7 : 7); // keep AAA target
    if (typeof window.autoContrast === 'function') window.autoContrast();
  };

  try {
    const storedHC = localStorage.getItem(HC_KEY) === '1';
    applyHighContrast(storedHC);
  } catch (_) { /* ignore */ }

  if (contrastToggle) {
    contrastToggle.addEventListener('click', () => {
      const enabled = !document.documentElement.classList.contains('high-contrast');
      applyHighContrast(enabled);
      try { localStorage.setItem(HC_KEY, enabled ? '1' : '0'); } catch (_) { /* ignore */ }
    });
  }

  /* =========================
     KEYBOARD SHORTCUTS
     Alt+Shift+C : Toggle High Contrast
     Alt+Shift+A : Toggle Audit Overlay (reload if enabling)
  ========================= */
  document.addEventListener('keydown', (e) => {
    if (!e.altKey || !e.shiftKey) return;
    if (e.code === 'KeyC') {
      e.preventDefault();
      const enabled = !document.documentElement.classList.contains('high-contrast');
      applyHighContrast(enabled);
    try { localStorage.setItem(HC_KEY, enabled ? '1' : '0'); } catch (_) { /* ignore */ }
    } else if (e.code === 'KeyA') {
      e.preventDefault();
      const hasFlag = localStorage.getItem('ts:audit') === '1';
      if (hasFlag) {
        localStorage.removeItem('ts:audit');
        // Remove existing panel if present without reload
        const panel = document.querySelector('.ts-dev-overlay');
        if (panel) panel.remove();
      } else {
        localStorage.setItem('ts:audit', '1');
        // Reload to allow dev-overlay.js to initialize
        location.search.includes('audit=1') ? location.reload() : location.href = location.pathname + '?audit=1';
      }
    }
  });

  /* =========================
     SMOOTH SCROLL (anchors)
     - respects reduced motion
  ========================= */
  const prefersReduced =
    window.matchMedia &&
    window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  document.addEventListener("click", (e) => {
    const a = e.target.closest('a[href^="#"]');
    if (!a) return;

    const href = a.getAttribute("href");
    if (!href || href === "#") return;

    const id = href.slice(1);
    const target = document.getElementById(id);
    if (!target) return;

    e.preventDefault();
    const behavior = prefersReduced ? "auto" : "smooth";
    target.scrollIntoView({ behavior, block: "start" });
    target.setAttribute("tabindex", "-1");
    target.focus({ preventScroll: true });
    setTimeout(() => target.removeAttribute("tabindex"), 1000);
  });

})();
