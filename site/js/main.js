/* FerricOS site — vanilla JS, no dependencies */
(() => {
  "use strict";

  const $ = (sel, ctx = document) => ctx.querySelector(sel);
  const $$ = (sel, ctx = document) => [...ctx.querySelectorAll(sel)];

  /* ---------- footer year ---------- */
  $("#year").textContent = new Date().getFullYear();

  /* ---------- mobile nav ---------- */
  const navToggle = $("#navToggle");
  const navLinks = $(".nav-links");
  navToggle.addEventListener("click", () => {
    const open = navLinks.classList.toggle("open");
    navToggle.setAttribute("aria-expanded", String(open));
  });
  navLinks.addEventListener("click", (e) => {
    if (e.target.tagName === "A") navLinks.classList.remove("open");
  });

  /* ---------- scrollspy ---------- */
  const sections = $$("main section[id]");
  const navAnchors = $$('.nav-links a[href^="#"]');
  const spy = new IntersectionObserver(
    (entries) => {
      for (const entry of entries) {
        if (!entry.isIntersecting) continue;
        navAnchors.forEach((a) =>
          a.classList.toggle("active", a.getAttribute("href") === "#" + entry.target.id)
        );
      }
    },
    { rootMargin: "-30% 0px -60% 0px" }
  );
  sections.forEach((s) => spy.observe(s));

  /* ---------- back to top ---------- */
  const backTop = $("#backTop");
  window.addEventListener(
    "scroll",
    () => { backTop.hidden = window.scrollY < 900; },
    { passive: true }
  );
  backTop.addEventListener("click", () => window.scrollTo({ top: 0, behavior: "smooth" }));

  /* ---------- reveal on scroll ---------- */
  const io = new IntersectionObserver(
    (entries) => {
      for (const entry of entries) {
        if (entry.isIntersecting) {
          entry.target.classList.add("in");
          io.unobserve(entry.target);
        }
      }
    },
    { threshold: 0.12 }
  );
  $$(".reveal").forEach((el) => io.observe(el));

  /* ---------- toast + clipboard ---------- */
  const toast = $("#toast");
  let toastTimer;
  function showToast(msg) {
    toast.textContent = msg;
    toast.classList.add("show");
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => toast.classList.remove("show"), 1600);
  }

  function copyText(text, label) {
    navigator.clipboard
      .writeText(text)
      .then(() => showToast(label))
      .catch(() => showToast("copy failed — select it manually"));
  }

  $$(".cmd").forEach((box) => {
    const btn = $(".cmd-copy", box);
    btn.addEventListener("click", () => copyText(box.dataset.cmd, "command copied"));
  });

  $$(".swatch").forEach((sw) => {
    sw.addEventListener("click", () => copyText(sw.dataset.hex, sw.dataset.hex + " copied"));
  });

  /* ---------- latest release badge ---------- */
  const releaseBadge = $("#releaseBadge");
  fetch("https://api.github.com/repos/notChewy1324/ferricos/releases/latest", {
    headers: { Accept: "application/vnd.github+json" },
  })
    .then((r) => (r.ok ? r.json() : Promise.reject()))
    .then((rel) => {
      if (rel && rel.tag_name && rel.tag_name !== "packages") {
        releaseBadge.textContent = rel.tag_name;
        $("#downloadBtn").href = rel.html_url;
      }
    })
    .catch(() => { /* keep the "rolling" fallback */ });

  /* ---------- wallpaper lightbox ---------- */
  const lightbox = $("#lightbox");
  const lightboxImg = $("#lightboxImg");
  let lastFocus = null;

  function openLightbox(img) {
    lastFocus = document.activeElement;
    lightboxImg.src = img.src;
    lightboxImg.alt = img.alt;
    lightbox.hidden = false;
    document.body.style.overflow = "hidden";
    $("#lightboxClose").focus();
  }
  function closeLightbox() {
    lightbox.hidden = true;
    lightboxImg.src = "";
    document.body.style.overflow = "";
    if (lastFocus) lastFocus.focus();
  }

  $$(".wall").forEach((fig) => {
    fig.addEventListener("click", () => openLightbox($("img", fig)));
  });
  lightbox.addEventListener("click", closeLightbox);
  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape" && !lightbox.hidden) closeLightbox();
  });

  /* ---------- deck tape counter ---------- */
  const counter = $("#deckCounter");
  let count = 0;
  setInterval(() => {
    count = (count + 1) % 10000;
    counter.textContent = String(count).padStart(4, "0");
  }, 400);

  /* ---------- hero typing effect ---------- */
  const typeTarget = $("#typeTarget");
  const phrase = "cassette-futurism soul";
  const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  if (!reduceMotion) {
    const cursor = '<span class="cursor">▌</span>';
    let i = 0;
    typeTarget.innerHTML = cursor;
    const typer = setInterval(() => {
      i++;
      typeTarget.innerHTML = phrase.slice(0, i) + cursor;
      if (i >= phrase.length) clearInterval(typer);
    }, 55);
  }

  /* ---------- terminal fastfetch demo ---------- */
  const termBody = $("#termBody");
  const PROMPT = '<span class="t-prompt">ferric@ferricos ~ %</span> ';
  const PAD = " ".repeat(21); // width of the cassette logo block

  // the real /etc/skel fastfetch logo (ferric-skel → .config/fastfetch/ferric.txt)
  const session = [
    { type: "fastfetch", speed: 70 },
    {
      print: [
        '<span class="t-logo"> ┌──────────────────┐</span>  <span class="t-key">ferric</span><span class="t-dim">@</span><span class="t-key">ferricos</span>',
        '<span class="t-logo"> │ </span><span class="t-dim">▒▒▒▒▒▒▒▒▒▒▒▒▒▒</span><span class="t-logo">   │</span>  <span class="t-dim">─────────────────</span>',
        '<span class="t-logo"> │  ◯ ─────────· ◯  │</span>  <span class="t-key">OS</span><span class="t-dim">:</span>       <span class="t-val">FerricOS x86_64</span>',
        '<span class="t-logo"> │   FERRIC // OS   │</span>  <span class="t-key">Kernel</span><span class="t-dim">:</span>   <span class="t-val">linux (rolling)</span>',
        '<span class="t-logo"> └──────────────────┘</span>  <span class="t-key">WM</span><span class="t-dim">:</span>       <span class="t-val">Hyprland</span>',
        PAD + '  <span class="t-key">Bar</span><span class="t-dim">:</span>      <span class="t-val">waybar</span>',
        PAD + '  <span class="t-key">Term</span><span class="t-dim">:</span>     <span class="t-val">kitty</span>',
        PAD + '  <span class="t-key">Launcher</span><span class="t-dim">:</span> <span class="t-val">fuzzel</span>',
        PAD + '  <span class="t-key">Pkgs</span><span class="t-dim">:</span>     <span class="t-val">pacman + [ferric]</span>',
        PAD + '  <span class="t-key">Palette</span><span class="t-dim">:</span>  <span class="t-logo">#D85A30</span> <span class="t-dim">on #0C0B0A</span>',
        "",
      ],
    },
    { type: "sudo pacman -Syu", speed: 55 },
    {
      print: [
        '<span class="t-dim">:: Synchronizing package databases...</span>',
        '<span class="t-dim"> core is up to date</span>',
        '<span class="t-dim"> extra is up to date</span>',
        ' <span class="t-key">ferric</span><span class="t-dim"> is up to date</span>',
        '<span class="t-dim">:: Starting full system upgrade...</span>',
        '<span class="t-val"> there is nothing to do</span>',
        "",
      ],
    },
    { type: "echo $QUIET", speed: 70 },
    { print: ['<span class="t-val">yes.</span>', ""] },
  ];

  let running = false;

  function runTerminal() {
    if (running) return;
    running = true;
    termBody.innerHTML = PROMPT;

    if (reduceMotion) {
      // dump everything instantly
      termBody.innerHTML = "";
      for (const step of session) {
        if (step.type) termBody.innerHTML += PROMPT + step.type + "\n";
        if (step.print) termBody.innerHTML += step.print.join("\n") + "\n";
      }
      termBody.innerHTML += PROMPT + '<span class="cursor">▌</span>';
      running = false;
      return;
    }

    let stepIdx = 0;

    function nextStep() {
      if (stepIdx >= session.length) {
        termBody.innerHTML += PROMPT + '<span class="cursor">▌</span>';
        running = false;
        return;
      }
      const step = session[stepIdx++];

      if (step.type) {
        const base = termBody.innerHTML.replace(/<span class="cursor">.*$/s, "");
        let i = 0;
        const iv = setInterval(() => {
          i++;
          termBody.innerHTML =
            base + step.type.slice(0, i) + '<span class="cursor">▌</span>';
          if (i >= step.type.length) {
            clearInterval(iv);
            setTimeout(() => {
              termBody.innerHTML = base + step.type + "\n";
              nextStep();
            }, 260);
          }
        }, step.speed);
      } else if (step.print) {
        let li = 0;
        const iv = setInterval(() => {
          termBody.innerHTML += step.print[li++] + "\n";
          if (li >= step.print.length) {
            clearInterval(iv);
            setTimeout(() => {
              if (stepIdx < session.length && session[stepIdx].type) {
                termBody.innerHTML += PROMPT;
              }
              nextStep();
            }, 320);
          }
        }, 60);
      }
    }

    // first prompt already present; start typing after a beat
    setTimeout(nextStep, 500);
  }

  // start the demo when the terminal scrolls into view
  const termIO = new IntersectionObserver(
    (entries) => {
      if (entries[0].isIntersecting) {
        runTerminal();
        termIO.disconnect();
      }
    },
    { threshold: 0.35 }
  );
  termIO.observe($("#desktop .term"));

  $("#termReplay").addEventListener("click", runTerminal);
})();
