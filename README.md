# FuriganaRuby

This is a direct ruby port from [Gem](https://github.com/helephant/Gem)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'furigana_ruby'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install furigana_ruby

## Usage

```ruby
parsed = FuriganaRuby::Parser.new("簡[かん]単[たん]ね")
puts(parsed.reading) # 簡[かん]単[たん]ね
puts(parsed.expression) # 簡単ね
puts(parsed.hiragana) # かんたんね
puts(parsed.reading_html) # <ruby><rb>簡</rb><rt>かん</rt></ruby><ruby><rb>単</rb><rt>たん</rt></ruby>ね
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/furigana_ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/furigana_ruby/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FuriganaRuby project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/furigana_ruby/blob/main/CODE_OF_CONDUCT.md).
