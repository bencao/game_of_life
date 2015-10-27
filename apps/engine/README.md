# Engine

Engine is the core where evolution happens.
It maintains a state of current world, and triggers the evolution of the cells into their next step.

As a service, it offers some public API so external services can either `load` a new world into engine, or `inspect` current world status.
