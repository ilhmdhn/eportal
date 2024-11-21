  bool isNullOrEmpty(value){
    return value == null || value.trim().isEmpty;
  }

  bool isNotNullOrEmpty(value) {
    return value != null && value.trim().isNotEmpty;
  }