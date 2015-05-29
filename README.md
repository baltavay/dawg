# Dawg

Deterministic acyclic finite state automaton in ruby

## Installation

Add this line to your application's Gemfile:

    gem 'dawg'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dawg

## Usage
    # Words must be added in alphabetical order
    dawg = Dawg.new
    dawg.insert("cat")
    dawg.insert("dog")
    dawg.finish

    dawg.lookup("cat")
    => true
    dawg.find_similar("ca")
    => ["cat"]

    dawg.save("dawg.dat")
    dawg = Dawg.load("dawg.dat")


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
