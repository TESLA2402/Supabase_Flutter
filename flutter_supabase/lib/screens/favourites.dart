import 'package:flutter/material.dart';
import 'package:flutter_supabase/screens/newsarticle.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class FavouriteArticles extends StatefulWidget {
  const FavouriteArticles({super.key});

  @override
  State<FavouriteArticles> createState() => _FavouriteArticlesState();
}

class _FavouriteArticlesState extends State<FavouriteArticles> {
  final userEmail = supabase.auth.currentUser!.email;
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: supabase
              .from('FavouriteArticles')
              .stream(primaryKey: ["id"])
              .eq('userEmail', userEmail)
              .order('created_at'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final contacts = snapshot.data!;

              return ListView.separated(
                  itemBuilder: (context, index) {
                    return Stack(children: [
                      FavouriteArticleTile(
                        imageURL: contacts[index]['image_url'],
                        title: contacts[index]['title'],
                        url: contacts[index]['url'],
                        description: contacts[index]['description'],
                      ),
                    ]);
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                  itemCount: snapshot.data!.length);
            } else {
              return const Center(
                child: Text("Add some Favourite Articles"),
                //CircularProgressIndicator()
              );
            }
          }),
    );
  }
}

class FavouriteArticleTile extends StatelessWidget {
  final String imageURL, title, description, url;

  FavouriteArticleTile(
      {required this.imageURL,
      required this.title,
      required this.description,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Article(articleUrl: url)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                imageURL,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                title,
                style: GoogleFonts.tinos(
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                description,
                maxLines: 2,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ),
            const Divider(
              height: 10,
              thickness: 1,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
