import PyInstaller.__main__
import os
import shutil

def build_executable():
    # Clean previous builds
    if os.path.exists("dist"):
        shutil.rmtree("dist")
    if os.path.exists("build"):
        shutil.rmtree("build")

    # Copy .env file to dist
    if os.path.exists(".env"):
        shutil.copy(".env", "dist/.env")

    # Build the executable
    PyInstaller.__main__.run([
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
    ])

    print("Build completed! The executable can be found in the 'dist' directory.")

if __name__ == "__main__":
    build_executable() 