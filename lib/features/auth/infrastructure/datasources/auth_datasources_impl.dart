import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: Enviroments.apiUrl,
  ));

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        "email": email,
        "password": password,
      });

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
          e.response?.data['message'] ?? 'Credenciales no validas',
        );
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(
          'Revisar conexión a internet',
        );
      }
      throw Exception(
        'Somenthing wrong happend',
      );
    } catch (e) {
      throw CustomError(
        'An error occurred, please try again later',
      );
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) async {
    try {
      final response = await dio.post('/auth/register',
          data: {"email": email, "password": password, "fullName": fullName});

      final newUser = UserMapper.userJsonToEntity(response.data);
      return newUser;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
          e.response?.data['message'] ?? 'ERROR',
        );
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(
          'Revisar conexión a internet',
        );
      }
      throw Exception(
        'Somenthing wrong happend',
      );
    } catch (e) {
      throw CustomError(
        'An error occurred, please try again later',
      );
    }
  }

  @override
  Future<User> checkAuthStatus(String token) {
    // todo: implement checkAuthStatus
    throw UnimplementedError();
  }
}
