import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../db/films_database.dart';
import '../model/film.dart';
import '../page/edit_film_page.dart';
import '../page/film_detail_page.dart';
import '../widget/film_card_widget.dart';

class FilmPage extends StatefulWidget {
  const FilmPage({super.key});

  @override
  State<FilmPage> createState() => _FilmPageState();
}

class _FilmPageState extends State<FilmPage> {
  late List<Film> films;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshFilms();
  }

  @override
  void dispose() {
    FilmsDatabase.instance.close();

    super.dispose();
  }

  Future refreshFilms() async {
    setState(() => isLoading = true);

    films = await FilmsDatabase.instance.readAllFilms();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Films',
        style:
          TextStyle(fontSize: 24, color: Colors.grey),
      ),
      actions: const [Icon(Icons.search), SizedBox(width: 12)],
    ),
    body: Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : films.isEmpty
          ? const Text(
        'No Films',
        style: TextStyle(color: Colors.white, fontSize: 24),
      )
          : buildFilms(),
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.grey,
      child: const Icon(Icons.add),
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddEditFilmPage()),
        );

        refreshFilms();
      },
    ),
  );
  Widget buildFilms() => StaggeredGrid.count(
    // itemCount: films.length,
    // staggeredTileBuilder: (index) => StaggeredTile.fit(2),
      crossAxisCount: 2,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: List.generate(
        films.length,
            (index) {
          final film = films[index];

          return StaggeredGridTile.fit(
            crossAxisCellCount: 1,
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FilmDetailPage(filmId: film.id!),
                ));

                refreshFilms();
              },
              child: FilmCardWidget(film: film, index: index),
            ),
          );
        },
      ));

// Widget buildNotes() => StaggeredGridView.countBuilder(
//       padding: const EdgeInsets.all(8),
//       itemCount: notes.length,
//       staggeredTileBuilder: (index) => StaggeredTile.fit(2),
//       crossAxisCount: 4,
//       mainAxisSpacing: 4,
//       crossAxisSpacing: 4,
//       itemBuilder: (context, index) {
//         final note = notes[index];

//         return GestureDetector(
//           onTap: () async {
//             await Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => NoteDetailPage(noteId: note.id!),
//             ));

//             refreshNotes();
//           },
//           child: NoteCardWidget(note: note, index: index),
//         );
//       },
//     );
}