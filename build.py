import PyInstaller.__main__
import os
import shutil

def build_executable():
    # Clean previous builds
    if os.path.exists("dist"):
        shutil.rmtree("dist")
    if os.path.exists("build"):
        shutil.rmtree("build")
    
    # Build the executable
    PyInstaller.__main__.run([
        'aelethia.py',
        '--name=Aelethia',
        '--onefile',
        '--windowed',
        '--icon=NONE',  # Add an icon file if you have one
        '--add-data=requirements.txt;.',
        '--hidden-import=PyQt6',
        '--hidden-import=PyQt6.QtCore',
        '--hidden-import=PyQt6.QtGui',
        '--hidden-import=PyQt6.QtWidgets',
        '--hidden-import=cryptography',
        '--hidden-import=pkgutil',
        '--clean',
        '--noconfirm'
    ])
    
    print("Build completed! The executable can be found in the 'dist' directory.")

if __name__ == "__main__":
    build_executable() 