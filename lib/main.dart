import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kiosk/core/widget/snackbar_service.dart';
import 'package:provider/provider.dart';

import 'core/platform/kiosk_admin_trigged.dart';
import 'core/platform/kiosk_native.dart';
import 'core/utility/dynamic_theme_provider.dart';
import 'core/utility/language_manager.dart';
import 'core/utility/login_status_service.dart';
import 'core/utility/network_status_service.dart';
import 'core/utility/periodic_health_check_service.dart';
import 'core/utility/user_login_status_service.dart';
import 'core/widget/network_aware_widget.dart';
import 'features/utility/app_initialize.dart';
import 'features/utility/const/constant_string.dart';
import 'features/utility/inactivity_controller.dart';
import 'features/utility/navigation_service.dart';
import 'features/utility/route_generator.dart';

Future<void> main() async {
  await AppInitialize.initialize();
  var connectivityResult = await (Connectivity().checkConnectivity());
  PeriodicHealthCheckService().start();

  // final isOwner1 = await KioskNative.isDeviceOwner();
  // final started = await KioskNative.startKiosk();
  // debugPrint("KIOSK isOwner=$isOwner1 started=$started");

  final isOwner = await KioskNative.isDeviceOwner();
  if (isOwner) {
    await KioskNative.startKiosk();
  }

  runApp(
    EasyLocalization(
      supportedLocales: ConstantString.SUPPORTED_LOCALE,
      path: ConstantString.LANG_PATH,
      startLocale: ConstantString.TR_LOCALE,
      child: MultiProvider(
        providers: [
          //kullanıcının uygulamayı kullanırken cihazın internete bağlılık durumunu dinleyen NetworkStatusService sınıfının durumunu tüm uygulamaya yayınlar
          StreamProvider<NetworkStatus>(
            create: (context) =>
                NetworkStatusService().networkStatusController.stream,
            initialData:
                connectivityResult.contains(ConnectivityResult.mobile) ||
                    connectivityResult.contains(ConnectivityResult.ethernet) ||
                    connectivityResult.contains(ConnectivityResult.vpn) ||
                    connectivityResult.contains(ConnectivityResult.wifi)
                ? NetworkStatus.online
                : NetworkStatus.offline,
          ),
          StreamProvider<LoginStatus>(
            create: (_) => LoginStatusService().statusStream,
            initialData: LoginStatus.offline,
          ),
          StreamProvider<UserLoginStatus>(
            create: (_) => UserLoginStatusService().statusStream,
            initialData: UserLoginStatus.offline,
          ),
          ChangeNotifierProvider(
            create: (_) => InactivityController(
              totalTimeout: const Duration(seconds: 30),
              warningBefore: const Duration(seconds: 15),
            ),
          ),
          ChangeNotifierProvider(create: (_) => DynamicThemeProvider()),
        ],
        child: MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final inactivity = context.watch<InactivityController>();
    final themeProvider = Provider.of<DynamicThemeProvider>(context);
    LanguageManager.instance.setLocale(context.locale);
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => inactivity.bump(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          // Android geri butonunu devre dışı bırak
        },
        child: MaterialApp(
          scaffoldMessengerKey: SnackbarService().key,
          theme: themeProvider.themeData,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          onGenerateRoute: RouteGenerator.generateRoutes,
          navigatorKey: NavigationService.ns.navigatorKey,
          navigatorObservers: [NavigationService.ns],
          initialRoute: '/',
          builder: (context, child) {
            final wrapped = NetworkAwareWidget(onlineChild: child);

            return KioskAdminTrigger(
              correctPin: '1224', 
              child: wrapped,
            );
          },
          // builder: (context, child) {
          //   return NetworkAwareWidget(onlineChild: child);

          // },
        ),
      ),
    );
  }
}
