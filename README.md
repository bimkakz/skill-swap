Создайте папку screens и добавьте файлы экранов.
(ПРИМЕР)
lib/
 ├── main.dart
 └── screens/
      ├── home_screen.dart
      ├── action_screen.dart
      └── result_screen.dart




6. Перенос экрана из Figma в Flutter
Разберите экран на блоки: Scaffold → AppBar → Column → элементы.

Scaffold(
  appBar: AppBar(title: Text("Home")),
  body: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Text("Заголовок"),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          child: Text("Продолжить"),
        ),
      ],
    ),
  ),
)
7. Реализация навигации
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ActionScreen(),
  ),
);

8. Использование ИИ при генерации кода
Правильно формулируйте запрос к ИИ с описанием структуры, а не только дизайна.
ИИ должен генерировать Scaffold, Column, Padding и базовую структуру без сложной архитектуры.
9. Итоговые требования
После выполнения инструкции студент должен иметь:
- Установленный Flutter (macOS или Windows)
- Рабочий проект
- Минимум 3 экрана
- Рабочую навигацию
- Понимание widget tree
