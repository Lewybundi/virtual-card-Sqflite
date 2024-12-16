import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_card/models/contact_model.dart';
import 'package:virtual_card/pages/contact_details_page.dart';
import 'package:virtual_card/pages/form_page.dart';
import 'package:virtual_card/pages/home_page.dart';
import 'package:virtual_card/pages/scan_page.dart';


void main() {
  runApp(ScreenUtilInit(
    designSize: const Size(360, 640), 
    builder: (context, child) => ProviderScope(
    child: MyApp())),
  );
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: _router,
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
  final _router = GoRouter(
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
    name: HomePage.routeName,
    path: HomePage.routeName,
    builder: (context, state) => const HomePage(),
    routes: [
      GoRoute(
        name: ContactDetailsPage.routeName,
        path: ContactDetailsPage.routeName,
        builder: (c,state)=> ContactDetailsPage(id: state.extra! as int),
        ),
      GoRoute(
        name: ScanPage.routeName,
        path: ScanPage.routeName,
        builder: (context, state) => const ScanPage(),
        routes: [
          GoRoute(
          name: FormPage.routeName,
          path: FormPage.routeName,
           builder: (context, state) =>FormPage(contactModel: state.extra!as ContactModel,),
          
          )
        ]
      )
    ]

      ),
    ]
  );
}

