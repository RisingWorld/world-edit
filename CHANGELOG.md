## 2015-09-13

* Implemented `/we plant`
* Moved `string-ext` and `table-ext` to a combined `lua-ext` for less module dependencies

## 2015-05-12

* Added `string-ext` sub-module to wrap long lines when displaying help (i.e. `/we help`)
* All terrain textures are now listed and available with `/we fill`, type `/we help fill` for more info.

## 2015-05-01

* Moved `table-ext.lua` in it's own [sub-module](https://github.com/RisingWorld/table-ext).
* the `config` object is no longer a global variable
* Updated README

## 2015-04-28

* fixed label not being reset on `/we cancel` if no selection was made. This was resulted after the update 0.5.6.7, which fixed possible invalid selection in the marking selector API.
* All commands involving a marking selector now have a `-p` (i.e. "preserve") flag to preserve the current marking selector status object (if one exists).