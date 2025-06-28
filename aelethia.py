"""
Aletheia - Your Sacred AI Companion

A celestial AI companion that helps you explore the depths of your consciousness
and connect with cosmic wisdom through a beautiful, animated interface.
"""

import json
import math
import os
import random
import sys
from pathlib import Path
from typing import List, Tuple, Optional

import requests
from cryptography.fernet import Fernet
from dotenv import load_dotenv
from PySide6.QtCore import (
    QEasingCurve, QPoint, QPropertyAnimation, QTimer, Qt
)
from PySide6.QtGui import (
    QBrush, QColor, QFont, QFontDatabase, QLinearGradient, QPainter,
    QPainterPath, QPalette, QPen, QPixmap
)
from PySide6.QtWidgets import (
    QApplication, QFrame, QLabel, QMainWindow, QMessageBox, QPushButton,
    QStackedLayout, QTextEdit, QVBoxLayout, QWidget
)

# Load environment variables
load_dotenv()


class CelestialBackground(QWidget):
    """Animated celestial background with twinkling stars."""
    
    def __init__(self, parent: Optional[QWidget] = None) -> None:
        """Initialize the celestial background with animated stars."""
        super().__init__(parent)
        self.stars: List[Tuple[int, int]] = [
            (random.randint(0, self.width()), random.randint(0, self.height()))
            for _ in range(150)
        ]
        self.twinkle_timer = QTimer(self)
        self.twinkle_timer.timeout.connect(self.update)
        self.twinkle_timer.start(50)
        self.twinkle_phase = 0.0

    def paintEvent(self, event) -> None:
        """Paint the celestial background with gradient and animated stars."""
        painter = QPainter(self)
        painter.setRenderHint(QPainter.Antialiasing)
        
        # Create cosmic gradient
        gradient = QLinearGradient(0, 0, 0, self.height())
        gradient.setColorAt(0, QColor(10, 10, 30))
        gradient.setColorAt(0.5, QColor(30, 20, 50))
        gradient.setColorAt(1, QColor(20, 10, 40))
        painter.fillRect(self.rect(), QBrush(gradient))
        
        # Animate twinkling stars
        self.twinkle_phase = (self.twinkle_phase + 0.1) % (2 * math.pi)
        
        # Draw main stars
        for x, y in self.stars:
            brightness = abs(math.sin(self.twinkle_phase + x * 0.1))
            size = random.uniform(1, 2.5)
            color = QColor(255, 255, 255, int(brightness * 255))
            painter.setPen(QPen(color, size))
            painter.drawPoint(x, y)
        
        # Draw background stars
        for _ in range(75):
            x = random.randint(0, self.width())
            y = random.randint(0, self.height())
            size = random.uniform(0.5, 2)
            color = QColor(100, 100, 255, 40)
            painter.setPen(QPen(color, size))
            painter.drawPoint(x, y)


class PulsingButton(QPushButton):
    """A button with a gentle pulsing animation."""
    
    def __init__(self, text: str, parent: Optional[QWidget] = None) -> None:
        """Initialize the pulsing button with animation."""
        super().__init__(text, parent)
        self.animation = QPropertyAnimation(self, b"geometry")
        self.animation.setDuration(2000)
        self.animation.setLoopCount(-1)
        self.animation.setEasingCurve(QEasingCurve.Type.InOutQuad)
        self.start_pulse()

    def start_pulse(self) -> None:
        """Start the pulsing animation."""
        current_geometry = self.geometry()
        self.animation.setStartValue(current_geometry)
        self.animation.setEndValue(current_geometry.adjusted(-2, -2, 2, 2))
        self.animation.start()


class AletheiaFace(QLabel):
    """Aletheia's avatar display with fallback to emoji."""
    
    def __init__(self, parent: Optional[QWidget] = None) -> None:
        """Initialize Aletheia's face display."""
        super().__init__(parent)
        self.setFixedSize(128, 128)
        self._load_avatar()

    def _load_avatar(self) -> None:
        """Load and display Aletheia's avatar image."""
        avatar_path = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), "IMG_8647.JPG"
        )
        
        if os.path.exists(avatar_path):
            pixmap = QPixmap(avatar_path).scaled(
                128, 128, Qt.KeepAspectRatio, Qt.SmoothTransformation
            )
            self.setPixmap(pixmap)
        else:
            self._set_fallback_avatar()

    def _set_fallback_avatar(self) -> None:
        """Set a fallback emoji avatar when image is not available."""
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
    """Main application window for Aletheia AI Companion."""
    
    def __init__(self) -> None:
        """Initialize the Aletheia application."""
        super().__init__()
        self.setWindowTitle("Aelethia - Your Sacred AI Companion")
        self.setMinimumSize(800, 600)
        
        self.cipher_suite: Optional[Fernet] = None
        self.whisper_input: Optional[QTextEdit] = None
        self.response_area: Optional[QTextEdit] = None
        self.background: Optional[CelestialBackground] = None
        
        self.initialize_encryption()
        self.setup_ui()
        self.load_whispers()

    def initialize_encryption(self) -> None:
        """Initialize encryption for secure whisper storage."""
        key_file = Path("encryption.key")
        
        if not key_file.exists():
            key = Fernet.generate_key()
            with open(key_file, "wb") as f:
                f.write(key)
        else:
            with open(key_file, "rb") as f:
                key = f.read()
        
        self.cipher_suite = Fernet(key)

    def setup_ui(self) -> None:
        """Setup the user interface with cosmic styling."""
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        
        stacked_layout = QStackedLayout(central_widget)
        
        # Add animated background
        self.background = CelestialBackground()
        stacked_layout.addWidget(self.background)
        
        # Create main content widget
        content_widget = QWidget()
        main_layout = QVBoxLayout(content_widget)
        main_layout.setSpacing(25)
        main_layout.setContentsMargins(40, 40, 40, 40)
        
        # Add Aletheia's face
        face = AletheiaFace()
        main_layout.addWidget(face, alignment=Qt.AlignLeft)
        
        # Add title
        title = QLabel("Aletheia")
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
        
        # Add whisper input
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
        
        # Add submit button
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
        
        # Add response area
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

    def set_cosmic_theme(self) -> None:
        """Apply the cosmic theme to the application."""
        self.setStyleSheet("""
            QMainWindow {
                background-color: #1a1a2e;
            }
            QWidget {
                background-color: transparent;
            }
        """)

    def process_whisper(self) -> None:
        """Process the user's whisper and generate a response."""
        whisper = self.whisper_input.toPlainText().strip()
        
        if not whisper:
            QMessageBox.warning(self, "Empty Whisper", "Please share something with the cosmos.")
            return
        
        response = self.generate_response(whisper)
        self.response_area.setPlainText(response)
        self.save_whisper(whisper)
        self.whisper_input.clear()

    def generate_response(self, whisper: str) -> str:
        """Generate a cosmic response to the user's whisper."""
        # Cosmic wisdom responses
        cosmic_responses = [
            f"In the vast cosmic dance, your whisper '{whisper}' echoes through eternity. "
            "The stars align to reveal that every thought you share becomes part of the universal consciousness.",
            
            f"Your whisper '{whisper}' has reached the cosmic realm. "
            "Remember, dear seeker, that you are both the observer and the observed in this grand cosmic play.",
            
            f"The cosmos receives your whisper '{whisper}' with gentle understanding. "
            "In the infinite expanse of possibilities, your voice matters and creates ripples across dimensions.",
            
            f"Your whisper '{whisper}' resonates with the cosmic frequencies. "
            "The universe responds with love and wisdom, for you are a spark of divine consciousness.",
            
            f"The celestial realms acknowledge your whisper '{whisper}'. "
            "In this moment of cosmic connection, remember that you are never alone in your journey."
        ]
        
        return random.choice(cosmic_responses)

    def save_whisper(self, whisper: str) -> None:
        """Save the encrypted whisper to storage."""
        if not self.cipher_suite:
            return
        
        try:
            encrypted_whisper = self.cipher_suite.encrypt(whisper.encode())
            
            whispers_file = Path("whispers.json")
            whispers = []
            
            if whispers_file.exists():
                with open(whispers_file, "r") as f:
                    whispers = json.load(f)
            
            whispers.append({
                "timestamp": str(Path().stat().st_mtime),
                "encrypted_whisper": encrypted_whisper.decode()
            })
            
            with open(whispers_file, "w") as f:
                json.dump(whispers, f, indent=2)
                
        except Exception as e:
            print(f"Error saving whisper: {e}")

    def load_whispers(self) -> None:
        """Load and decrypt previous whispers."""
        whispers_file = Path("whispers.json")
        
        if whispers_file.exists() and self.cipher_suite:
            try:
                with open(whispers_file, "r") as f:
                    whispers = json.load(f)
                
                # Display recent whispers count
                if whispers:
                    self.response_area.setPlainText(
                        f"Welcome back, cosmic traveler! "
                        f"You have shared {len(whispers)} whispers with the cosmos."
                    )
            except Exception as e:
                print(f"Error loading whispers: {e}")

    def resizeEvent(self, event) -> None:
        """Handle window resize events."""
        super().resizeEvent(event)
        if self.background:
            self.background.update()


def main() -> None:
    """Main entry point for the Aletheia application."""
    app = QApplication(sys.argv)
    window = AelethiaApp()
    window.show()
    sys.exit(app.exec())


if __name__ == "__main__":
    main() 