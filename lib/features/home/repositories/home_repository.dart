import 'dart:convert';
import 'dart:io';

import 'package:client_side/core/constants/server_constant.dart';
import 'package:client_side/core/failure/failure.dart';
import 'package:client_side/features/home/models/song_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepository();
}

class HomeRepository {
  // To upload a song, we need a thumbnail and audio.
  Future<Either<AppFailure, String>> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  }) async {
    try {
      // This is used to create HTTP request sending files, normal http requests only send text.
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstant.serverURL}/song/upload'),
      );
      // This part is to add files to the request.
      request
        ..files.addAll([
          await http.MultipartFile.fromPath('song', selectedAudio.path),
          await http.MultipartFile.fromPath(
            'thumbnail',
            selectedThumbnail.path,
          ),
        ])
        // This part is to add text fields to the request.
        ..fields.addAll({
          'artist': artist,
          'song_name': songName,
          'hex_code': hexCode,
        })
        // This part add headers to the request. Specifically jwt token.
        ..headers.addAll({'x-auth-token': token});
      final res = await request.send();
      if (res.statusCode != 201) {
        final responseBody = await res.stream.bytesToString();
        print('🚨 UPLOAD ERROR 422 DETAILS: $responseBody');
        return Left(AppFailure(await res.stream.bytesToString()));
      }
      return Right(await res.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSongs({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse('${ServerConstant.serverURL}/song/list'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );
      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['detail']));
      }
      resBodyMap = resBodyMap as List;

      List<SongModel> songs = [];

      for (final map in resBodyMap) {
        songs.add(SongModel.fromMap(map));
      }

      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
