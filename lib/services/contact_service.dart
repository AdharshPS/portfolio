import 'package:dio/dio.dart';
import 'package:portfolio_new/constants/contact_constants.dart';

class ContactSubmissionResult {
  final bool isSuccess;
  final String message;

  const ContactSubmissionResult({
    required this.isSuccess,
    required this.message,
  });
}

class ContactService {
  final Dio _dio;

  ContactService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          );

  Future<ContactSubmissionResult> sendMessage({
    required String name,
    required String email,
    required String message,
    String? accessKey,
  }) async {
    final key = accessKey ?? ContactConstants.web3FormsAccessKey;
    if (key.trim().isEmpty) {
      return const ContactSubmissionResult(
        isSuccess: false,
        message: 'Contact service is not configured with an access key.',
      );
    }

    try {
      final response = await _dio.post(
        'https://api.web3forms.com/submit',
        data: {
          'access_key': key.trim(),
          'name': name.trim(),
          'email': email.trim(),
          'message': message.trim(),
          'subject': 'Portfolio Inquiry from ${name.trim()}',
          'from_name': name.trim(),
          'botcheck': '', // Honeypot field for bot protection
        },
      );

      final data = response.data;
      if (response.statusCode == 200 && data is Map && data['success'] == true) {
        return ContactSubmissionResult(
          isSuccess: true,
          message:
              data['message'] as String? ??
              'Thank you! Your message has been sent successfully.',
        );
      } else {
        final errorMsg =
            (data is Map ? data['message'] : null) ??
            'Failed to send message. Please try again.';
        return ContactSubmissionResult(
          isSuccess: false,
          message: errorMsg.toString(),
        );
      }
    } on DioException catch (e) {
      String err =
          'Could not send message. Please try again or reach out directly via email.';
      if (e.response?.data is Map && e.response?.data['message'] != null) {
        err = e.response!.data['message'].toString();
      }
      return ContactSubmissionResult(isSuccess: false, message: err);
    } catch (_) {
      return const ContactSubmissionResult(
        isSuccess: false,
        message: 'An unexpected error occurred. Please try again later.',
      );
    }
  }
}
