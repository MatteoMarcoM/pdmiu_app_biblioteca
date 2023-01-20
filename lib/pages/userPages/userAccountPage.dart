import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdmiu_app_biblioteca/widgets/largeUserDrawer.dart';
import 'package:pdmiu_app_biblioteca/widgets/mobileUserDrawer.dart';
import '../../models/user.dart';
import '../../models/userList.dart';
import '../../utility/providers.dart';
import '../mainPages/biblioHomePage.dart';

// "home page" dell'utente
class UserAccountPage extends ConsumerWidget {
  const UserAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ottengo l'utente
    //String username = ref.watch(currentUserNameProvider);
    //User user = ref.watch(specificUserProvider(username));

    User user = ref.watch(currentUserProvider.notifier);

    final width = MediaQuery.of(context).size.width;
    final isLarge = width > 800;

    return Scaffold(
        appBar: AppBar(
          // oppure fare metodo String user.getUsername()
          title: const Text("Account Info and settings"),
          actions: [
            IconButton(
                onPressed: () {
                  // successful login?
                  user.loginJWT();
                },
                icon: const Icon(Icons.change_circle)),
          ],
        ),
        body: (isLarge)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(child: DetailsView()),
                  Expanded(child: AccountButtonsLisView()),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(child: AccountButtonsLisView()),
                  Expanded(child: DetailsView()),
                ],
              ));
  }
}

class DetailsView extends ConsumerWidget {
  const DetailsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User user = ref.watch(currentUserProvider.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade700,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Username: ',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Center(
                child: Text(
                  '${user.getName()}',
                  style: Theme.of(context).textTheme.headline3,
                ),
              )
            ],
          ),
        ),
        Container(
          color: Theme.of(context).primaryColor,
          child: Row(
            children: [
              const Text('Cookie session JWT: '),
              Flexible(child: Text('${user.state.jwtCookieSession}'))
            ],
          ),
        )
      ],
    );
  }
}

class AccountButtonsLisView extends ConsumerWidget {
  const AccountButtonsLisView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User user = ref.watch(currentUserProvider.notifier);

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Theme.of(context).backgroundColor,
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                "Impostazioni dell'Account",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
          Expanded(
            child: ListView(children: [
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Logout"),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const BiblioHomePage()),
                      (route) => false);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_remove_sharp),
                title: const Text("Cancella account"),
                subtitle: const Text("Disiscriviti dal servizio"),
                onTap: () async {
                  final response = await user.deleteUser();

                  if (response.statusCode == 200) {
                    // rimuovo l'utente dalla lista utenti
                    //UserList userList = ref.watch(userListProvider.notifier);
                    //userList.removeUser(user.state.username);

                    // reset notifier
                    user.state = UserData(
                        username: 'mario', password: 'passwordDiMario');

                    // apro la pagina
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const BiblioHomePage()),
                        (route) => false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Request failed, try reloading JWT!!')));
                  }
                },
              ),
            ]),
          )
        ]);
  }
}
