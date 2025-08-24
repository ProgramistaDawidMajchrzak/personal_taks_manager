# personal_task_manager

Flutter simple project which allows you to add, edit and delete tasks. Additionaly it charges the actual weather data depending on your location.

UI implemented by figma project created by Jenelle Miller. [LINK](https://www.figma.com/community/file/1175913608782916573/todo-mobile-app-community)

In the project I used MVVM pattern, build the structure such as:

```
lib/
├── models/
├── services/
├── viewmodels/
├── views/
├── widgets/
├── database/
└── main.dart
```

Features

- Add, edit and delete tasks
- Mark tasks as completed
- Weekly statistics of completed vs pending tasks (pie chart)
- Local notifications 30 minutes before task deadline
- Weather information based on current location
- Clean MVVM architecture with Provider
- Drift (SQLite) as local database

## Getting Started

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-username/personal_task_manager.git
   cd personal_task_manager
   flutter pub get
   ```

2. **Set up environment variables**

   ```bash
   WEATHER_API_KEY=your_openweather_api_key
   ```

3. **Run app**
   ```bash
   flutter run
   ```
