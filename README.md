# statuspixel

**`[WIP]`**

display color-coded status of stuff with LED pixels.

## Demo

OpenGL Simulator:

```shell
git clone https://github.com/eins78/statuspixel
cd statuspixel
npm install
npm run demo
```

![GIF of demo](https://cloud.githubusercontent.com/assets/134942/5794524/d8d94c6e-9f71-11e4-805e-effd4e89590f.gif)


## JSON Configuration

See the [example below](#example) and consult this description if questions arise. The example has two sections, the first is the most minimal, the other is the most verbose config.

- **`colors`**: Object. Keys are names of colors to be used in rest of config, values are valid `CSS` color strings (names, hex, hsl, …).
- **`sections`**: Array of Objects with keys:
    - `id`: unique short name of section (word-characters allowed)
    - `description`: optional description of the section
    - `start`: the first pixel which belongs to the section, it will go to the end or one pixel before the next section
    - a key for one of the runners, like:
        - `command`: run a shell command
        - `request`: make a HTTP request
    - `expect`: hash of expectations on (at least one of) the following values (see below for possible expectations):
        - `status`: exit status of `command`, or http status of `request`
        - `output`: `stdout` of `command`, or `res` of `request`
        - `error`: `stderr` of `command`, or `err` of `request`
    
- `ok`: if `assert` was true, set section to this color
- `fail`: if `assert` was false, set section to this color


### Runners

#### `request`

Make a HTTP request [powered by the request module][`request`].

See API there, short synopsis below.

1. Setting it to an URL string makes a `GET` request to this URL.

    ```json
    {
      "request": "http://example.com"
    }
    ```

2. Setting it to an hash enables all the bells and whistles:

    ```json
    {
      "request": {
        "method": "GET",
        "url": "https://example.com",
        "qs": { "query": "foobar" },
        "auth": {
          "user": "username",
          "pass": "password",
          "sendImmediately": false
        },
        "headers": {
          "User-Agent": "statuspixel"
        }
      }
    }
    ```

### Expectations

Can be in one of the following forms
- simple value (number, string): must be exactly equal to compared value
- hash of "comparators" from [the `ruler` module][`ruler`] and the value to compare.


<!-- automatic assertions (no need to add those):
- `{ "status": { truthy: "" } }`
- `{ "err": { falsy: "" } }` -->

### Example 

[see here](https://github.com/eins78/statuspixel/blob/master/examples/config.json)


## CLI

`./draft.coffee examples/config.json -vv`

### config

First argument must be the path to a [config file](#json-configuation).

### loglevel

Set console log level by appending one or more `-v`'s.
`-v` is 'info', `-vv` is 'verbose', `-vvv` is 'debug'.


## Credits

The whole project uses lots of great free/open modules and projects:

- <https://github.com/scanlime/fadecandy>
- <http://openpixelcontrol.org>
- <https://www.npmjs.com/package/open-pixel-control>
- <https://www.npmjs.com/package/request>
- <https://www.npmjs.com/package/ruler>
- <https://www.npmjs.com/package/async>
- <https://lodash.com>
- <https://www.npmjs.com/package/must>

It is written in [CoffeScript](http://coffeescript.org).


[`must`]: <https://github.com/moll/js-must/blob/master/doc/API.md>
[`ruler`]: <https://www.npmjs.com/package/ruler>
[`request`]: <https://www.npmjs.com/package/request>
