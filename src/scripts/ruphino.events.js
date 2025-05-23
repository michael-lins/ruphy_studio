import { invoke } from '@tauri-apps/api/core';
import { open } from '@tauri-apps/plugin-dialog';

export async function onRuphinoClick() {
  try {
    const folder = await open({
      directory: true,
      multiple: false,
      title: 'Select a folder for your Rails project'
    });

    if (!folder) return;

    const projectName = "ruphy_app";

    try {
        const result = await invoke('create_and_run_project', {
          projectName,
          path: folder
        });
        console.log("invoke result:", result);
    } catch (err) {
        console.error("invoke failed:", err);
    }

    console.log("🚀 Rails app created and running at http://localhost:3000");
  } catch (err) {
    console.error("🐶 Ruphino failed:", err);
  }
}