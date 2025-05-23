import { onRuphinoClick } from './scripts/ruphino.events.js';

window.addEventListener('DOMContentLoaded', () => {
  const ruphino = document.getElementById("ruphino");
  let isDragging = false;

  ruphino.addEventListener('mousedown', async (e) => {
    const onMouseMove = (eMove) => {
      isDragging = true;
    };

    const onMouseUp = () => {
      document.removeEventListener("mousemove", onMouseMove);
      document.removeEventListener("mouseup", onMouseUp);
    };

    document.addEventListener("mousemove", onMouseMove);
    document.addEventListener("mouseup", onMouseUp);
  });

  ruphino.addEventListener("click", (e) => {
    console.log("🔥 CLICK FIRED 🔥", isDragging);
    if (isDragging) {
      e.preventDefault(); // Cancel accidental drag-click
      return;
    }
    onRuphinoClick(); // Only runs if not dragged
  });
});