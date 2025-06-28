"""
Build script for Aletheia AI Companion.

Creates a standalone executable using PyInstaller with proper configuration
for the cosmic-themed AI companion application.
"""

import os
import shutil
from pathlib import Path
from typing import List

import PyInstaller.__main__


def clean_build_directories() -> None:
    """Remove previous build artifacts."""
    build_dirs = ["dist", "build"]
    
    for dir_name in build_dirs:
        if os.path.exists(dir_name):
            shutil.rmtree(dir_name)
            print(f"Cleaned {dir_name} directory")


def copy_environment_file() -> None:
    """Copy .env file to dist directory if it exists."""
    env_file = Path(".env")
    if env_file.exists():
        dist_dir = Path("dist")
        dist_dir.mkdir(exist_ok=True)
        shutil.copy(env_file, dist_dir / ".env")
        print("Copied .env file to dist directory")


def get_pyinstaller_args() -> List[str]:
    """Get PyInstaller command line arguments."""
    return [
        'aelethia.py',
        '--name=Aelethia',
        '--onefile',
        '--windowed',
        '--add-data=IMG_8647.JPG;.',
        '--add-data=.env;.',
        '--exclude-module=PyQt6',
        '--exclude-module=PyQt6.QtCore',
        '--exclude-module=PyQt6.QtGui',
        '--exclude-module=PyQt6.QtWidgets',
        '--hidden-import=requests',
        '--hidden-import=dotenv',
        '--clean',
        '--noconfirm'
    ]


def build_executable() -> None:
    """Build the Aletheia executable using PyInstaller."""
    print("Starting Aletheia build process...")
    
    # Clean previous builds
    clean_build_directories()
    
    # Copy environment file
    copy_environment_file()
    
    # Get PyInstaller arguments
    args = get_pyinstaller_args()
    
    # Build the executable
    print("Building executable with PyInstaller...")
    PyInstaller.__main__.run(args)
    
    print("Build completed! The executable can be found in the 'dist' directory.")


if __name__ == "__main__":
    build_executable() 