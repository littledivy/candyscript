# CandyScript

CandyScript is a lightweight yet superfast language for forging small web servers and RestAPIs.
[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

## Features

* Line-by-line parser
* One of the fastest web server powered by Nim's `asynchttpserver`
* Short and efficient
* No external database service required.
* < 85 lines of Nim code!
* A single binary for everything

## TODO

* [ ] Add backend integration with other languages
* [ ] Add multiple database integration
* [ ] Use `httpbeast` instead of `asynchttpserver`

## Example

### Hello, World!

```yaml
# this is a comment
GET "/": Hello, World!
```

## Building from source

Use the Nim compiler [nim](https://nim-lang.org) to compile Bloom source code.

This code will run your candyscript server.
```bash
nim c index.nim
./index your_script.candy
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)