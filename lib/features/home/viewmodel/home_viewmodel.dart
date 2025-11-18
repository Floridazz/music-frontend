import 'dart:io';
import 'dart:ui';

import 'package:client_side/core/providers/current_user_notifier.dart';
import 'package:client_side/features/home/repositories/home_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils.dart';
import '../models/song_model.dart';

part 'home_viewmodel.g.dart';

// We separate getAllSongs from the class because one is for "Reading" (Fetching) and the other is for "Writing" (Mutating).
// If you merge them: Your HomeViewModel can only have one state. What should it be?
//
// If the state is List<SongModel>, how do you represent that an upload is loading without wiping out the list of songs from the screen?
//
// If you set state = AsyncValue.loading() when uploading a song, your list of songs will disappear from the UI and be replaced by a loading spinner because the entire provider is now in a loading state.
@riverpod
//Get the user token, pass it to the repository and get the songs, throw exception if error occurs and return list of songs.
Future<List<SongModel>> getAllSongs(Ref ref) async {
  final token = ref.watch(currentUserProvider)!.token;
  final res = await ref.watch(homeRepositoryProvider).getAllSongs(token: token);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;

  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.uploadSong(
      selectedAudio: selectedAudio,
      selectedThumbnail: selectedThumbnail,
      songName: songName,
      artist: artist,
      hexCode: rgbToHex(selectedColor),
      token: ref.read(currentUserProvider)!.token,
    );
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }
}
