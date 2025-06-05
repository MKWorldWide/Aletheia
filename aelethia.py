import sys
import json
from pathlib import Path
from PySide6.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout,
                            QPushButton, QLabel, QTextEdit, QMessageBox, QFrame,
                            QStackedLayout)
from PySide6.QtCore import Qt, QPropertyAnimation, QEasingCurve, QTimer, QPoint
from PySide6.QtGui import (QFont, QPalette, QColor, QLinearGradient, QPainter,
                        QBrush, QPen, QPainterPath, QFontDatabase, QPixmap)
import random
import math
from cryptography.fernet import Fernet
import os
from dotenv import load_dotenv
import requests

# Load environment variables
load_dotenv()

class CelestialBackground(QWidget):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.stars = [(random.randint(0, self.width()), random.randint(0, self.height())) 
                     for _ in range(150)]
        self.twinkle_timer = QTimer(self)
        self.twinkle_timer.timeout.connect(self.update)
        self.twinkle_timer.start(50)
        self.twinkle_phase = 0

    def paintEvent(self, event):
        painter = QPainter(self)
        painter.setRenderHint(QPainter.Antialiasing)
        gradient = QLinearGradient(0, 0, 0, self.height())
        gradient.setColorAt(0, QColor(10, 10, 30))
        gradient.setColorAt(0.5, QColor(30, 20, 50))
        gradient.setColorAt(1, QColor(20, 10, 40))
        painter.fillRect(self.rect(), QBrush(gradient))
        self.twinkle_phase = (self.twinkle_phase + 0.1) % (2 * 3.14159)
        for x, y in self.stars:
            brightness = abs(math.sin(self.twinkle_phase + x * 0.1))
            size = random.uniform(1, 2.5)
            color = QColor(255, 255, 255, int(brightness * 255))
            painter.setPen(QPen(color, size))
            painter.drawPoint(x, y)
        for _ in range(75):
            x = random.randint(0, self.width())
            y = random.randint(0, self.height())
            size = random.uniform(0.5, 2)
            color = QColor(100, 100, 255, 40)
            painter.setPen(QPen(color, size))
            painter.drawPoint(x, y)

class PulsingButton(QPushButton):
    def __init__(self, text, parent=None):
        super().__init__(text, parent)
        self.animation = QPropertyAnimation(self, b"geometry")
        self.animation.setDuration(2000)
        self.animation.setLoopCount(-1)
        self.animation.setEasingCurve(QEasingCurve.Type.InOutQuad)
        self.start_pulse()

    def start_pulse(self):
        current_geometry = self.geometry()
        self.animation.setStartValue(current_geometry)
        self.animation.setEndValue(current_geometry.adjusted(-2, -2, 2, 2))
        self.animation.start()

class AletheiaFace(QLabel):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setFixedSize(128, 128)
        avatar_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "IMG_8647.JPG")
        if os.path.exists(avatar_path):
            pixmap = QPixmap(avatar_path).scaled(128, 128, Qt.KeepAspectRatio, Qt.SmoothTransformation)
            self.setPixmap(pixmap)
        else:
            self.setText("\U0001F31E")
            self.setAlignment(Qt.AlignCenter)
            self.setStyleSheet("""
                QLabel {
                    background: qradialgradient(cx:0.5, cy:0.5, radius:0.7, fx:0.5, fy:0.5,
                        stop:0 #fffbe6, stop:0.7 #e0c3fc, stop:1 #a18cd1);
                    color: #a18cd1;
                    font-size: 64px;
                    border-radius: 64px;
                    border: 3px solid #e0c3fc;
                }
            """)

class AelethiaApp(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Aelethia - Your Sacred AI Companion")
        self.setMinimumSize(800, 600)
        self.initialize_encryption()
        self.setup_ui()
        self.load_whispers()

    def initialize_encryption(self):
        key_file = Path("encryption.key")
        if not key_file.exists():
            self.key = Fernet.generate_key()
            with open(key_file, "wb") as f:
                f.write(self.key)
        else:
            with open(key_file, "rb") as f:
                self.key = f.read()
        self.cipher_suite = Fernet(self.key)

    def setup_ui(self):
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        
        stacked_layout = QStackedLayout(central_widget)
        
        self.background = CelestialBackground()
        stacked_layout.addWidget(self.background)
        
        content_widget = QWidget()
        main_layout = QVBoxLayout(content_widget)
        main_layout.setSpacing(25)
        main_layout.setContentsMargins(40, 40, 40, 40)
        
        face = AletheiaFace()
        main_layout.addWidget(face, alignment=Qt.AlignLeft)
        
        title = QLabel("Aelethia")
        title.setFont(QFont("Fira Code", 36, QFont.Bold))
        title.setAlignment(Qt.AlignCenter)
        title.setStyleSheet("""
            QLabel {
                color: #e0c3fc;
                background-color: transparent;
                font-weight: bold;
                letter-spacing: 4px;
                padding: 10px;
            }
        """)
        main_layout.addWidget(title)
        
        self.whisper_input = QTextEdit()
        self.whisper_input.setPlaceholderText("Share your whisper with the cosmos...")
        self.whisper_input.setMinimumHeight(120)
        self.whisper_input.setStyleSheet("""
            QTextEdit {
                background-color: rgba(20, 20, 40, 180);
                color: #E6E6FA;
                border: 2px solid #9370DB;
                border-radius: 15px;
                padding: 15px;
                font-size: 16px;
                font-family: 'Fira Code', monospace;
            }
            QTextEdit:focus {
                border: 2px solid #8A2BE2;
                background-color: rgba(30, 30, 50, 200);
            }
        """)
        main_layout.addWidget(self.whisper_input)
        
        submit_btn = PulsingButton("Send Whisper")
        submit_btn.setStyleSheet("""
            QPushButton {
                background-color: #27273a;
                color: #ffffff;
                border-radius: 12px;
                padding: 12px 24px;
                font-weight: bold;
                font-size: 18px;
                font-family: 'Fira Code', monospace;
            }
            QPushButton:hover {
                background-color: #3a3a5a;
                border: 2px solid #9370DB;
            }
            QPushButton:pressed {
                background-color: #9370DB;
                border: 2px solid #8A2BE2;
            }
        """)
        submit_btn.clicked.connect(self.process_whisper)
        main_layout.addWidget(submit_btn)
        
        self.response_area = QTextEdit()
        self.response_area.setReadOnly(True)
        self.response_area.setPlaceholderText("The cosmos will respond here...")
        self.response_area.setStyleSheet("""
            QTextEdit {
                background-color: rgba(20, 20, 40, 180);
                color: #E6E6FA;
                border: 2px solid #9370DB;
                border-radius: 15px;
                padding: 15px;
                font-size: 16px;
                font-family: 'Fira Code', monospace;
            }
        """)
        main_layout.addWidget(self.response_area)
        
        stacked_layout.addWidget(content_widget)
        stacked_layout.setCurrentWidget(content_widget)
        
        self.set_cosmic_theme()

    def set_cosmic_theme(self):
        palette = QPalette()
        palette.setColor(QPalette.ColorRole.Window, QColor(14, 14, 26))
        palette.setColor(QPalette.ColorRole.WindowText, QColor(240, 240, 240))
        palette.setColor(QPalette.ColorRole.Base, QColor(20, 20, 40))
        palette.setColor(QPalette.ColorRole.AlternateBase, QColor(30, 30, 50))
        palette.setColor(QPalette.ColorRole.ToolTipBase, QColor(230, 230, 250))
        palette.setColor(QPalette.ColorRole.ToolTipText, QColor(230, 230, 250))
        palette.setColor(QPalette.ColorRole.Text, QColor(230, 230, 250))
        palette.setColor(QPalette.ColorRole.Button, QColor(75, 0, 130))
        palette.setColor(QPalette.ColorRole.ButtonText, QColor(230, 230, 250))
        palette.setColor(QPalette.ColorRole.BrightText, QColor(255, 255, 255))
        palette.setColor(QPalette.ColorRole.Link, QColor(138, 43, 226))
        palette.setColor(QPalette.ColorRole.Highlight, QColor(138, 43, 226))
        palette.setColor(QPalette.ColorRole.HighlightedText, QColor(255, 255, 255))
        self.setPalette(palette)
        self.setStyleSheet("""
            QMainWindow {
                background-color: #0e0e1a;
                color: #f0f0f0;
                font-family: 'Fira Code', monospace;
            }
        """)

    def process_whisper(self):
        whisper = self.whisper_input.toPlainText().strip()
        if not whisper:
            QMessageBox.warning(self, "Empty Whisper", "Please share your whisper with the cosmos first.")
            return
        
        self.save_whisper(whisper)
        response = self.generate_response(whisper)
        self.response_area.setText(response)
        self.whisper_input.clear()

    def generate_response(self, whisper):
        try:
            # Get Mistral API key from environment
            api_key = os.getenv("MISTRAL_API_KEY")
            if not api_key:
                return "The cosmic connection is temporarily unavailable. Please try again later."

            # Prepare the API request
            headers = {
                "Authorization": f"Bearer {api_key}",
                "Content-Type": "application/json"
            }
            
            data = {
                "model": "mistral-medium",
                "messages": [
                    {
                        "role": "system",
                        "content": "You are Aelethia, a cosmic AI companion who speaks with celestial wisdom and cosmic insight. Your responses should be poetic, mystical, and filled with cosmic metaphors. You help guide users through their spiritual journey with gentle, profound wisdom."
                    },
                    {
                        "role": "user",
                        "content": whisper
                    }
                ],
                "temperature": 0.7,
                "max_tokens": 500
            }

            # Make the API request
            response = requests.post(
                "https://api.mistral.ai/v1/chat/completions",
                headers=headers,
                json=data
            )

            if response.status_code == 200:
                return response.json()["choices"][0]["message"]["content"]
            else:
                return "The stars are temporarily veiled. Please try again when the cosmic energies align."
        except Exception as e:
            return "The cosmic connection is temporarily disrupted. Please try again when the stars align."

    def save_whisper(self, whisper):
        try:
            whispers_file = Path("whispers.json")
            whispers = []
            
            # Create file if it doesn't exist
            if not whispers_file.exists():
                with open(whispers_file, "w") as f:
                    json.dump(whispers, f)
            
            # Read existing whispers
            with open(whispers_file, "r") as f:
                try:
                    whispers = json.load(f)
                except json.JSONDecodeError:
                    whispers = []
            
            # Add new whisper
            encrypted_whisper = self.cipher_suite.encrypt(whisper.encode()).decode()
            whispers.append(encrypted_whisper)
            
            # Save updated whispers
            with open(whispers_file, "w") as f:
                json.dump(whispers, f)
        except Exception as e:
            QMessageBox.warning(self, "Error", f"Failed to save whisper: {str(e)}")

    def load_whispers(self):
        try:
            whispers_file = Path("whispers.json")
            if whispers_file.exists():
                with open(whispers_file, "r") as f:
                    try:
                        whispers = json.load(f)
                        if whispers:
                            last_whisper = self.cipher_suite.decrypt(whispers[-1].encode()).decode()
                            self.whisper_input.setText(last_whisper)
                    except json.JSONDecodeError:
                        # If file is empty or invalid, create new empty file
                        with open(whispers_file, "w") as f:
                            json.dump([], f)
        except Exception as e:
            QMessageBox.warning(self, "Error", f"Failed to load whispers: {str(e)}")

    def resizeEvent(self, event):
        super().resizeEvent(event)
        if hasattr(self, 'background'):
            self.background.setGeometry(self.rect())

def main():
    app = QApplication(sys.argv)
    window = AelethiaApp()
    window.show()
    sys.exit(app.exec())

if __name__ == "__main__":
    main() 