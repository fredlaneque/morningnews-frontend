describe('login', () => {
    it('passes', () => {
      cy.visit('http://localhost:3001')
      cy.wait(2000)
      cy.get("svg[data-icon='user']").click()
      cy.wait(2000)
      cy.get("input[id='signInUsername']").type("User1")
      cy.wait(2000)
      cy.get("input[id='signInPassword']").type("User1")
      cy.wait(2000)
      cy.get("button[id='connection']").click()
      cy.wait(2000)
      cy.contains("Welcome User1")
      cy.wait(2000)
    })
  })