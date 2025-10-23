import 'dart:convert';

import 'package:client_side/features/auth/model/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/server_constant.dart';
import '../../../core/failure/failure.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  // This says we return a string if there is an error or a map if there is no error
  // Also, we use Left, Right to represent the two possibilities clearer, no try and catch redundancy
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      print(ServerConstant.serverURL);
      final response = await http.post(
        Uri.parse('${ServerConstant.serverURL}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 201) {
        return Left(AppFailure(resBodyMap['detail']));
      }
      return Right(UserModel.fromMap(resBodyMap));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      // POST request to the server
      final response = await http.post(
        Uri.parse('${ServerConstant.serverURL}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      // In case the response is error
      if (response.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail']));
      }
      // In case the response is success, we return the user model and add token field to that user instance.
      // For where the token came, the code is in backend codebase.
      return Right(
        UserModel.fromMap(
          resBodyMap['user'],
        ).copyWith(token: resBodyMap['token']),
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUserData(String token) async {
    try {
      // GET request with token to server
      //This function check if a user is already logged in (by looking for a stored token) or to fetch their user data to restore their session in the app
      final response = await http.get(
        Uri.parse('${ServerConstant.serverURL}/auth/'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail']));
      }

      return Right(UserModel.fromMap(resBodyMap).copyWith(token: token));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
