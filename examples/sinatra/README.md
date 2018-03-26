# Sinatra server example

## Installation

```bash
cp config-trustchain.json.example config-trustchain.json
# edit to add your credentials

bundle install
```

## Usage

```bash
ruby config.ru
```

Note:

User tokens are generated only once and never stored. In a real application you should implement a persistent storage.
