# VaultMesh Flutter X

**A Secure, Offline-First Flutter App for Managing Sensitive Data**

---

## **Features**

✅ **Master Password Authentication** (Argon2id + AES-256-GCM)
✅ **Biometric Unlock** (Fingerprint/Face ID)
✅ **Modular Vault System** (Passwords, Notes, API Keys, Documents, Links, Other Secrets)
✅ **Auto-lock, Clipboard Clear, Screenshot Protection**
✅ **Password Generator**
✅ **Encrypted Backup & Import/Export**
✅ **Local Network Sync via QR Code & WebSocket**
✅ **Auto-Update Checker**
✅ **Modern Material 3 UI/UX**

---

## **Screenshots**

| Login Screen | Dashboard | Passwords Vault |
|--------------|-----------|-----------------|
| ![Login Screen](assets/screenshots/login.png) | ![Dashboard](assets/screenshots/dashboard.png) | ![Passwords Vault](assets/screenshots/passwords.png) |

---

## **Installation**

### **Prerequisites**
- Flutter SDK (>=3.0.0)
- Android Studio / Xcode (for mobile builds)
- Linux/macOS/Windows (for desktop builds)

### **Steps**
1. Clone the repository:
   ```bash
   git clone https://github.com/abdulraheemnohri/VaultMesh-.git
   cd VaultMesh-
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

---

## **Building for All Platforms**

To build the app for all platforms, use the provided script:

```bash
chmod +x build_all.sh
./build_all.sh
```

This will generate builds for:
- **Android** (APK, AppBundle)
- **iOS** (IPA)
- **Linux** (AppImage, Deb)
- **Windows** (EXE)
- **macOS** (DMG, App)

---

## **Local Network Sync**

VaultMesh Flutter X supports **local network sync** between devices using **QR codes** and **WebSocket**. To sync data between devices:

1. Open the **Sync Screen** from the dashboard.
2. Start the **WebSocket server** on one device.
3. Scan the **QR code** from another device to connect and sync data.

---

## **Auto-Update Checker**

The app automatically checks for updates on startup using the **GitHub Releases API**. If a new version is available, users are notified and can update directly from the GitHub releases page.

---

## **Security**

- **AES-256-GCM** encryption for all stored data.
- **Biometric authentication** for quick and secure access.
- **Auto-lock** after inactivity.
- **Clipboard auto-clear** to prevent data leakage.
- **Screenshot protection** to prevent sensitive data capture.

---

## **Contributing**

Contributions are welcome! Please open an issue or submit a pull request.

---

## **License**

This project is licensed under the **MIT License**.