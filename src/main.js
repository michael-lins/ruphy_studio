import { animate, spring } from "motion";
import { shell } from "@tauri-apps/api/shell";
import { resolveResource } from "@tauri-apps/api/path";

async function jumpIntoBrowser() {
  // Animate Ruphino
  animate("#ruphino", {
    scale: [1, 1.2, 0],
    opacity: [1, 1, 0],
    y: [0, -30, -100]
  }, {
    duration: 1,
    easing: spring({ stiffness: 200, damping: 20 })
  });

  // Let it finish
  setTimeout(async () => {
    const landingPath = await resolveResource("public/index.html");
    await shell.open("file://" + landingPath);
    window.close();
  }, 1000);
}

// Trigger the jump animation when the DOM content is loaded
window.addEventListener("DOMContentLoaded", jumpIntoBrowser);
