#!/bin/env python3

import os
import subprocess
import shutil
import sys

def main():
    # Determine the operating system
    os_name = determine_os()

    # Packages to install
    packages = ["gcc", "gdb", "make", "valgrind", "curl", "git", "vim"]

    # Install packages based on OS
    if os_name == "fedora":
        print("Detected Fedora/RHEL-based system.")
        install_packages_dnf(packages)
    elif os_name == "ubuntu":
        print("Detected Ubuntu/Debian-based system.")
        install_packages_apt(packages)
    else:
        sys.exit("Unsupported operating system.")

    print("Package installation complete.")

    # Run installation scripts
    run_install_scripts()

    # Copy .vimrc to home directory
    copy_vimrc_to_home()


def determine_os():
    """Determine the operating system based on /etc/os-release."""
    os_release_path = "/etc/os-release"
    if os.path.isfile(os_release_path):
        os_info = {}
        with open(os_release_path, "r") as file:
            for line in file:
                if line.startswith("ID="):
                    os_info["id"] = line.strip().split("=")[-1].strip('"')

        if os_info.get("id") in {"fedora", "rhel"}:
            return "fedora"
        elif os_info.get("id") in {"ubuntu", "debian"}:
            return "ubuntu"

    return None


def install_packages_dnf(packages):
    """Install packages using dnf."""
    package_string = " ".join(packages)
    command = f"sudo dnf install -y {package_string}"
    execute_command(command)


def install_packages_apt(packages):
    """Install packages using apt."""
    package_string = " ".join(packages)
    command = f"sudo apt-get update && sudo apt-get install -y {package_string}"
    execute_command(command)


def run_install_scripts():
    """Run additional installation scripts."""
    scripts = ["install_nvim.sh", "install_kitty.sh", "install_go.sh"]

    for script in scripts:
        print(f"Running {script}...")
        command = f"bash ./{script}"
        execute_command(command, error_message=f"Error running {script}")


def copy_vimrc_to_home():
    """Copy the .vimrc file to the home directory."""
    source = ".vimrc"
    destination = os.path.expanduser("~/.vimrc")

    try:
        shutil.copy(source, destination)
        print(f"File '{source}' copied to '{destination}' successfully.")
    except Exception as e:
        sys.exit(f"Error copying file: {e}")


def execute_command(command, error_message="Error executing command"):
    """Execute a shell command and handle errors."""
    try:
        subprocess.run(command, shell=True, check=True)
        print(f"Successfully executed: {command}")
    except subprocess.CalledProcessError as e:
        sys.exit(f"{error_message}: {e}")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        sys.exit(f"An unexpected error occurred: {e}")

