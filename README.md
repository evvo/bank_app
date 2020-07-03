# bank_app

Example back-end API for bank-like app that uses memory for storing the data. Supports log-in, fetching/adding transactions, sorting and filtering.

Everything is in memory - the MemoryState class is holding all of the data.

## Installation

Install the required dependency shards:
```bash
shards install
```

Run the application:
```bash
crystal run src/bank_app.cr
```

## Usage

The available endpoints are in the `requests.http` file.

You can find example log-in details in the Initializer class (for example, mark/mark).

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/evvo/bank_app/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Evtimiy Mihaylov](https://github.com/evvo) - creator and maintainer
