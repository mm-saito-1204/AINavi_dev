/*
 * 感情解析結果モデル
 */
class Emotion {
  final String emotionName;
  final double emotionValue;

  // constructor
  Emotion(
    this.emotionName,
    this.emotionValue,
  );

  // getter
  String get getEmotionName => emotionName;
  double get getEmotionValue => emotionValue;
}
