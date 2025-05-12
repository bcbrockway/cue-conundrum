# cue-conundrum

I'm trying to use two YAML files as an input to the dump command as per the example below:

```
cue cmd dump --inject files=input1.yaml,input2.yaml
```

The combined output of these files should used as the input for the `config` field (in
[to_render.cue](./to_render.cue)). It should conform to `#ConfigSchema` and the `fooBarCombined`, `foo` and `bar`
objects inside [to_render.cue](./to_render.cue) should be able to pull the values from this field.

Lastly, the dump command should output the `fooBarCombined`, `foo` and `bar` objects as a `---`-separated YAML stream.
