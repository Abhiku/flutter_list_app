import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_result_state.freezed.dart';

@freezed
class NetworkResultState<T> with _$NetworkResultState<T> {
  const factory NetworkResultState.initial() = _Initial;
  const factory NetworkResultState.loading() = _Loading;
  const factory NetworkResultState.success(T data) = _Success;
  const factory NetworkResultState.error(String message) = _Error;
}
