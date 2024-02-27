# DoBlocks

This Ruby gem provides an easy way to add before, after, and on error blocks to methods in Ruby classes.

Lightly inspired by [Aspect-Oriented Programming](https://en.wikipedia.org/wiki/Aspect-oriented_programming) and [Rails callbacks](https://guides.rubyonrails.org/active_record_callbacks.html), it's a simple way to add cross-cutting concerns to methods while keeping the original code short and clean.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'do_blocks'
```

And then execute:

```ruby
$ bundle install
```

## Usage

To use `DoBlocks`, simply extend the `DoBlocks` module in your class and define your blocks:

```ruby
require 'do_blocks'

class MyCalculator
  extend DoBlocks

  def divide(x, y)
    x / y
  end

  do_before :divide do |args, kwargs|
    puts "About to divide #{args.join(' by ')}"
  end

  do_after :divide do |args, kwargs, result|
    puts "The result is #{result}"
  end

  do_on_error :divide, reraise: false do |args, kwargs, error|
    puts "Error encountered: #{error.message}"
  end
end
```

- `do_before`: Execute a block before the original method. The block receives the original method's positional arguments (`args`) and keyword arguments (`kwargs`).
- `do_after`: Execute a block after the original method. The block receives the original method's positional arguments (`args`), keyword arguments (`kwargs`), and result (`result`).
- `do_on_error`: Execute a block if the original method raises an error. The block receives the original method's positional arguments (`args`), keyword arguments (`kwargs`), and the error object (`error`). You can also specify whether to reraise the error with the `reraise: (true|false)` flag.

## Recommendations

- Use blocks for cross-cutting concerns like logging, error reporting, and performance monitoring. The original method should remain focused on its core functionality.
- Keep your blocks short and simple. If you need to do something complex, consider extracting it to a separate method.

## Contributing

Bug reports and pull requests are welcome on GitHub!
