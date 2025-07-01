# 😴 SleepTracker 
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/iOS-16%2B-blue.svg)](https://developer.apple.com/ios/)

## 🏗️ Описание проекта

IOS приложение для отслеживания сна, реализованное на Swift. 

- **App** - точка входа: `SleepTrackerApp` -> `ContentView`.
- **Data** — работа с данными с помощью `SleepRepository`.
- **Domain** — описание сущностей: `SleepSession`.
- **Presentation** — пользовательский интерфейс в  `Screens/`:
    - `Home/` - главный экран.
    - `AddSleep/` - добавление записи.
    - `Analytics/` - аналитика.
    
- **UseCases** — бизнес-логика. 
---

## 📱 Экраны
### 🏠 Главный экран `Home`:
- **Last Sleep** - информация о последнем сне.

- **Last Week Sleep** - график сна за последнюю неделю.

| Состояние | Скриншот |
|-----------|----------|
| Нет данных | <img src="Design/EmptyHomePage.png" width="200" alt="Empty Home"> |
| С данными | <img src="Design/HomePage.png" width="200" alt="Home with Data"> |

---

### ✏️ Добавление записи `AddSleep`:
- Форма для добавления записи о сне.

#### Экран с формой:

<img src="Design/AddSleep.png" alt="Главный экран" width="200"/>

---

### 📊 Аналитика `Analytics`:
- **WeekDynamics** - анализ записей за последнюю нелелю.
- **DailySleep** - краткие данные по дням.

| Состояние | Скриншот |
|-----------|----------|
| Нет данных | <img src="Design/EmptyAnalytics.png" width="200" alt="Empty Analytics"> |
| С данными | <img src="Design/Analytics.png" width="200" alt="Analytics Data"> |

---

## 🛠️ Технологии

- **SwiftUI** — построение интерфейсов.
- **SwiftData** — хранение записей.
- **Charts** — визуализация статистики.

:))
