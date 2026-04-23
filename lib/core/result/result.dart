sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T value) success,
    required R Function(String message) failure,
  }) {
    final self = this;
    if (self is Success<T>) {
      return success(self.value);
    }
    if (self is Error<T>) {
      return failure(self.message);
    }
    throw StateError('Unhandled result type: $self');
  }
}

class Unit {
  const Unit();
}

const unit = Unit();

class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

class Error<T> extends Result<T> {
  const Error(this.message);

  final String message;
}
