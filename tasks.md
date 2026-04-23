[X] Step 1 — Desktop idle (Glimmer window)
[ ] Step 2 — Radial menu
We are implementing Step 2 of an MVP spec.

Context:
- Ruby
- Glimmer DSL for SWT
- We already have a floating Ruphino icon (always-on-top shell)

Goal:
When the user single-clicks the icon, show a radial menu around it.

Constraints:
- Only 2 options: "Create Project" and "Open Project"
- Menu should appear around the icon (not overlapping it)
- No animations required (simple show/hide is fine)
- Keep implementation minimal and readable
- No external gems

Behavior:
- Clicking Ruphino toggles the menu
- Clicking outside closes the menu
- Each menu item prints to console for now

Task:
Generate:
1. Glimmer code to create the radial menu
2. Positioning logic relative to the icon
3. Event handling (click toggle, outside click close)

Do not overengineer. No abstractions. Just working code.
[x] Step 3 — Create project (rails new)
We are implementing Step 3 of an MVP spec.

Context:
- Ruby
- Glimmer DSL SWT desktop app
- User clicks "Create Project" from a radial menu

Goal:
When clicked:
1. Ask user to select a folder
2. Run "rails new <project_name>" inside that folder
3. Start the Rails server

Constraints:
- No configuration prompts
- Use system commands (no Rails API)
- Keep it synchronous for now (simple)
- Output logs to console

Assumptions:
- Rails is installed
- We are in development environment

Task:
Generate Ruby code that:
1. Opens a native directory chooser (Glimmer)
2. Prompts for project name (simple input dialog is fine)
3. Runs:
   - rails new
   - cd into project
   - bin/dev (fallback to rails server if needed)
4. Prints progress to console

Keep it simple. No background jobs, no threading unless strictly necessary.
[x] Step 4 — Open browser
We are implementing Step 4 of an MVP spec.

Context:
- Ruby
- After starting a Rails server locally (port 3000)

Goal:
Open the default browser at http://localhost:3000

Constraints:
- Cross-platform (Mac, Linux, Windows)
- No external gems
- Keep it simple

Task:
Generate Ruby code that:
1. Detects OS
2. Opens the default browser to the given URL

Also:
- Show how to call this after the Rails server starts
[x] Step 5 — Inject Ruphino (gem)
We are implementing Step 5 of an MVP spec.

Context:
- Rails 8 app
- Development mode only
- We want to inject a floating UI element (Ruphino) into every page

Goal:
Render a floating draggable icon on every page.

Constraints:
- No gem packaging yet (just code inside the Rails app)
- Use application layout
- Keep it extremely simple
- No external JS frameworks

Behavior:
- Icon appears fixed on screen (top-left is fine)
- Can be dragged (basic JS is enough)
- Clicking it logs "Ruphino clicked" in console

Task:
Generate:
1. A helper or partial to render the Ruphino element
2. Minimal CSS for floating positioning
3. Minimal JavaScript for drag + click

Do not overengineer. No Stimulus unless absolutely necessary.
[ ] Step 5.1 - Ruphy Injection Refinement: creating /ruphy default page
We are implementing Task 5.1 of an MVP spec.

Context:
- Rails 8 application
- We ALREADY have Ruphino being injected into pages (Task 5 is done)
- Now we want a dedicated workspace page at /ruphy

Goal:
Create a minimal /ruphy page that works seamlessly with the existing Ruphino injection.

Requirements:

1. Route
- Add GET /ruphy → ruphy#index
- This route must only be available in development environment

2. Controller
- Create RuphyController with index action
- No logic needed

3. View
- Create app/views/ruphy/index.html.erb
- The page must contain ONLY:

  <div id="ruphy-canvas"></div>

- Add a small HTML comment explaining this is the Ruphy workspace

4. Integration with existing injection
- DO NOT duplicate or modify the Ruphino injection logic
- The existing injection should naturally render Ruphino on this page

5. Layout
- Use the existing application layout as-is
- Do not modify layout

6. Constraints
- Keep everything minimal
- No styling
- No JavaScript
- No generators

Output:
- Show only the new/modified files
- Keep everything Rails-conventional
[ ] Step 6 — In-app radial menu
[ ] Step 7 — Add Todo flow
