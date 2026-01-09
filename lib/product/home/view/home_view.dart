import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

import '../../../core/utility/session_manager.dart';
import '../../../core/utility/user_login_status_service.dart';
import '../../../features/utility/const/constant_color.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_home_item.dart';
import '../../../features/utility/extension/text_theme_extension.dart';
import '../../../features/utility/extension/color_extension.dart';
import '../../../features/widget/custom_appbar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            CustomAppBar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ConstantString().welcome, style: context.pageTitle),
                      Text(
                        UserLoginStatusService().fullName ?? "",
                        style: context.pageTitle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ConstColor.transparent,
                        foregroundColor: context.primaryColor,
                        elevation: 0,
                        side: BorderSide(color: context.primaryColor, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        UserLoginStatusService().logout(
                          reason: SessionEndReason.manual,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Iconify(
                            MaterialSymbols.exit_to_app,
                            color: context.primaryColor,
                          ),
                          Text(
                            ConstantString().logout,
                            style: context.buttonText.copyWith(
                              color: context.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: EnumHomeItem.values.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.02,
                        ),
                        title: Text(
                          EnumHomeItem.values[index].label,
                          style: context.sectionTitle,
                        ),
                        leading: EnumHomeItem.values[index].icon(context),
                        trailing: EnumHomeItem.values[index].trailing,
                      ),
                      EnumHomeItem.values[index].widget(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
