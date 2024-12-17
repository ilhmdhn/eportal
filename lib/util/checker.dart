  bool isNullOrEmpty(value){
    return value == null || value.trim().isEmpty;
  }

  bool isNotNullOrEmpty(value) {
    return value != null && value.trim().isNotEmpty;
  }

  bool isNotNullOrEmptyList(List<dynamic>? value) {
  return value != null && value.isNotEmpty;
  }