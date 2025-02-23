param ([string]$build_output_rel_path)

# =============
# Variables
# =============

# mod folder name
$mod_dirname = "cmod_example";

# path to the Cosmoteer executable
$cosmoteer_exe_path = "C:\Program Files (x86)\Steam\steamapps\common\Cosmoteer\Bin\Cosmoteer.exe"

# path to the user mods directory; no trailing slash
$cosmoteer_mods_directory_path = "C:\Users\aliser\Saved Games\Cosmoteer\76561198068709671\Mods"

# whether to restart (or start) Cosmoteer after the script is done
$restart_cosmoteer = $false

# whether to start Cosmoteer in devmode. 
# works only if $restart_cosmoteer is enabled.
$restart_cosmoteer_devmode = $true

# =============
# Script
# =============

$mod_dir_path = "$cosmoteer_mods_directory_path\$mod_dirname"

Echo "Running Integration"
Echo "Build path (relative) : $build_output_rel_path"
Echo "   Mod directory path : ${mod_dir_path}"

# Check if build path exists (ie passed correctly from the build process)
if(!(test-path -PathType container $build_output_rel_path)) {
  Throw "Build path not found. Make sure it is passed correctly (in a post-build action to this script). Path: $build_output_rel_path"
}

# Check if Cosmoteer mods directory path exist (ie valid)
if(!(test-path -PathType container $cosmoteer_mods_directory_path)) {
  Throw "Cosmoteer mods directory not found. Make sure the path exists: $cosmoteer_mods_directory_path"
}

# Check if Cosmoteer executable exists (if restarting is enabled)
if($restart_cosmoteer -And !([System.IO.File]::Exists($cosmoteer_exe_path))) {
	Throw "Cosmoteer executable not found. Path: $cosmoteer_exe_path"
}


# Stop Cosmoteer process if it's running
if(Get-Process -ErrorAction SilentlyContinue -Name "cosmoteer") {
  Echo "Found Cosmoteer process, stopping"
  Get-Process -Name "cosmoteer" -ErrorAction SilentlyContinue | Stop-Process -Force

  Echo "Sleeping for some time after killing the process"
  Start-Sleep -Seconds 3
} else {
  Echo "Cosmoteer process is not running"
}

# Create mod directory if it doesn't exist
# Clear it out if it does.
if(test-path -PathType container $mod_dir_path) {
  Echo "Mod directory found, clearing"

  Get-ChildItem $mod_dir_path | Remove-Item -Recurse -Force
} else {
  Echo "Mod directory not found, creating"

  New-Item -ItemType Directory -Force -Path $mod_dir_path
}

# create CMod directory
Echo "Creating CMod directory in the mod"
New-Item -ItemType Directory -Force -Path "$mod_dir_path\CMod"

# Copy files from the release directory to the mod directory
Echo "Copying build files into the CMod directory"
Copy-Item -Path ".\$build_output_rel_path*" -Destination "$mod_dir_path\CMod\" -Recurse -Force

# Copy static files if any
if(test-path -PathType container ".\static") {
	Echo "Copying static files into the mod directory"
	Copy-Item -Path ".\static\*" -Destination "$mod_dir_path\" -Recurse -Force
}

# Restart Cosmoteer if set
if($restart_cosmoteer) {
  Echo "Starting Cosmoteer process"

  if($restart_cosmoteer_devmode) {
	  Start-Process -FilePath $cosmoteer_exe_path -ArgumentList "--devmode"
  } else {
	  Start-Process -FilePath $cosmoteer_exe_path
  }
}

Echo "All done!"