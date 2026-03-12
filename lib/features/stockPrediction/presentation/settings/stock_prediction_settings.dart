enum StockPredictionWindow { day, week, month, year }

extension StockPredictionWindowExtension on StockPredictionWindow {
  String get label {
    switch (this) {
      case StockPredictionWindow.day:
        return "Par jour";
      case StockPredictionWindow.week:
        return "Par semaine";
      case StockPredictionWindow.month:
        return "Par mois";
      case StockPredictionWindow.year:
        return "Par an";
    }
  }

  int get days {
    switch (this) {
      case StockPredictionWindow.day:
        return 1;
      case StockPredictionWindow.week:
        return 7;
      case StockPredictionWindow.month:
        return 30;
      case StockPredictionWindow.year:
        return 365;
    }
  }
}

class StockPredictionSettings {
  final StockPredictionWindow window;
  final int previewCount; // nombre affiché sur le home

  const StockPredictionSettings({
    this.window = StockPredictionWindow.week,
    this.previewCount = 3,
  });

  StockPredictionSettings copyWith({
    StockPredictionWindow? window,
    int? previewCount,
  }) {
    return StockPredictionSettings(
      window: window ?? this.window,
      previewCount: previewCount ?? this.previewCount,
    );
  }

  Map<String, dynamic> toMap() => {
    'window': window.index,
    'previewCount': previewCount,
  };

  factory StockPredictionSettings.fromMap(Map<String, dynamic> map) {
    return StockPredictionSettings(
      window: StockPredictionWindow.values[map['window'] ?? 1],
      previewCount: map['previewCount'] ?? 3,
    );
  }
}
