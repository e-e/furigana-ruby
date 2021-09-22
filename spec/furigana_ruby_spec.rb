# frozen_string_literal: true
require "spec_helper"
require "furigana_ruby"

RSpec.describe FuriganaRuby do
  it "single gem that spans the entire word" do
    reading = "動物[どうぶつ]"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq(reading)
  end

  it "single gem in middle of a word" do
    reading = "新[あたら]しい"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq(reading)
  end

  it "multiple gems inside word" do
    reading = "黒[くろ]熊[くま]"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq(reading)
  end

  it "readings without gems do not change" do
    reading = "ライオン"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq(reading)
  end

  it "honorific should not be included in gem" do
    reading = "お茶[ちゃ]"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq(reading)
    expect(furigana.hiragana).to eq("おちゃ")
    expect(furigana.expression).to eq("お茶")
    expect(furigana.reading_html).to eq("お<ruby><rb>茶</rb><rt>ちゃ</rt></ruby>")
  end

  it "honorific should not be included in gem2" do
    reading = "起[お]きます"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq(reading)
    expect(furigana.hiragana).to eq("おきます")
    expect(furigana.expression).to eq("起きます")
    expect(furigana.reading_html).to eq("<ruby><rb>起</rb><rt>お</rt></ruby>きます")
  end

  it "number should not be included in gem" do
    reading = "9時[じ]"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq(reading)
    expect(furigana.hiragana).to eq("9じ")
    expect(furigana.expression).to eq("9時")
    expect(furigana.reading_html).to eq("9<ruby><rb>時</rb><rt>じ</rt></ruby>")
  end

  it "punctuation should not be included in gem" do
    reading = "大[おお]きい。犬[いぬ]"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq(reading)
    expect(furigana.hiragana).to eq("おおきい。いぬ")
    expect(furigana.expression).to eq("大きい。犬")
    expect(furigana.reading_html).to eq("<ruby><rb>大</rb><rt>おお</rt></ruby>きい。<ruby><rb>犬</rb><rt>いぬ</rt></ruby>")
  end

  it "romaji should not be included in gem" do
    reading = "Big犬[いぬ]"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq(reading)
    expect(furigana.hiragana).to eq("Bigいぬ")
    expect(furigana.expression).to eq("Big犬")
    expect(furigana.reading_html).to eq("Big<ruby><rb>犬</rb><rt>いぬ</rt></ruby>")
  end

  it "katana should not be included in gem" do
    reading = "ローマ字[じ]"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq(reading)
    expect(furigana.hiragana).to eq("ローマじ")
    expect(furigana.expression).to eq("ローマ字")
    expect(furigana.reading_html).to eq("ローマ<ruby><rb>字</rb><rt>じ</rt></ruby>")
  end

  it "hiragana should not be included in gem" do
    reading = "売[う]り場[ば]"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq(reading)
    expect(furigana.hiragana).to eq("うりば")
    expect(furigana.expression).to eq("売り場")
    expect(furigana.reading_html).to eq("<ruby><rb>売</rb><rt>う</rt></ruby>り<ruby><rb>場</rb><rt>ば</rt></ruby>")
  end

  it "お in furigana is not treated as honorific" do
    reading = "起[お]きます"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq(reading)
    expect(furigana.hiragana).to eq("おきます")
    expect(furigana.expression).to eq("起きます")
    expect(furigana.reading_html).to eq("<ruby><rb>起</rb><rt>お</rt></ruby>きます")
  end

  it "honorific in middle of a phrase" do
    reading = "東京[とうきょう] お急行[きゅうこう]"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq(reading)
  end

  it "honorific in middle of a word" do
    reading = "東京[とうきょう]お急行[きゅうこう]"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq(reading)
  end

  it "honorific at end of a word" do
    reading = "茶[ちゃ]お"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq(reading)
  end

  it "space can be a delimiter between hiragana sections" do
    reading = "あの 人[ひと]"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq(reading)
  end

  it "preserve a space between segments" do
    reading = "東京[とうきょう] 急行[きゅうこう]"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq(reading)
    expect(furigana.expression).to eq("東京 急行")
    expect(furigana.hiragana).to eq("とうきょう きゅうこう")
    expect(furigana.reading_html).to eq("<ruby><rb>東京</rb><rt>とうきょう</rt></ruby> <ruby><rb>急行</rb><rt>きゅうこう</rt></ruby>")
  end

  it "preserve multiple spaces between segments" do
    reading = "東京[とうきょう]    急行[きゅうこう]"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq("東京[とうきょう]    急行[きゅうこう]")
  end

  it "last character in reading is space" do
    reading = "東京[とうきょう] 急行[きゅうこう]"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq(reading)
  end

  it "ignore empty furigana section" do
    reading = "あの[]人[ひと]"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq("あの人[ひと]")
  end

  it "ignore furigana with only whitespace" do
    reading = "あの[ ]人[ひと]"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq("あの人[ひと]")
  end

  it "furigana to expression" do
    reading = "動物[どうぶつ]"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.expression).to eq("動物")
  end

  it "furigana to hiragana" do
    reading = "新[あたら]しい"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.hiragana).to eq("あたらしい")
  end

  it "furigana to html ruby" do
    reading = "新[あたら]しい"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading_html).to eq("<ruby><rb>新</rb><rt>あたら</rt></ruby>しい")
  end

  it "empty furigana" do
    reading = ""
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading).to eq(reading)
    expect(furigana.expression).to eq("")
    expect(furigana.hiragana).to eq("")
    expect(furigana.reading_html).to eq("")
  end

  it "null furigana" do
    reading = ""
    furigana = FuriganaRuby.new(nil)

    expect(furigana.reading).to eq(reading)
    expect(furigana.expression).to eq("")
    expect(furigana.hiragana).to eq("")
    expect(furigana.reading_html).to eq("")
  end

  it "allow html inside string" do
    reading = "学生です<span class='particle'>か</span>。"
    furigana = FuriganaRuby.new(reading)

    expect(furigana.reading_html).to eq(reading)
  end
end
