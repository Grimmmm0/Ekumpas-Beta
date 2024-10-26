import 'package:flutter/material.dart';
import 'package:ekumpas_beta/pages/online_pages/about_page/about.dart';
import 'package:ekumpas_beta/pages/online_pages/faq_page/faqpage.dart';
import 'package:ekumpas_beta/pages/online_pages/feedback_page/feedbackpage.dart';
import 'package:ekumpas_beta/pages/online_pages/updates_page/updatespage.dart';
import 'package:ekumpas_beta/provider/provider.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatefulWidget {
  final String email;
  final VoidCallback logout;

  const Sidebar({required this.email, required this.logout, Key? key})
      : super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(-30 * (1 - _animation.value), 0),
          child: Drawer(
            child: Container(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
              child: Padding(
                padding: const EdgeInsets.only(top: 50, left: 40, bottom: 70),
                child: Column(
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: const Image(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/Fsidebar.gif'),
                            width: 200, // Increased width
                            height: 200, // Increased height
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.email,
                          style: TextStyle(
                            color: theme.textTheme.titleLarge?.color,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          ListTile(
                            leading:
                                const Icon(Icons.dark_mode, color: Colors.blue),
                            title: Text(
                              'Theme',
                              style: TextStyle(
                                color: theme.textTheme.titleLarge?.color,
                                fontSize: 24,
                              ),
                            ),
                            trailing: Switch(
                              value: Provider.of<UiProvider>(context).isDark,
                              activeColor: Theme.of(context)
                                  .floatingActionButtonTheme
                                  .backgroundColor, // Color when switch is on
                              inactiveTrackColor: Theme.of(context)
                                  .dialogBackgroundColor, // Color of the track when switch is off
                              inactiveThumbColor: Theme.of(context)
                                  .disabledColor, // Color of the thumb when switch is off
                              onChanged: (value) => Provider.of<UiProvider>(
                                      context,
                                      listen: false)
                                  .changeTheme(),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.mail, color: Colors.blue),
                            title: Text(
                              'Feedback',
                              style: TextStyle(
                                color: theme.textTheme.titleLarge?.color,
                                fontSize: 24,
                              ),
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FeedbackPage(email: widget.email),
                              ),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.question_answer,
                                color: Colors.blue),
                            title: Text(
                              'FAQs',
                              style: TextStyle(
                                color: theme.textTheme.titleLarge?.color,
                                fontSize: 24,
                              ),
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FAQsPage(),
                              ),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.info, color: Colors.blue),
                            title: Text(
                              'About',
                              style: TextStyle(
                                color: theme.textTheme.titleLarge?.color,
                                fontSize: 24,
                              ),
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AboutPage(),
                              ),
                            ),
                          ),
                          ListTile(
                            leading:
                                const Icon(Icons.android, color: Colors.blue),
                            title: Text(
                              'Updates',
                              style: TextStyle(
                                color: theme.textTheme.titleLarge?.color,
                                fontSize: 24,
                              ),
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UpdatesPage(),
                              ),
                            ),
                          ),
                          ListTile(
                            leading:
                                const Icon(Icons.logout, color: Colors.blue),
                            title: Text(
                              'Logout',
                              style: TextStyle(
                                color: theme.textTheme.titleLarge?.color,
                                fontSize: 24,
                              ),
                            ),
                            onTap: widget.logout,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void toggleDrawer() {
    if (_isDrawerOpen) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    _isDrawerOpen = !_isDrawerOpen;
  }
}
