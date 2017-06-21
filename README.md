# matplotlib-cl

[![Build Status](https://travis-ci.org/koji-kojiro/matplotlib-cl.svg?branch=master)](https://travis-ci.org/koji-kojiro/matplotlib-cl)

**matplotlib-cl** is a 2D plotting library for Common Lisp, which provides a simple interface to _Matplotlib_ plotting API.

## Usage

Most pyplot functions are avilable. You can refer to the parameter `plt:*pyplot-functions*` to get the complete list of availble APIs. See also [_documantation of pyplot_](http://matplotlib.org/api/pyplot_summary.html) for the detailed usage of each functions.

## Requirements

**matplotlib-cl** is depending on both _Python_ and _Matplotlib_. Please confirm both of these are installed on your PC.

On Debian-like systems: `$ sudo apt-get install python-matplotlib python2.7-dev`

**Note: Python3.x is NOT supported.**

## Example

Here is a simple example ported from [_tutorial of Matplotlib_](https://matplotlib.org/examples/pylab_examples/simple_plot.html).

```lisp
(ql:quickload :matplotlib-cl :silent t)

(defvar *t* (loop for x from 0 below 2 by 0.01 collect x))
(defvar *s* (mapcar (lambda (x) (1+ (sin (* 2 PI x)))) *t*))

(defun main ()
  (plt:plot *t* *s*)

  (plt:xlabel "time (s)")
  (plt:ylabel "voltage (mV)")
  (plt:title "About as simple as it gets, folks")
  (plt:grid t)
  (plt:savefig "test.png")
  (plt:show))
```

## License

Licensed under [MIT License](LICENSE).

## Author

[TANI Kojiro](https://github.com/koji-kojiro) (kojiro0531@gmail.com)
