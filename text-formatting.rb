class TextFormatting

  def initialize()
    @min_length = 9  # 最低文字数 (「なんで？」だけで終わっている行を対象から除外する)
  end
  
  def check_format(sentence)
    if /^(なんで|なぜ).*(？|!\?)$/ =~ sentence
      return true
    else
      return false
    end
  end
  
  def check_sentence_length(sentence)
    sentence_length = sentence.split(//u).length  # 受け取った行の文字数を取得
    if sentence_length > @min_length
      return true
    else
      return false
    end
  end
  
  # HTML タグを除去する
  def remove_html_tags(sentence)
    return sentence.gsub(/<\/?[^>]*>/, "")  # HTML タグを除去する
  end
  
  # 感嘆符疑問符を置換する
  def replace_sign(sentence)
    sentence = sentence.sub(/！？$/, "!?")  # 全角記号を半角に
    sentence = sentence.sub(/！?$/, "!?")  # 全角記号を半角に
    sentence = sentence.sub(/!？$/, "!?")  # 全角記号を半角に
    return sentence
  end
  
  # 口調(男言葉)を置換する
  def replace_tone(sentence)
    sentence = sentence.gsub(/(俺|僕)/, "私")  # 男一人称を中性一人称に
    sentence = sentence.sub(/だぜ？$/, "ですか？")  # 男言葉を中性言葉に
    sentence = sentence.sub(/だぜ!\?$/, "ですか!?")  # 男言葉を中性言葉に
    return sentence
  end
  
end
