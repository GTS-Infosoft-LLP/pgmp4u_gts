class Event<T> {
  T _data;

  bool _isConsumed = false;

  Event(T data) {
    _data = data;
  }

  T getContent() {
    if (_isConsumed)
      return null;
    else {
      _isConsumed = true;
      return _data;
    }
  }

  T peek() {
    return _data;
  }
}