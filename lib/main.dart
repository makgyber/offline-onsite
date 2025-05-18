import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:offline/authentication/screens/login.dart';
import 'package:offline/authentication/services/auth_service.dart';
import 'package:offline/job_orders/screens/job_order_details.dart';
import 'package:offline/job_orders/screens/job_orders.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: OfflineApp()));
}

class OfflineApp extends ConsumerWidget {
  OfflineApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _auth = ref.watch(authServiceProvider);
    return MaterialApp.router(
      routerConfig: GoRouter(
          routes: <GoRoute>[
            GoRoute(
              name: 'jobOrders',
              builder: (context, state) => const JobOrdersScreen(),
              path: '/',
            ),
            GoRoute(
                name: 'jobOrder',
                path: '/jobOrder/:id',
                builder: (BuildContext context, GoRouterState state) => JobOrderDetailsScreen(id: state.pathParameters['id'])
            ),
            GoRoute(
              name: 'login',
              builder: (context, state) => const LoginScreen(),
              path: '/login',
            ),


          ],
          debugLogDiagnostics: true,
          refreshListenable: _auth,
          redirect: (BuildContext context, GoRouterState state) {
            ref.watch(authUserProvider);
            final bool signedIn =  _auth.isLoggedIn;
            final bool signingIn = state.matchedLocation == '/login';

            debugPrint("signingIn $signingIn");
            debugPrint("signedIn $signedIn");
            if (!signedIn) {
              return '/login';
            }

            if(signedIn && !signingIn) {
              return null;
            }

            return '/';
          }
      ),
    );


  }

}

