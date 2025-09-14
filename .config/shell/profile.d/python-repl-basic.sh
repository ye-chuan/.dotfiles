# Make Python 3.13 onward fallback to the basic repl which
# uses readline / libedit since they have no current plans
# of implementing vim bindings in PyREPL
#
# Though this means we will lose certain features of PyREPL
# but we'll wait to see if there are any deal-breaking
# features

export PYTHON_BASIC_REPL=1

