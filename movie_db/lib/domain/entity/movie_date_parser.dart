

DateTime? parseMovieDateFromString(String? rewDate) {
    //!обязательно static
    if (rewDate == null || rewDate.isEmpty) return null;
    return DateTime.tryParse(rewDate);
  }