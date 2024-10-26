import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ekumpas_beta/provider/provider.dart';
import 'package:ekumpas_beta/services/realm_services.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:provider/provider.dart';

class FeedbackPage extends StatefulWidget {
  final String email; // User's email passed from another page

  const FeedbackPage({required this.email, Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double _rating = 0;
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  String _selectedSubject = 'New FSL Suggestions';
  bool _isLoading = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _feedbackController.dispose();
    super.dispose();
  }

  // Method to show the toast message
  void _showToastMessage(String message, IconData icon, Color color) {
    DelightToastBar(
      autoDismiss: true,
      position: DelightSnackbarPosition.top,
      builder: (context) => ToastCard(
        leading: Icon(icon, size: 28, color: color),
        title: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    ).show(context);
  }

  // Submit feedback to MongoDB via RealmServices
  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate() && _rating > 0) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Submit feedback to MongoDB
        await RealmServices.instance.submitFeedback(
          widget.email,
          _selectedSubject,
          _feedbackController.text,
          _rating,
        );

        // Show success toast
        _showToastMessage(
            'Thank you for your feedback!', Icons.check_circle, Colors.green);

        // Clear form fields and reset rating
        _feedbackController.clear();
        setState(() {
          _rating = 0;
        });
      } catch (e) {
        // Show error toast message
        _showToastMessage('Failed to submit feedback. Please try again.',
            Icons.error, Colors.red);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Show toast if the form is incomplete
      _showToastMessage('Please select a rating and enter your feedback',
          Icons.warning, Colors.orange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UiProvider>(builder: (context, UiProvider notifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Feedback Page'),
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How would you rate our service?',
                        style: TextStyle(
                          fontSize: constraints.maxWidth > 600 ? 22 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: RatingBar.builder(
                          initialRating: _rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.orange,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              _rating = rating;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _selectedSubject,
                        decoration: const InputDecoration(
                          labelText: 'Select Feedback Subject',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          'New FSL Suggestions',
                          'New Feature Requests',
                          'Performance issues',
                          'Bug reports',
                        ].map((subject) {
                          return DropdownMenuItem<String>(
                            value: subject,
                            child: Text(subject),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSubject = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a subject';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Your feedback is valuable to us. Please let us know how we can improve.',
                        style: TextStyle(
                          fontSize: constraints.maxWidth > 600 ? 18 : 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _feedbackController,
                        decoration: const InputDecoration(
                          labelText: 'Enter your feedback',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your feedback';
                          } else if (value.length > 500) {
                            return 'Feedback should be less than 500 characters';
                          }
                          return null;
                        },
                        maxLines: 5,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitFeedback,
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: notifier.isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
