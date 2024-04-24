import 'package:flutter/material.dart';
import '../db/films_database.dart';
import '../model/film.dart';
import '../widget/film_form_widget.dart';

class AddEditFilmPage extends StatefulWidget {
  final Film? film;

  const AddEditFilmPage({
    Key? key,
    this.film,
  }) : super(key: key);

  @override
  State<AddEditFilmPage> createState() => _AddEditFilmPageState();
}

class _AddEditFilmPageState extends State<AddEditFilmPage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();

    isImportant = widget.film?.isImportant ?? false;
    number = widget.film?.number ?? 0;
    title = widget.film?.title ?? '';
    description = widget.film?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [buildButton()],
    ),
    body: Form(
      key: _formKey,
      child: FilmFormWidget(
        isImportant: isImportant,
        number: number,
        title: title,
        description: description,
        onChangedImportant: (isImportant) =>
            setState(() => this.isImportant = isImportant),
        onChangedNumber: (number) => setState(() => this.number = number),
        onChangedTitle: (title) => setState(() => this.title = title),
        onChangedDescription: (description) =>
            setState(() => this.description = description),
      ),
    ),
  );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isFormValid ? Colors.green : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateFilm,
        child: const Text('Save'),
      ),
    );
  }

  void addOrUpdateFilm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.film != null;

      if (isUpdating) {
        await updateFilm();
      } else {
        await addFilm();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateFilm() async {
    final film = widget.film!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
    );

    await FilmsDatabase.instance.update(film);
  }

  Future addFilm() async {
    final film = Film(
      title: title,
      isImportant: true,
      number: number,
      description: description,
      createdTime: DateTime.now(),
    );

    await FilmsDatabase.instance.create(film);
  }
}