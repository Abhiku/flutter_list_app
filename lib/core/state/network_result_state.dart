import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_result_state.freezed.dart';

@freezed
class NetworkResultState<T> with _$NetworkResultState<T> {
  const factory NetworkResultState.initial() = _Initial;
  const factory NetworkResultState.loading() = _Loading;
  const factory NetworkResultState.success(T data) = _Success;
  const factory NetworkResultState.error(String message) = _Error;
}

extension NetworkResultStateX<T> on NetworkResultState<T> {
  bool isSuccess() => this is _Success<T>;
  bool isError() => this is _Error;
  bool isLoading() => this is _Loading;
  bool isInitial() => this is _Initial;

  T get data => this is _Success<T>
      ? (this as _Success<T>).data
      : throw Exception('Data is not available');

  String get error => this is _Error
      ? (this as _Error).message
      : throw Exception('Error is not available');
}
