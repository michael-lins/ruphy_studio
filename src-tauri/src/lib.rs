// Learn more about Tauri commands at https://tauri.app/develop/calling-rust/
#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_dialog::init())
        .invoke_handler(tauri::generate_handler![
            create_and_run_project
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}

#[tauri::command]
fn create_and_run_project(project_name: String, path: String) -> Result<(), String> {
    let volume_mount = format!("{}:/app", path);
    let docker_image = "malvins/ruphy-rails-dev:latest";

    // Create a new Rails app
    let rails_new = std::process::Command::new("docker")
        .args([
            "run", "--rm", "-v",
            &volume_mount,
            "-w", "/app",
            &docker_image,
            "rails", "new", &project_name, "--skip-bundle"
        ])
        .output()
        .map_err(|e| format!("Creating Rails project failed: {}", e))?;

    if !rails_new.status.success() {
        return Err(String::from_utf8_lossy(&rails_new.stderr).to_string());
    }

    let workdir = format!("/app/{}", project_name);

    // Add platform to the lockfile
    let add_platform = std::process::Command::new("docker")
        .args([
            "run", "--rm", "-v", &volume_mount,
            "-w", &workdir,
            &docker_image,
            "bundle", "lock", "--add-platform", "x86_64-linux"
        ])
        .output()
        .map_err(|e| format!("Adding platform failed: {}", e))?;

    if !add_platform.status.success() {
        return Err(String::from_utf8_lossy(&add_platform.stderr).to_string());
    }

    // Install dependencies inside the new app
    let bundle_install = std::process::Command::new("docker")
        .args([
            "run", "--rm", "-v", &volume_mount,
            "-w", &workdir,
            &docker_image,
            "bundle", "install"
        ])
        .output()
        .map_err(|e| format!("bundle install failed: {}", e))?;
    
    if !bundle_install.status.success() {
        return Err(String::from_utf8_lossy(&bundle_install.stderr).to_string());
    }

    // Create Home controller and set root route
    let setup = std::process::Command::new("docker")
        .args([
            "run", "--rm", "-v", &volume_mount,
            "-w", &workdir,
            &docker_image,
            "/bin/bash", "-c",
            "bundle exec rails g controller Home index && sed -i '/Rails.application.routes.draw do/a\\  root \"home#index\"' config/routes.rb"
        ])
        .output()
        .map_err(|e| format!("Project setup failed: {}", e))?;

    if !setup.status.success() {
        return Err(String::from_utf8_lossy(&setup.stderr).to_string());
    }

    // Prepare the database
    let db_prepare = std::process::Command::new("docker")
        .args([
            "run", "--rm", "-v", &volume_mount,
            "-w", &workdir,
            &docker_image,
            "bundle", "exec", "rails", "db:prepare"
        ])
        .output()
        .map_err(|e| format!("DB prepare failed: {}", e))?;

    if !db_prepare.status.success() {
        return Err(String::from_utf8_lossy(&db_prepare.stderr).to_string());
    }

    // Check if container exists
    let check = std::process::Command::new("docker")
    .args(["ps", "-a", "--filter", "name=ruphy_project_runner", "--format", "{{.Status}}"])
    .output()
    .map_err(|e| format!("Failed to check container: {}", e))?;

    let status = String::from_utf8_lossy(&check.stdout);

    // Case 1: it exists and is exited — start it
    if status.contains("Exited") {
    let start = std::process::Command::new("docker")
        .args(["start", "ruphy_project_runner"])
        .output()
        .map_err(|e| format!("Failed to start existing container: {}", e))?;
    if !start.status.success() {
        return Err(String::from_utf8_lossy(&start.stderr).to_string());
    }
    }
    // Case 2: it doesn't exist — run it
    else if status.trim().is_empty() {
    let run = std::process::Command::new("docker")
        .args([
            "run", "--name", "ruphy_project_runner", "-d",
            "-v", &format!("{}:/app", path),
            "-w", &format!("/app/{}", project_name),
            "-p", "3000:3000",
            "malvins/ruphy-rails-dev:latest",
            "rails", "server", "-b", "0.0.0.0"
        ])
        .output()
        .map_err(|e| format!("Rails server failed: {}", e))?;
    if !run.status.success() {
        return Err(String::from_utf8_lossy(&run.stderr).to_string());
    }
    }

    // Open in browser
    open::that("http://localhost:3000")
        .map_err(|e| format!("Failed to open browser: {}", e))?;

    Ok(())
}