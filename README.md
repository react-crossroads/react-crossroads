# React Crossroads

Client side router for web applications built with React and utilizing the Flux architecture. The backing routing engine is [CrossroadsJs](http://millermedeiros.github.io/crossroads.js/).

# Running the integration tests

The tests need to be able to find chromedriver on the path. On mac install via homebrew with `brew install chromedriver` then run:

```bash
$ gulp integration-test-ci
```

If you are actively working on the codebase then open two bash shells, and on the first one run the integration test server:

```bash
$ gulp integration-test-server
```

Then you can open the integration test pages in your browser to debug, in your second shell you can run the tests at any time agains that server:

```bash
$ gulp integration-test
```
