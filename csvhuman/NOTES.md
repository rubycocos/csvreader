# Notes

## Todos

- [ ] check if `+id` is always a number type (for auto-conversion) e.g. `#event+id`
- [ ] add check for `#geo` and `+lat`, `+lon` (for auto-conversion) to floats
- [ ] add type converter for `#date` (e.g. `#date+start`, `#date+reported`, etc.) - support 2017-12-11 and 11/14/2017 for now?
- [ ] header converter for symbols - turn `+` into `_x_` or `_I_` or into `$` - why? why not? (check if `$` supported in ruby inline? - no, it's not possible)


## Examples

Add more .csv examples with hxl tags, see <https://tools.humdata.org/examples/hxl/>






### Use `$` in symbol for `+`

#### Ruby

```
>> s = :adm1
=> :adm1
>> s = :adm1_x_code
=> :adm1_x_code
>> s = :adm1$code
SyntaxError: (irb):3: syntax error, unexpected tGVAR, expecting end-of-input
```
