export async function onRuphinoClick() {
    const { open } = await import('@tauri-apps/api/dialog');
    const { invoke } = await import('@tauri-apps/api/core');
  
    try {
      const folder = await open({
        directory: true,
        multiple: false,
        title: 'Select a folder for your Rails project'
      });
  
      if (!folder) {
        console.log("No folder selected.");
        return;
      }
  
      const projectName = "ruphy_app";
  
      await invoke('create_and_run_project', {
        projectName,
        path: folder
      });
  
      console.log("🚀 Project is live at http://localhost:3000");
    } catch (err) {
      console.error("🐶 Ruphino failed:", err);
    }
  }