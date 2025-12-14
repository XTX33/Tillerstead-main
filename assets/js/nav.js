(() => {
  const toggle = document.querySelector("[data-nav-toggle]");
  const drawer = document.querySelector("[data-nav-drawer]");
  const backdrop = document.querySelector("[data-nav-backdrop]");
  const closeBtn = document.querySelector("[data-nav-close]");

  if (!toggle || !drawer || !backdrop) return;

  const open = () => {
    document.body.classList.add("nav-open");
    toggle.setAttribute("aria-expanded", "true");
    drawer.setAttribute("aria-hidden", "false");
    drawer.hidden = false;
    backdrop.hidden = false;
  };

  const close = () => {
    document.body.classList.remove("nav-open");
    toggle.setAttribute("aria-expanded", "false");
    drawer.setAttribute("aria-hidden", "true");
    drawer.hidden = true;
    backdrop.hidden = true;
    toggle.focus();
  };

  toggle.addEventListener("click", () => {
    document.body.classList.contains("nav-open") ? close() : open();
  });

  backdrop.addEventListener("click", close);
  closeBtn?.addEventListener("click", close);

  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape" && document.body.classList.contains("nav-open")) close();
  });

  // Close drawer if resized to desktop
  window.addEventListener("resize", () => {
    if (window.matchMedia("(min-width: 900px)").matches && document.body.classList.contains("nav-open")) close();
  });
})();