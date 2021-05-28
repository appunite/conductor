# Changelog

## 0.5.0 (2021-05-28)

- Fixed compilation error when tuple contains more than 2 scopes [#6](https://github.com/appunite/conductor/pull/6)

## 0.4.0 (2019-01-24)

- Allowed to require multiple scopes at once [#5](https://github.com/appunite/conductor/pull/5)

## 0.3.0 (2017-09-26)

- Global customization of failure responses [#3](https://github.com/appunite/conductor/pull/3)

## 0.2.1 (2017-06-19)

- Readme and docs improvement

## 0.2.0 (2017-05-28)

- **BREAKING** `root_scope` config replaced by `root_scopes`, it has to be list now
- `@authorize` now accepts `:scope` or `:scopes` for respectively single scope and list of scopes
- Compilation error will be raised when single `@authorize` attribute contain both `:scope` and `:scopes`
