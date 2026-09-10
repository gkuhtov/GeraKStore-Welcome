# GeraKStore Welcome

<p align="center">
  <strong>Универсальные приветственные экраны для GeraKStore</strong><br>
  <sub>Нативные iOS-экраны приветствия для IPA-приложений</sub>
</p>

<p align="center">
  <a href="https://github.com/gkuhtov/GeraKStore-Welcome/actions/workflows/build-dylib.yml"><img src="https://github.com/gkuhtov/GeraKStore-Welcome/actions/workflows/build-dylib.yml/badge.svg" alt="Сборка WelcomeToSpace"></a>
  <a href="https://github.com/gkuhtov/GeraKStore-Welcome/actions/workflows/build-welcome-to-japan.yml"><img src="https://github.com/gkuhtov/GeraKStore-Welcome/actions/workflows/build-welcome-to-japan.yml/badge.svg" alt="Сборка WelcomeToJapan"></a>
  <a href="https://github.com/gkuhtov/GeraKStore-Welcome/actions/workflows/inject-welcome-to-space.yml"><img src="https://github.com/gkuhtov/GeraKStore-Welcome/actions/workflows/inject-welcome-to-space.yml/badge.svg" alt="Инъекция WelcomeToSpace"></a>
</p>

<p align="center">
  <a href="#обзор">Обзор</a> ·
  <a href="#welcometospace">Space</a> ·
  <a href="#welcometojapan">Japan</a> ·
  <a href="#настройка">Настройка</a> ·
  <a href="#сборка-и-инъекция">Сборка</a> ·
  <a href="#структура-проекта">Структура</a>
</p>

---

## Обзор

**GeraKStore Welcome** - набор лёгких приветственных экранов на Objective-C для iOS-приложений, распространяемых через GeraKStore.

Репозиторий объединяет две независимые визуальные реализации с общей задачей: создать узнаваемый, аккуратный и переиспользуемый экран приветствия, который ощущается частью приложения, а не отдельным установщиком.

### В проекте

| Компонент | Стиль | Назначение |
|---|---|---|
| **WelcomeToSpace** | Тёмный · Liquid Glass · Свечение | Современный универсальный экран приветствия |
| **WelcomeToJapan** | Японская стилистика · Иллюстрация · Параллакс | Декоративный экран приветствия |

---

## WelcomeToSpace

Современная версия приветственного экрана в тёмной стилистике GeraKStore.

### Возможности

- iOS-стиль Liquid Glass
- Тёмная графитовая основа
- Розовые и бирюзовые акценты
- Анимированное фоновое свечение
- Настраиваемые заголовок и описание
- Кнопки Telegram, GitHub и «Продолжить»
- Опция «Больше не показывать»
- Настраиваемые параметры внешнего вида и анимации
- Конфигурация через JSON
- Резервная загрузка ресурсов из встроенных Mach-O секций
- Сборка через GitHub Actions

---

## WelcomeToJapan

Отдельная визуальная реализация в японской стилистике с иллюстрированной сценой и декоративными элементами.

### Возможности

- Японская визуальная композиция
- Пользовательский фон
- Декоративные таблички и брендинг GeraKStore
- Настраиваемые тексты и ссылки
- Настраиваемые визуальные элементы
- Поддержка параллакса
- Отдельная сборка динамической библиотеки
- Собственный GitHub Actions workflow

---

## Настройка

Для **WelcomeToSpace** пользовательские параметры отделены от основной реализации интерфейса.

Основные конфигурационные файлы:

- `config.json` - общие параметры и функции
- `texts.json` - тексты интерфейса
- `links.json` - ссылки Telegram и GitHub
- `appearance.json` - цвета, параметры стекла, размеры, отступы и анимация

Конфигурация загружается через `WelcomeConfig` и `EmbeddedResourceLoader`. Если внешние ресурсы недоступны, библиотека может использовать ресурсы, встроенные непосредственно в Mach-O.

Это позволяет изменять внешний вид и содержимое экрана без переписывания основной логики интерфейса.

---

## Сборка и инъекция

Сборка проекта выполняется через **GitHub Actions** на macOS runners.

### WelcomeToSpace

Workflow `build-dylib.yml` собирает `GeraKStoreWelcome.dylib` и формирует артефакт с библиотекой и необходимыми ресурсами.

Workflow `inject-welcome-to-space.yml` используется для проверки инъекции WelcomeToSpace в тестовый IPA.

### WelcomeToJapan

Workflow `build-welcome-to-japan.yml` независимо собирает динамическую библиотеку WelcomeToJapan и формирует отдельный артефакт.

Локальная сборка на macOS для этого рабочего процесса не требуется.

---

## Тестовый IPA

Для проверки инъекции **WelcomeToSpace** используется:

```text
test-ipa/GeraKMusic-original.ipa
```

Результатом workflow инъекции является тестовый IPA с подключённой библиотекой WelcomeToSpace.

---

## Инъекция

Приветственные экраны рассчитаны на использование в качестве внедряемых динамических библиотек в совместимых IPA-пакетах.

Универсальный интерфейс не привязан к конкретному приложению, игре или версии. Это позволяет использовать одну реализацию Welcome в разных IPA.

---

## Структура проекта

```text
GeraKStore-Welcome/
│
├── .github/
│   └── workflows/
│       ├── build-dylib.yml
│       ├── build-welcome-to-japan.yml
│       └── inject-welcome-to-space.yml
│
├── WelcomeToSpace/
│   ├── Configuration/
│   │   ├── Models/
│   │   └── *.json
│   ├── Core/
│   └── Resources/
│
├── WelcomeToJapan/
│   ├── src/
│   ├── Resources/
│   ├── Makefile
│   └── control
│
├── test-ipa/
└── README.md
```

---

## Философия проекта

Главная идея GeraKStore Welcome проста:

> Приветственный экран должен ощущаться частью приложения, а не отдельным окном установщика.

**WelcomeToSpace** делает акцент на глубине, прозрачности, размытии, мягком свечении и аккуратной анимации.

**WelcomeToJapan** использует другой подход: иллюстрацию, многослойную композицию, декоративные элементы и японскую визуальную стилистику.

Несмотря на различия, обе реализации создаются как единый узнаваемый опыт GeraKStore.

---

## Статус

Репозиторий находится в активной разработке.

- [x] WelcomeToSpace
- [x] WelcomeToJapan
- [x] Настраиваемые параметры интерфейса
- [x] Встроенные ресурсы
- [x] Сборка через GitHub Actions
- [x] Workflow для проверки инъекции WelcomeToSpace в IPA
- [ ] Дальнейшая полировка интерфейса
- [ ] Более глубокая интеграция с GeraStoreManager

---

## Репозиторий

**GeraKStore Welcome**

https://github.com/gkuhtov/GeraKStore-Welcome

Создано и поддерживается **GeraK**.

---

<p align="center">
  <sub>GeraKStore · Welcome Experience</sub>
</p>
