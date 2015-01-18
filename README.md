# statuspixel

**`[WIP]`**

display color-coded status of stuff with LED pixels.

## Configuration

See the JSON example and consult this description if questions arise.

- **`colors`**: Object. Keys are names of colors to be used in rest of config, values are valid `CSS` color strings (names, hex, hsl, …).
- **`sections`**: Array of Objects with keys:
    - `id`: unique short name of section (word-characters allowed)
    - `description`: optional description of the section
    - `start`: the first pixel which belongs to the section, it will go to the end or one pixel before the next section
    - one of:
        - `command`: run a shell command
        - `request`: make a HTTP request
    - `must`: hash of assertion(s) on (at least one of) the following values (see below for possible assertions):
        - `status`: exit status of `command`, or http status of `request`
        - `output`: `stdout` of `command`, or `res` of `request`
        - `error`: `stderr` of `command`, or `err` of `request`
    
- `ok`: if `assert` was true, set section to this color
- `fail`: if `assert` was false, set section to this color

assertion: can be in one of the following forms
- simple value (number, string): must be exactly equal to compared value
- hash of "expectations", which are just names of [methods from the `must` module][] and the value to compare.

```json
{
  "colors": {
    "green": "green",
    "red": "red",
    "white": "#ccc"
  },
  "sections": [
    {
      "id": "ping_npm",
      "description": "ping npmjs.com",
      "start": 0,
      "command": "ping -W 1 -c 1 npmjs.com",
      "must": {
        "status": 0
      },
      "ok": "green",
      "fail": "red"
    },
    {
      "id": "get_npm",
      "description": "HTTP GET npmjs.com",
      "start": 30,
      "request": "http://npmjs.com",
      "must": {
        "status": {
          "least": 200,
          "below": 300
        },
        "output": {
          "include": "package manager"
        }
      },
      "ok": "green",
      "fail": "red"
    }
  ]
}
```


[`must`]: <https://github.com/moll/js-must/blob/master/doc/API.md>
