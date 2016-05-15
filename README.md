[![Build Status](https://travis-ci.org/abhijeetkalyan/rize.svg?branch=master)](https://travis-ci.org/abhijeetkalyan/rize)

# Rize

### A functional toolkit for Ruby.

(Inspired by Javascript's [Underscore](http://underscorejs.org/), Python's [toolz](https://github.com/pytoolz/toolz) and Ocaml's [List module](http://caml.inria.fr/pub/docs/manual-ocaml/libref/List.html)).

Rize is a collection of useful methods that can make it easier to work with functions, arrays and hashes in Ruby. Some of the interesting things you can do include:

- Compose, memoize and partially supply arguments to your functions
- Control the behaviour of your functions based on how many times they're called - for example, you could create a function that stops executing on the third try.
- Map or iterate over multiple arrays at once
- Elegantly map over just the keys, or just the values of a hash.

Nothing is monkeypatched, so you don't have to worry about the core classes behaving differently than you expect.

See the [Usage](https://github.com/abhijeetkalyan/rize#usage) section for more on what rize can do.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rize'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rize

## Usage

Rize has two primary uses: working with [functions](https://github.com/abhijeetkalyan/rize/blob/master/lib/rize/functional.rb) and working with [iterables](https://github.com/abhijeetkalyan/rize/blob/master/lib/rize/iteration.rb). More on each follows:

### Functions

- `memoize` - Creates a new function that caches its results. Useful for expensive computations, which you may not want to re-run multiple times.
- `compose` - Takes in a list of functions, and creates a new function that composes them together. Useful if you have a bunch of smaller functions, and want to mix them up in various different ways.
- `partial` - Partially supply arguments to a function. Useful if you have some of the arguments now, but won't get the rest until later. Unlike the stdlib's `Proc#curry`, there are no restrictions on the positions of the arguments - you can have arguments 1 and 3 now, and tell `partial` to supply the second argument when it gets it.
- `at_most` - Allow a function to be called only a certain number of times. Useful for behaviours you don't want to retry endlessly, like attempting to connect to a database.
- `at_least` - Allow a function to work only *after* it's been called a certain number of times.

### Iterables

- `hmap` - A more concise way of mapping over the keys and values of a hash in one go.
- `hkeymap` - Map over just the keys of a hash, and leave the values as they are.
- `hvalmap` - Map over just the values of a hash, and leave the keys as they are.
- `hd` - Get the first element of an array.
- `tl` - Everything *but* the first element of an array. Useful in recursive functions.
- `frequencies` - Count the occurrences of each element in an array, or the occurrences of even numbers, or the occurrences of anything else, depending on the block you pass in.
- `map_n` - Map over multiple arrays at once. Useful when dealing with matrix operations and the like.
- `each_n` - Iterate over multiple arrays at once. Useful when dealing with matrix operations and the like.
- `repeat` - Repeat the passed in block a certain number of times. Useful when repeating repetitive(meta!) operations, like mass-assigning a bunch of random numbers or mass-creating a bunch of test factories.
- `lazy_repeat` - Lazy version of repeat.
- `flatter_map` - Map over the underlying elements of an array, regardless of how deeply the array is nested.


## Development

For initial setup:

```
bundle install
```

Run the tests:

```
rake test
```

To work with Rize in an interactive console:

```
bundle console
```



## Contributing

Bug reports and pull requests are welcome on [GitHub] (https://github.com/abhijeetkalyan/rize). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

Some interesting TODOs might include:

- Support timing-related functions such as `throttle` or `debounce` a la [Underscore](http://underscorejs.org/).
- Lazy versions of the iteration methods
- C/Java/other extensions for performance
- Support for passing methods as symbols instead of as method objects, such as `compose(:foo, :bar)` instead of `compose(method(:foo), method(:bar)`
- More methods available for iteration over multiple arrays at once, in addition to the already-existing `each_n` and `map_n`
- Integration with a cache such as Redis, to be 



## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
