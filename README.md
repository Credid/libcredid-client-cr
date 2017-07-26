# auth-api

The client API of [auth-server](https://github.com/Nephos/auth-server)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  auth-api:
    github: Nephos/auth-api
```

## Usage

```crystal
require "auth-api"
api = Auth::Api.new(ip: "127.0.0.1", port: 8999_u16, username: "root", passowrd: "toor")
puts api.auth!
puts api.has_access_to? "/tmp", "write" if api.success?
```

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/Nephos/auth-api/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [Nephos](https://github.com/Nephos) Arthur Poulet - creator, maintainer
