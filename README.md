

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
- 🎯 **Notifications Persistence to never miss your pills**
- 🧠 **Clean architecture & GetX-based controllers**
- ⚡ **Blazing fast local storage with Hive**
- 🔔 **Precise local notifications using Flutter Local Notifications**
- 🦾 **Notification Actions to make life easier**
- 📱 **Full English and Arabic Translations**
- 🌗 **Dark & light theme support**
- ✅ **Offline-first experience**

---

## 📱 Screenshots

<div align="center">

| Light Mode                                                                                                           | Dark Mode                                                                                                        |
|:---------------------------------------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------------------:|
| <img src="https://github.com/user-attachments/assets/adf3c1cf-a773-47a2-89dd-f67084660539" width="300">               | <img src="https://github.com/user-attachments/assets/66112320-5380-4bcc-8786-d272965869c8" width="300">               |
| <img src="https://github.com/user-attachments/assets/8d1dac5c-b159-45d8-b450-19eae9023dd6" width="300">               | <img src="https://github.com/user-attachments/assets/052d19a8-8463-4d18-a355-21bcf0a8f7d1" width="300">               |
| <img src="https://github.com/user-attachments/assets/84cb4573-c10d-4f20-a3df-890bfede30a1" width="300">               | <img src="https://github.com/user-attachments/assets/5a9a685f-3b20-4f81-9055-7d767dc60894" width="300">               |
| <img src="https://github.com/user-attachments/assets/956b39c1-3e25-424b-b361-27b783fcd140" width="300">               | <img src="https://github.com/user-attachments/assets/12917e21-d39f-4a0a-a2be-348f59416323" width="300">               |
| <img src="https://github.com/user-attachments/assets/4e988582-c20e-429a-8da4-afefebd5ac25" width="300">               | <img src="https://github.com/user-attachments/assets/f711df3b-51bc-4f9e-b40e-acb67050ad01" width="300">               |
| <img src="https://github.com/user-attachments/assets/4ddfd49f-79c5-451a-87bd-836d0658bbea" width="300">               | <img src="https://github.com/user-attachments/assets/21341588-3d4a-49fd-8869-984c328c2e17" width="300">               |
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

 <p>
  <a href="https://play.google.com/store/apps/details?id=com.moazsalem.pills_reminder" target="_blank">
  <img src="https://github.com/user-attachments/assets/103a79d8-5189-46fc-b8af-2584d3ff238a" alt="Google_Play_Store_badge" />
    </a>
</p>

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


