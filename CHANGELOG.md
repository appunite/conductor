# Changelog

## 0.3.0

* failure responses global customization

## 0.2.1

* readme and docs improvement

## 0.2

* **BREAKING** `root_scope` config replaced by `root_scopes`, it has to be list now
* `@authorize` now accepts `:scope` or `:scopes` for respectively single scope and list of scopes
* compilation error will be raised when single `@authorize` attribute contain both `:scope` and `:scopes`
