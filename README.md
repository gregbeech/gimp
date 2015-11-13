# Gimp

Move issues between GitHub repositories.

## Usage

    $ gem install gimp
    $ gimp --help

Authentication uses GitHub access tokens, go to *Edit profile > Personal access tokens* and click *Generate new token*. The default permissions are fine.

Example usage:

    $ gimp --token your-access-token --source gregbeech/test-1 --destination gregbeech/test-2 --exclude-labels 'help wanted',question --issues 23,47

Or, more concisely:

    $ gimp -t your-access-token -s gregbeech/test-1 -d gregbeech/test-2 --exclude-labels 'help wanted',question -i 23,47

You can set defaults for all command line options in a `.gimp` file, for example:

```yaml
token: your-access-token
source: gregbeech/test-1
destination: gregbeech/test-2
labels:
  exclude:
    - help wanted
    - question
```

Which lets you run the above command by just specifying the issue numbers; much handier if you're typically moving between the same two repos.

    $ gimp -i 23,47

Remember to add an entry for `.gimp` to your `.gitignore` file so you don't commit your access token to the repo.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/gimp. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

