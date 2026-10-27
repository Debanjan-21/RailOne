# RailOne Indian Railways Clone (Flutter & Android Studio)

A pixel-perfect clone of the official Indian Railways **RailOne (CRIS)** super-app, built using **Flutter** and configured for **Android Studio**.

---

## 🚆 Key Features

### 1. First Page: Station Selection & Route Configuration
- **Source Station Selector**: Choose from major Indian Railways stations across all railway zones (with Station Codes, English names, and Hindi names).
- **Destination Station Selector**: Choose destination with instant validation preventing matching stations.
- **Station Swap Feature**: Interactive 180° rotation swap button to quickly flip source and destination.
- **Modal Search Sheet**: Live search by station code (e.g. `NDLS`, `HWH`, `CSMT`), English name, Hindi name, or city.
- **Quick Popular Routes**: Instant preset chips (New Delhi ➔ Howrah, Mumbai ➔ Pune, Chennai ➔ Bengaluru, Howrah ➔ Puri).
- **Journey Configuration**: Train type (Ordinary, Mail/Express, Superfast), Travel class (Second Class II, First Class FC), and Adult/Child passenger counters.
- **Prominent PROCEED Button**: Initiates instant automatic ticket generation for the selected route.

### 2. Second Page: Official RailOne Booked Ticket View
- **Automatic Current Date & Time**: Dynamically timestamps the ticket to the exact moment of booking (e.g. `09/10/2026 20:45 hrs`).
- **Dynamic Validity**: Shows valid time window (3 hours from booking time).
- **Live Anti-Screenshot Security Ribbon**: Live ticking seconds counter (`dd/MM/yyyy HH:mm:ss`) with a pulsing green indicator to prove authentic in-app status during TTE checking.
- **CRIS / Indian Railways Security Watermark**: Diagonal textured background watermark (`CRIS • भारतीय रेल • UTS`).
- **UTS Number Generator**: Realistic 10-character alphanumeric UTS number (e.g., `0A82F19830`).
- **Authentic Journey Header**: Indian Railways Crest, "INDIAN RAILWAYS / भारतीय रेल", "CENTRE FOR RAILWAY INFORMATION SYSTEMS (CRIS)", and "HAPPY JOURNEY / शुभ यात्रा".
- **Ticket Attributes Matrix**: Class (`SECOND (II)`), Type (`JOURNEY (J)`), Train (`MAIL/EXP`), Route (`VIA DIRECT`), Distance, Fare in figures and words (`Rupees Thirty Five Only`).
- **High-Density Matrix QR Code**: Embedded CRIS verification QR payload. Tap to view high-contrast full-screen QR for TTE scanning.
- **Official Legal Disclaimer**: Standard warning against static screenshots or printouts.

---

## 📁 Project Structure

```
h:/RsilOne-Copy/
├── pubspec.yaml                          # Flutter package definitions
├── analysis_options.yaml                 # Flutter linter configuration
├── README.md                             # Project documentation
├── preview/
│   └── index.html                        # Instant interactive browser companion
├── android/                              # Native Android Studio Project
│   ├── build.gradle
│   ├── settings.gradle
│   ├── gradle.properties
│   └── app/
│       ├── build.gradle
│       └── src/main/
│           ├── AndroidManifest.xml
│           ├── res/values/styles.xml
│           └── kotlin/com/cris/railone/MainActivity.kt
└── lib/                                  # Flutter Source Code
    ├── main.dart                         # App entrypoint and RailOne Theme
    ├── constants/
    │   └── rail_colors.dart              # Official CRIS & RailOne color tokens
    ├── models/
    │   ├── station.dart                  # Station data structure
    │   └── ticket.dart                   # Ticket generator & fare logic
    ├── data/
    │   └── indian_stations.dart          # Comprehensive Indian Railways station list
    ├── screens/
    │   ├── station_selection_screen.dart # First page: Station selection & Proceed
    │   └── booked_ticket_screen.dart     # Second page: RailOne UTS booked ticket
    └── widgets/
        ├── cris_watermark.dart           # Custom security watermark painter
        ├── live_security_ribbon.dart     # Live ticking anti-fraud clock
        ├── station_search_sheet.dart     # Search modal with instant filter
        └── ticket_qr_widget.dart         # Realistic matrix QR code widget
```

---

## 🛠️ How to Open and Run in Android Studio

1. **Open Android Studio**:
   - Click **File** ➔ **Open...**
   - Navigate to and select the directory: `H:\RsilOne-Copy`
   - Click **OK**.

2. **Ensure Flutter and Dart Plugins are Enabled**:
   - In Android Studio, go to **Settings** (or **Preferences**) ➔ **Plugins**.
   - Make sure **Flutter** and **Dart** plugins are installed and enabled.

3. **Fetch Dependencies**:
   - In the terminal inside Android Studio (or your command prompt):
     ```bash
     flutter pub get
     ```

4. **Run the App**:
   - Connect an Android device with USB debugging enabled, or launch an Android Virtual Device (AVD).
   - Select your device in Android Studio's device selector dropdown at the top toolbar.
   - Click the green **Run ▶** button (or press `Shift + F10`).

---

## 🌐 Instant Interactive Web Preview

You can also preview and test the complete interaction right away in any browser:
- Open `preview/index.html` in your web browser (e.g. Chrome, Edge) by double-clicking it or serving it locally.
- Test selecting source & destination stations, swapping stations, filtering stations, and clicking **PROCEED** to view the live RailOne ticket.
