// Learn more about Tauri commands at https://tauri.app/develop/calling-rust/
#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_opener::init())
        .invoke_handler(tauri::generate_handler![greet, create_and_run_project])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}

#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}! You've been greeted from Rust!", name)
}

#[tauri::command]
fn create_and_run_project(project_name: String, path: String) -> Result<(), String> {
    let create = std::process::Command::new("docker")
        .args([
            "run", "--rm", "-v",
            &format!("{}:/app", path),
            "-w", "/app",
            "your_dockerhub_user/ruphy-rails-dev:latest",
            "rails", "new", &project_name, "--skip-bundle"
        ])
        .output()
        .map_err(|e| format!("Project creation failed: {}", e))?;

    if !create.status.success() {
        return Err(String::from_utf8_lossy(&create.stderr).to_string());
    }

    // Run Rails server detached
    let run = std::process::Command::new("docker")
        .args([
            "run", "-d", "-v",
            &format!("{}:/app", path),
            "-w", &format!("/app/{}", project_name),
            "-p", "3000:3000",
            "your_dockerhub_user/ruphy-rails-dev:latest",
            "rails", "server", "-b", "0.0.0.0"
        ])
        .output()
        .map_err(|e| format!("Rails server failed: {}", e))?;

    if !run.status.success() {
        return Err(String::from_utf8_lossy(&run.stderr).to_string());
    }

    // Open in browser
    open::that("http://localhost:3000")
        .map_err(|e| format!("Failed to open browser: {}", e))?;

    Ok(())
}