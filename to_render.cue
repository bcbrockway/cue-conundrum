package main

#ConfigSchema: {
  foo: string
  bar: string
}

config: #ConfigSchema & _

fooBarCombined: {
  msg: "\(config.foo)\(config.bar)"
}

foo: {
  msg: config.foo
}

bar: {
  msg: config.bar
}
