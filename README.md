

<h1 align="center">💊 Pills Reminder </h1>

<p align="center">
  A modern medication reminder app built with Flutter, following Clean Architecture principles. It leverages GetX for scalable state management, Hive for lightning-fast local storage, and Flutter Local Notifications for precise scheduling.
</p>

---

## 🧠 Architecture

This project uses the **Clean Architecture** pattern to separate concerns and ensure scalability.

```
lib/
├── core/               # Common utilities and services
├── features/           # Feature-based modules
│   ├── data/           # Data sources, models, Repositories implementations, and Hive integration
│   ├── domain/         # Entities and abstract definitions
│   └── presentation/   # UI, GetX controllers, and bindings
├── main.dart           # App entry point
```

---

## 🚀 Features

- ⏰ **Schedule custom medication reminders**
- 📅 **Supports one-time, daily, or weekly notifications**
- 🧠 **Clean architecture & GetX-based controllers**
- ⚡ **Blazing fast local storage with Hive**
- 🔔 **Precise local notifications using Flutter Local Notifications**
- 🌗 **Dark & light theme support**
- ✅ **Offline-first experience**

---

## 📱 Screenshots

<div align="center">

| Light Mode                                                                                                           | Dark Mode                                                                                                        |
|:---------------------------------------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------------------:|
| <img src="https://github.com/user-attachments/assets/a656e209-d623-4b43-9eba-68db6bd3b55b" width="300">               | <img src="https://github.com/user-attachments/assets/a58d306e-bf12-457e-8dad-368fcd3d0b5b" width="300">               |
| <img src="https://github.com/user-attachments/assets/37cdc07e-275e-461e-b411-f3e6c1a693f8" width="300">               | <img src="https://github.com/user-attachments/assets/2811acf3-6577-42f3-8bb9-58bcd848ccef" width="300">               |
| <img src="https://github.com/user-attachments/assets/d8565bf3-1391-401d-a866-67e171af2508" width="300">               | <img src="https://github.com/user-attachments/assets/488628b1-3cf9-4475-9536-e091d915cbac" width="300">               |

</div>

---

## 🛠️ Tech Stack

<div align="center">

| Tech | Role |
|------|------|
| Flutter | UI Framework |
| GetX | State Management + Dependency Injection |
| Hive | NoSQL Local Storage |
| Flutter Local Notifications | Scheduling & displaying reminders |
| Custom Widgets | Fully reusable UI components |

</div>

---

## 📦 Packages Used

```yaml
dependencies:
  get: ^4.7.2
  hive_ce_flutter: ^2.3.1
  path_provider: ^2.1.5
  flutter_local_notifications: ^19.4.0
  timezone: ^0.10.1
  flutter_timezone: ^4.1.1
  permission_handler: ^12.0.1
```

---

## ▶️ Getting Started

1. **Clone the repo**
   ```bash
   git clone https://github.com/MoazSalem/Flutter_Pills_Reminder.git
   cd pills_reminder
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive Type Adapters (if needed)**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 🧠 Project Philosophy

- ✅ **Clean**: Every layer has its own responsibility  
- ⚙️ **Modular**: Easy to extend and maintain  
- ⚡ **Performant**: Lightweight and fast, even on low-end devices  

---

## 📦 Releases

 You can download the latest APK builds from the [Releases](https://github.com/MoazSalem/Flutter_Pills_Reminder/releases) section.

---

## 🤝 Contributing

Feel free to fork the project and open PRs! Whether it’s a bug fix, UI enhancement, or feature suggestion — **contributions are welcome**.

---

## 🧾 License

MIT License © 2025 [Moaz Salem](https://github.com/MoazSalem)

---

## ⭐ Show Your Support

If you like this project:

- ⭐ Star the repo  
- 🐛 Submit issues or features  
- 📢 Share with others

Feel free to suggest or request features via [issues](https://github.com/MoazSalem/Flutter_Pills_Reminder/issues)!

---

## 🛠️ To Be Done

- ❇️ Improvments and New Features

- 🔄 Write Tests


---


