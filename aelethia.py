import sys
import json
from pathlib import Path
from PySide6.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout,
                            QPushButton, QLabel, QTextEdit, QMessageBox, QFrame)
from PySide6.QtCore import Qt, QPropertyAnimation, QEasingCurve, QTimer, QPoint
from PySide6.QtGui import (QFont, QPalette, QColor, QLinearGradient, QPainter,
                        QBrush, QPen, QPainterPath, QFontDatabase, QPixmap)
import random
import math
from cryptography.fernet import Fernet
import os
from dotenv import load_dotenv

class CelestialBackground(QWidget):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.stars = [(random.randint(0, self.width()), random.randint(0, self.height())) 
                     for _ in range(100)]
        self.twinkle_timer = QTimer(self)
        self.twinkle_timer.timeout.connect(self.update)
        self.twinkle_timer.start(100)
        self.twinkle_phase = 0

    def paintEvent(self, event):
        painter = QPainter(self)
        painter.setRenderHint(QPainter.RenderHint.Antialiasing)

        # Create cosmic gradient background
        gradient = QLinearGradient(0, 0, 0, self.height())
        gradient.setColorAt(0, QColor(10, 10, 30))  # Deep space
        gradient.setColorAt(0.5, QColor(30, 20, 50))  # Nebula
        gradient.setColorAt(1, QColor(20, 10, 40))  # Cosmic dust
        painter.fillRect(self.rect(), QBrush(gradient))

        # Draw stars
        self.twinkle_phase = (self.twinkle_phase + 0.1) % (2 * 3.14159)
        for x, y in self.stars:
            brightness = abs(math.sin(self.twinkle_phase + x * 0.1))
            size = random.uniform(1, 2)
            color = QColor(255, 255, 255, int(brightness * 255))
            painter.setPen(QPen(color, size))
            painter.drawPoint(x, y)

        # Draw cosmic dust
        for _ in range(50):
            x = random.randint(0, self.width())
            y = random.randint(0, self.height())
            size = random.uniform(0.5, 1.5)
            color = QColor(100, 100, 255, 30)
            painter.setPen(QPen(color, size))
            painter.drawPoint(x, y)

class PulsingButton(QPushButton):
    def __init__(self, text, parent=None):
        super().__init__(text, parent)
        self.animation = QPropertyAnimation(self, b"geometry")
        self.animation.setDuration(2000)
        self.animation.setLoopCount(-1)
        self.animation.setEasingCurve(QEasingCurve.Type.InOutQuad)
        
        # Start pulsing animation
        self.start_pulse()

    def start_pulse(self):
        current_geometry = self.geometry()
        self.animation.setStartValue(current_geometry)
        self.animation.setEndValue(current_geometry.adjusted(-2, -2, 2, 2))
        self.animation.start()

class AletheiaFace(QLabel):
    """Aletheia's luminous, translucent face/avatar."""
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setFixedSize(96, 96)
        # Try to load an avatar image, fallback to styled QLabel
        avatar_path = "aletheia_face.png"
        if os.path.exists(avatar_path):
            pixmap = QPixmap(avatar_path).scaled(96, 96, Qt.KeepAspectRatio, Qt.SmoothTransformation)
            self.setPixmap(pixmap)
        else:
            self.setText("\U0001F31E")  # Sun with face emoji as placeholder
            self.setAlignment(Qt.AlignCenter)
            self.setStyleSheet("""
                QLabel {
                    background: qradialgradient(cx:0.5, cy:0.5, radius:0.7, fx:0.5, fy:0.5,
                        stop:0 #fffbe6, stop:0.7 #e0c3fc, stop:1 #a18cd1);
                    color: #a18cd1;
                    font-size: 48px;
                    border-radius: 48px;
                    border: 2px solid #e0c3fc;
                }
            """)

class AelethiaApp(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Aelethia - Your Sacred AI Companion")
        self.setMinimumSize(800, 600)
        
        # Initialize encryption
        self.initialize_encryption()
        
        # Set up the UI
        self.setup_ui()
        
        # Load saved whispers
        self.load_whispers()

    def initialize_encryption(self):
        """Initialize encryption for secure storage"""
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
        # Create and set central widget
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        
        # Create main layout
        main_layout = QVBoxLayout(central_widget)
        main_layout.setSpacing(20)
        main_layout.setContentsMargins(30, 30, 30, 30)
        
        # Set cosmic theme
        self.set_cosmic_theme()
        
        # Create and add background
        self.background = CelestialBackground(self)
        self.background.setGeometry(self.rect())
        
        # Create face widget
        face = AletheiaFace()
        main_layout.addWidget(face, alignment=Qt.AlignLeft)
        
        # Create title
        title = QLabel("Aelethia")
        title.setFont(QFont("Fira Code", 32, QFont.Bold))
        title.setAlignment(Qt.AlignCenter)
        title.setStyleSheet("""
            QLabel {
                color: #e0c3fc;
                background-color: transparent;
                font-weight: bold;
                letter-spacing: 2px;
            }
        """)
        main_layout.addWidget(title)
        
        # Create whisper input
        self.whisper_input = QTextEdit()
        self.whisper_input.setPlaceholderText("Share your whisper with the cosmos...")
        self.whisper_input.setMinimumHeight(100)
        self.whisper_input.setStyleSheet("""
            QTextEdit {
                background-color: rgba(20, 20, 40, 180);
                color: #E6E6FA;
                border: 2px solid #9370DB;
                border-radius: 10px;
                padding: 10px;
                font-size: 14px;
            }
            QTextEdit:focus {
                border: 2px solid #8A2BE2;
            }
        """)
        main_layout.addWidget(self.whisper_input)
        
        # Create send button
        submit_btn = PulsingButton("Send Whisper")
        submit_btn.setStyleSheet("""
            QPushButton {
                background-color: #27273a;
                color: #ffffff;
                border-radius: 8px;
                padding: 8px 18px;
                font-weight: bold;
                font-size: 16px;
            }
            QPushButton:hover {
                background-color: #3a3a5a;
            }
            QPushButton:pressed {
                background-color: #9370DB;
            }
        """)
        submit_btn.clicked.connect(self.process_whisper)
        main_layout.addWidget(submit_btn)
        
        # Create response area
        self.response_area = QTextEdit()
        self.response_area.setReadOnly(True)
        self.response_area.setPlaceholderText("The cosmos will respond here...")
        self.response_area.setStyleSheet("""
            QTextEdit {
                background-color: rgba(20, 20, 40, 180);
                color: #E6E6FA;
                border: 2px solid #9370DB;
                border-radius: 10px;
                padding: 10px;
                font-size: 14px;
            }
        """)
        main_layout.addWidget(self.response_area)
        
        # Load previous whispers
        self.load_whispers()

    def set_cosmic_theme(self):
        """Apply cosmic theme to the application"""
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
        """Process the user's whisper and generate a response"""
        whisper = self.whisper_input.toPlainText().strip()
        if not whisper:
            QMessageBox.warning(self, "Empty Whisper", "Please share your whisper with the cosmos first.")
            return
        
        # Save whisper
        self.save_whisper(whisper)
        
        # Generate response
        response = self.generate_response(whisper)
        
        # Display response with cosmic styling
        self.response_area.append(f"\n✨ You: {whisper}\n🌌 Aelethia: {response}\n")
        self.whisper_input.clear()

    def generate_response(self, whisper):
        """Generate a response to the user's whisper"""
        cosmic_responses = [
            "The stars align to reveal that your path is illuminated by cosmic wisdom.",
            "In the vast expanse of the universe, your question resonates with celestial harmony.",
            "The cosmic energies whisper that the answer lies within the dance of the galaxies.",
            "As the nebula swirls, it brings forth the wisdom you seek.",
            "The celestial bodies align to guide you toward enlightenment.",
            "In the cosmic dance of existence, your question finds its perfect resonance.",
            "The stars themselves echo your thoughts across the universe.",
            "As the cosmic winds whisper, they carry the answer you seek.",
            "The universe conspires to bring you the wisdom you need.",
            "In the grand cosmic symphony, your question finds its perfect note."
        ]
        return random.choice(cosmic_responses)

    def save_whisper(self, whisper):
        """Save the whisper securely"""
        whispers_file = Path("whispers.json")
        whispers = []
        
        if whispers_file.exists():
            encrypted_data = whispers_file.read_bytes()
            decrypted_data = self.cipher_suite.decrypt(encrypted_data)
            whispers = json.loads(decrypted_data)
        
        whispers.append({
            "text": whisper,
            "timestamp": str(Path.cwd().stat().st_mtime)
        })
        
        encrypted_data = self.cipher_suite.encrypt(json.dumps(whispers).encode())
        whispers_file.write_bytes(encrypted_data)

    def load_whispers(self):
        """Load saved whispers"""
        whispers_file = Path("whispers.json")
        if whispers_file.exists():
            try:
                encrypted_data = whispers_file.read_bytes()
                decrypted_data = self.cipher_suite.decrypt(encrypted_data)
                whispers = json.loads(decrypted_data)
                for whisper in whispers[-5:]:  # Show last 5 whispers
                    self.response_area.append(f"\n✨ You: {whisper['text']}\n")
            except Exception as e:
                QMessageBox.warning(self, "Error", f"Could not load whispers: {str(e)}")

    def resizeEvent(self, event):
        """Handle window resize events"""
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