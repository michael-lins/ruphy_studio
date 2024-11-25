export default class extends Controller {
  connect() {
    console.log("BuilderController connected");

    // Initialize drag-and-drop functionality (existing code remains here)

    // Load the layout on page load
    this.loadLayout();
  }

  saveLayout() {
    // Gather dropped components
    const components = Array.from(document.querySelectorAll(".dropped-component")).map((component) => {
      const { x, y } = component.style.transform.match(/translate\((?<x>[-\d.]+)px, (?<y>[-\d.]+)px\)/).groups;
      return {
        type: component.textContent.trim(),
        x: parseFloat(x),
        y: parseFloat(y),
      };
    });

    // Send layout to the backend
    fetch("/builder/save", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ layout: components }),
    })
      .then((response) => response.json())
      .then((data) => {
        console.log(data.message);
      });
  }

  loadLayout() {
    // Fetch layout data from the backend
    fetch("/builder/load")
      .then((response) => response.json())
      .then((data) => {
        const { layout } = data;

        // Recreate dropped components
        const dropZone = document.querySelector("#drop-zone");
        layout.forEach((item) => {
          const newElement = document.createElement("div");
          newElement.classList.add("dropped-component", "p-2", "border", "bg-white", "mt-2");
          newElement.innerText = item.type;
          newElement.style.transform = `translate(${item.x}px, ${item.y}px)`;

          dropZone.appendChild(newElement);

          // Make the new element draggable
          interact(newElement).draggable({
            listeners: {
              move(event) {
                const target = event.target;
                const x = (parseFloat(target.getAttribute("data-x")) || 0) + event.dx;
                const y = (parseFloat(target.getAttribute("data-y")) || 0) + event.dy;

                target.style.transform = `translate(${x}px, ${y}px)`;
                target.setAttribute("data-x", x);
                target.setAttribute("data-y", y);
              },
            },
          });
        });
      });
  }
}
