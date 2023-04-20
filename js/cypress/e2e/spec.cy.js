describe('basics', () => {
  it('renders a button', () => {
    cy.visit('http://localhost:8001/renders-a-button')

    cy.get('button').contains('click me')
  })

  it('applies attributes', () => {
    cy.visit('http://localhost:8001/basics-and-attributes')

    cy.get('#identifierAttr').contains('id test')
    cy.get('[name]').contains('name test')
    cy.get('[type]').contains('type test')
  })
})

describe('a counter', () => {
  it('starts at 0', () => {
    cy.visit('http://localhost:8001/counter')

    cy.get('.counter-display').contains('0')
  })

  it('counts up', () => {
    cy.visit('http://localhost:8001/counter')

    cy.get('#increment').click()
    cy.get('.counter-display').contains('1')
  })

  it('counts down', () => {
    cy.visit('http://localhost:8001/counter')

    cy.get('#decrement').click()
    cy.get('.counter-display').contains('-1')
  })
})

describe('a text input', () => {
  it('displays the entered text', () => {
    cy.visit('http://localhost:8001/text-input')

    cy.get('#text-field').type('hello world')
    cy.get('#text-submit').click()
    cy.get('#text-display').contains('{"text":"hello world"}')
  })
})

// describe('getting the weather', () => {
//   it('displays the weather for a given lat/lon', () => {
//     cy.visit('http://localhost:8001/weather')
//
//     cy.get('#lat-entry').type('11216')
//     cy.get('#lon-entry').type('11216')
//     cy.get('#submit').click()
//   })
// })

describe('blur and change', () => {
  it('displays the information after a blur', () => {
    cy.visit('http://localhost:8001/blur-and-change')

    cy.get('#text-field').type('hello world', { force: true }).blur()

    cy.get('#text-display').contains('{"text":"hello world"}')
  })

  it('displays the entered information after a change', () => {

  })

})
