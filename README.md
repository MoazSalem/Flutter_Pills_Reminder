

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
- 🎯 **Notifcations Presistance to never miss your pills**
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
| <img src="https://github.com/user-attachments/assets/eca6371a-17aa-455a-abc0-1eb79f58c9ff" width="300">               | <img src="https://github.com/user-attachments/assets/0dccd0b9-03bf-4ff5-904d-a9a9b24114bf" width="300">               |
| <img src="https://github.com/user-attachments/assets/c660351a-633d-495b-9752-4a5fc2362bd9" width="300">               | <img src="https://github.com/user-attachments/assets/bc34c485-2770-4f3b-8534-e9e5993bcf88" width="300">               |
| <img src="https://github.com/user-attachments/assets/8901093f-9d33-4e19-b34a-f021084549d3" width="300">               | <img src="https://github.com/user-attachments/assets/eba14a5b-4ec2-4242-99c4-81693bd60910" width="300">               |
| <img src="https://github.com/user-attachments/assets/c26cfc8c-69d0-4b23-9f62-81e708fb1fce" width="300">               | <img src="https://github.com/user-attachments/assets/6ac20333-c385-41eb-a75c-11e5189bb68c" width="300">               |
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


