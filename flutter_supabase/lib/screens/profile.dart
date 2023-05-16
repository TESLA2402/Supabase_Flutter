import 'package:flutter/material.dart';
import 'package:flutter_supabase/constants/colors.dart';
import 'package:flutter_supabase/constants/constants.dart';
import 'package:flutter_supabase/constants/typography.dart';
import 'package:flutter_supabase/helper/authenticate.dart';
import 'package:flutter_supabase/services/auth.dart';
import 'package:flutter_supabase/services/database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _avatarUrl;
  String? _userName;

  DatabaseMethods databaseMethods = DatabaseMethods();
  Future<void> _onUpload(String imageUrl) async {
    try {
      final userEmail = supabase.auth.currentUser!.email;
      await databaseMethods.updateUserInfo(userEmail!, imageUrl);
      if (mounted) {
        context.showSnackBar(message: 'Updated your profile image!');
      }
    } on PostgrestException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      context.showErrorSnackBar(message: 'Unexpected error has occurred');
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _avatarUrl = imageUrl;
    });
  }

  Future<void> _getProfile() async {
    final userEmail = supabase.auth.currentUser!.email;
    final data = await supabase
        .from('users')
        .select()
        .eq('userEmail', userEmail)
        .single() as Map;

    _avatarUrl = (data['photo_url']) as String;
    _userName = (data['userName']) as String;
    userNameTextEditingController = TextEditingController(text: _userName);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
    setState(() {});
  }

  TextEditingController userNameTextEditingController = TextEditingController();
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Avatar(
                imageUrl: _avatarUrl,
                onUpload: _onUpload,
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userNameTextEditingController.text.toUpperCase(),
                    style: GoogleFonts.tinos(
                        fontWeight: FontWeight.w500, fontSize: 24),
                  ),
                  Text(
                    "Hey! there",
                    style: GoogleFonts.tinos(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.grey),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 36,
          ),
          TextFormField(
            validator: (val) {
              return val!.isEmpty || val.length < 4
                  ? "Username must contain more than 4 characters"
                  : null;
            },
            //initialValue: _userName,
            controller: userNameTextEditingController,
            decoration: InputDecoration(
                hintText: "Change Username",
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide:
                        const BorderSide(width: 0, color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide:
                        const BorderSide(width: 0, color: Colors.white))),
          ),
          const SizedBox(
            height: 36,
          ),
          GestureDetector(
            onTap: () async {
              setState(() async {
                final userEmail = supabase.auth.currentUser!.email;
                await databaseMethods.updateUserName(
                    userEmail!, userNameTextEditingController.text);
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Done")));
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.button,
                ),
                child: Center(
                  child: Text("Update Username",
                      style: AppTypography.textMd.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () async {
              AuthService authService = AuthService();
              await authService.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Row(
              children: [
                const Icon(
                  Icons.logout,
                  color: Colors.red,
                  size: 26,
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  "Log out",
                  style: GoogleFonts.alata(color: Colors.red, fontSize: 22),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Avatar extends StatefulWidget {
  const Avatar({
    super.key,
    required this.imageUrl,
    required this.onUpload,
  });
  final String? imageUrl;
  final void Function(String) onUpload;

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          if (widget.imageUrl == null || widget.imageUrl!.isEmpty)
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
            )
          else
            CircleAvatar(
                radius: 50, backgroundImage: NetworkImage(widget.imageUrl!)),
        ]),
        GestureDetector(
          onTap: _isLoading ? null : _upload,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.button),
                  child: Center(
                    child: Text("Upload",
                        style: AppTypography.textMd.copyWith(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w400)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _upload() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (imageFile == null) {
      return;
    }
    setState(() => _isLoading = true);

    try {
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;
      await supabase.storage.from('avatars').uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(contentType: imageFile.mimeType),
          );
      final imageUrlResponse = await supabase.storage
          .from('avatars')
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
      widget.onUpload(imageUrlResponse);
      print("YES123....");
    } on StorageException catch (error) {
      if (mounted) {
        context.showErrorSnackBar(message: error.message);
      }
    } catch (error) {
      if (mounted) {
        context.showErrorSnackBar(message: 'Unexpected error occurred');
      }
    }

    setState(() => _isLoading = false);
  }
}
