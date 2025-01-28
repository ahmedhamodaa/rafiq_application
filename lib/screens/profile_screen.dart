import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rafiq/screens/edit_profile_screen.dart';
import 'package:rafiq/screens/get_started.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rafiq/screens/my_profile.dart';
import 'package:language_code/language_code.dart';
import 'package:rafiq/localization.dart';

Widget makeTile({GestureTapCallback? onTap, IconData? leading, Widget? title}) {
  return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
          onTap: onTap,
          title: title,
          leading: Icon(leading, size: 32),
          trailing: const Icon(Icons.arrow_forward_ios_outlined)));
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListTileTheme(
        data: Theme.of(context).listTileTheme.copyWith(
            iconColor: theme.colorScheme.secondary,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Color(0xffd0d0d0))),
            titleTextStyle: theme.textTheme.titleMedium!
                .copyWith(color: theme.colorScheme.secondary, fontSize: 22)),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyProfile(),
                      ));
                },
                title: const Text('ahmed elsayed hamoda',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black)),
                subtitle: const Text('ahmdhamoda11@gmail.com',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Color(0xff999999))),
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
                leading: const CircleAvatar(
                    backgroundImage:
                        AssetImage('images/courses/profile_picture.jpg'))),
            const SizedBox(height: 12),
            makeTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ));
                },
                leading: Icons.person_outline_outlined,
                title: const Text('Edit Profile')),
            makeTile(
                onTap: () {},
                leading: Icons.notifications_none_outlined,
                title: const Text('Notifications')),
            makeTile(
                onTap: () {},
                leading: Icons.wallet_outlined,
                title: const Text('Payment Options')),
            makeTile(
                onTap: () {},
                leading: Icons.security_outlined,
                title: const Text('Security')),
            makeTile(
                onTap: () => _showLanguagePicker(context),
                leading: Icons.language_outlined,
                title: Text(locale.chooseLanguage)),
            makeTile(
                onTap: () {},
                leading: Icons.dark_mode_outlined,
                title: const Text('Dark Mode')),
            makeTile(
                onTap: () {},
                leading: Icons.text_snippet_outlined,
                title: const Text('Terms & Conditions')),
            makeTile(
                onTap: () {},
                leading: Icons.help_center_outlined,
                title: const Text('Help center')),
            makeTile(
                onTap: () {},
                leading: Icons.local_post_office_outlined,
                title: const Text('Invite Friends')),
            ListTile(
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const GetStarted()),
                (route) => false, // Remove all routes
              ),
              leading: const Icon(Icons.logout_outlined,
                  color: Color(0xffBD0F0F), size: 32),
              title: const Text('Log out',
                  style: TextStyle(color: Color(0xffBD0F0F))),
            )
          ],
        ),
      ),
    );
  }
}

void _showLanguagePicker(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(AppLocalizations.of(context)!.chooseLanguage,
              style: Theme.of(context).textTheme.titleMedium),
          ...[
            for (final l in AppLocalizations.supportedLocales)
              ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(LanguageCodes.fromLocale(l).nativeName,
                      style: Theme.of(context).textTheme.bodyMedium),
                  onTap: () => context.read<LocaleProvider>().locale = l)
          ]
        ]),
      );
    },
  );
}
