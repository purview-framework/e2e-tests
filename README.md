# e2e-tests

Integration tests for Purview, run with cypress.

### Running the tests

You'll need node version 16.14.0, which can be managed with nvm.

1. Start the server with `cabal exec e2e-tests` after building
2. Open cypress by cd'ing to `js` and `npx cypress open`
