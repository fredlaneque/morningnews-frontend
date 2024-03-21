const { defineConfig } = require("cypress");

module.exports = defineConfig({
  configs: {
    e2e: {
      supportFile: "cypress/support/e2e.js",
      testFiles: "cypress/e2e/*.cy.js",
      fixturesFolder: "cypress/fixtures",
    },
  },

  e2e: {
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
});
