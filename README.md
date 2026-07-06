# 👨‍🏫 Shafeea Teach (أكاديمية شفيع - نظام المعلم والمشرف)

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

**Shafeea Teach** is the management and supervision module of the Shafeea Academy platform. This mobile application is specifically designed for teachers and supervisors to manage Quranic memorization circles (Halqas), track student performance in real-time, and generate comprehensive educational reports.

---

## 🌟 Core Functionalities

### For Supervisors (Admins)

- **Circle Management**: Create and manage learning circles, assign teachers, and distribute students.
- **User Administration**: Review registration requests, manage teacher and student profiles.
- **Data Analytics**: Access a high-level dashboard with live statistics on progress, attendance, and performance.
- **Bulk Operations**: Import and export data using CSV files for efficient management of large academies.

### For Teachers

- **Interactive Tracking**: Use a specialized digital Mushaf to record memorization, review, and recitation progress.
- **Detailed Evaluation**: Log word-level mistakes (pronunciation, grammar, memorization) with precision.
- **Student Performance**: View individual student progress charts and historical data to tailor educational support.
- **Offline Mode**: Record student performance without an internet connection; data syncs automatically once online.

---

## 🛠️ Technology Stack

| Category | Technology |
| :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev/) (Multi-platform) |
| **State Management** | [BLoC / Cubit](https://pub.dev/packages/flutter_bloc) |
| **Networking** | [Dio](https://pub.dev/packages/dio) with RESTful APIs |
| **Local Database** | [SQLite (sqflite)](https://pub.dev/packages/sqflite) |
| **Persistence** | [Secure Storage](https://pub.dev/packages/flutter_secure_storage) & [Shared Preferences](https://pub.dev/packages/shared_preferences) |
| **DI & Service Locator** | [Injectable](https://pub.dev/packages/injectable) / [GetIt](https://pub.dev/packages/get_it) |

---

## 📂 Project Structure

```text
lib/
├── config/             # DI, Localization, Themes, and App Config
├── core/               # Error handling, Network, and UseCases
├── features/           # Modular features
│   ├── app/            # Global setup and app entry
│   ├── auth/           # Login and Authentication
│   ├── daily_tracking/ # Interactive Mushaf and student monitoring
│   ├── home/           # Teacher/Supervisor Dashboards
│   └── settings/       # User preferences
├── routes/             # Navigation and Routing (GoRouter)
├── shared/             # Reusable UI components
└── main.dart           # App entry point
```

---

## 🏁 Getting Started

### Prerequisites

- Flutter SDK (Latest Stable)
- Dart SDK
- Git

### Installation & Setup

1. **Clone the repository:**

   ```bash
   git clone https://github.com/your-username/shafeea_teach.git
   cd shafeea_teach
   ```

2. **Get dependencies:**

   ```bash
   flutter pub get
   ```

3. **Run Code Generation:**

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Launch the application:**

   ```bash
   flutter run
   ```

---

## 📋 Documentation

For a detailed technical breakdown, including functional and non-functional requirements, database schemas, and architectural constraints, please refer to the [Requirements Sheet.md](file:///c:/xampp/htdocs/shafeea_platform/shafeea_teach/Requirements%20Sheet.md).

---

## 🤝 Contributing

We welcome contributions to enhance the Shafeea platform.

1. Fork the repo.
2. Create your feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](file:///c:/xampp/htdocs/shafeea_platform/shafeea_teach/LICENSE) file for details.

---

## 📬 Contact

**Emran Nasser** - [GitHub](https://github.com/emran-nasser)

Project Link: [https://github.com/shafeea-platform/shafeea_teach](https://github.com/shafeea-platform/shafeea_teach)

---
*Empowering Quranic Education through Technology.*
