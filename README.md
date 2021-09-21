# maturin-manylinux-wheels-action

Build manylinux wheels for a Python package with Rust bindings with [maturin](https://github.com/PyO3/maturin) as a build back-end.

This action uses the [manylinux](https://github.com/pypa/manylinux) Docker containers to
build manylinux wheels for a Python package. The wheels are placed in a
new directory `<package-path>/dist` and can be uploaded to PyPI in the next step of your workflow.

### Fork of [RalfG/python-wheels-manylinux-build](https://github.com/RalfG/python-wheels-manylinux-build)

This is a quite specific use case, but feel free to fork and adapt to your own needs.

## Usage

### Requirements

* Your project must have a `pyproject.toml` and use [poetry](https://github.com/python-poetry/poetry) for dependency management. You can define which Python packages need to be installed before build that way. `poetry update` is run on your package before compilation.
* Your build back-end must be maturin, i.e. you have a Python project with Rust extensions.

### Example
Minimal:

```yaml
uses: tmtenbrink/python-wheels-manylinux-build@1.0.0
with:
  python-versions: 'cp36-cp36m cp37-cp37m'
```

Using all arguments:

```yaml
uses: tmtenbrink/python-wheels-manylinux-build@1.0.0
with:
  py-version: '3.9'
  py-pep-425: 'cp39-cp39'
  system-packages: 'lrzip-devel zlib-devel'
  pre-build-command: 'sh pre-build-script.sh'
  package-path: 'my_project'
```

See
[test.yml](https://github.com/tmtenbrink/maturin-manylinux-wheels-action/.github/workflows/test.yml)
for a complete example that uploads the finished wheels as an artifact. If you want to build for multiple versions of Python, you can use a matrix, for example look at [wheels.yml](https://github.com/tmtenbrink/rustfrc/blob/main/.github/workflows/wheels.yml).


### Inputs

| name | description | required | default | example(s) |
| - | - | - | - | - |
| `py-version` | Python execution version | required | `'3.9'` | `'cp36-cp36m cp37-cp37m'` |
| `py-pep-425` | Python version tagsfor which to build (PEP 425 tags) wheels, as described in the [manylinux image documentation](https://github.com/pypa/manylinux) | required | `'cp39-cp39'` | `'cp36-cp36m'` |
| `build-requirements` | Python (pip) packages required at build time, space-separated | optional | `''` | `'cython'` or `'cython==0.29.14'` |
| `system-packages` | System (yum) packages required at build time, space-separated | optional | `''` | `'lrzip-devel zlib-devel'` |
| `pre-build-command` | Command to run before build, e.g. the execution of a script to perform additional build-environment setup | optional | `''` | `'sh pre-build-script.sh'` |
| `package-path` | Path to Python package to build (e.g. where `pyproject.toml` file is located), relative to repository root | optional | `''` | `'my_project'` |

### Output
The action creates wheels, by default in the `<package-path>/dist` directory. 

### Using a different manylinux container
The `manylinux2010_x86_64` container is used by default. 

## Contributing
Bugs, questions or suggestions? Feel free to post an issue in the
[issue tracker](https://github.com/RalfG/python-wheels-manylinux-build/issues)
or to make a pull request!
