import 'package:ekumpas_beta/pages/online_pages/module_pages/level_1_page/OneSubModule.dart';
import 'package:ekumpas_beta/pages/online_pages/module_pages/level_2_page/TwoSubModule.dart';
import 'package:ekumpas_beta/pages/online_pages/module_pages/level_3_page/ThreeSubModule.dart';
import 'package:ekumpas_beta/pages/online_pages/module_pages/level_4_page/FourSubModule.dart';
import 'package:flutter/material.dart';
import 'package:ekumpas_beta/provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UiProvider>(builder: (context, UiProvider notifier, child) {
      return Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          title: Text(
            "Modules",
            style: TextStyle(
              color: notifier.isDark ? Colors.white : Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 2,
            ),
            children: [
              _buildMenuItem(
                context,
                icon: LucideIcons.handMetal,
                label: "Level 1",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OneSubModulePage()),
                ),
              ),
              _buildMenuItem(
                context,
                icon: LucideIcons.handHelping,
                label: "Level 2",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TwoSubModulePage()),
                ),
              ),
              _buildMenuItem(
                context,
                icon: LucideIcons.handHeart,
                label: "Level 3",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ThreeSubModulePage()),
                ),
              ),
              _buildMenuItem(
                context,
                icon: LucideIcons.heartHandshake,
                label: "Level 4",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FourSubModulePage()),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 0.4,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 18, 22, 60),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
