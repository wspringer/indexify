expect = (require 'chai').expect
_ = require 'lodash'
indexify = require '../src/indexify'

example = () -> indexify [
  key: 'id'
  extract: (obj) -> obj.id
  unique: true
,
  key: 'given'
  extract: (obj) -> obj.given
  unique: false
]
person1 = { id: "foo", given: "wilfred" }
person2 = { id: "bar", given: "martine" }
person3 = { id: "baz", given: "martine" }

describe 'indexify', ->

  it 'should allow you to add and retrieve objects', ->
    people = example()
    people.add person1
    expect(people.by.id("foo")).to.equal person1
    expect(people.by.given("wilfred")).to.contain person1

  it 'should allow you to remove objects', ->
    people = example()
    people.add person1
    people.add person2
    expect(people.by.id("bar")).to.equal person2
    people.remove person2
    expect(people.by.id("bar")).to.be.undefined

  it 'should support non-unique indexes', ->
    people = example()
    people.add person2
    people.add person3
    expect(people.by.id("bar")).to.equal person2
    expect(people.by.id("baz")).to.equal person3
    expect(people.by.given("martine")).to.have.length(2)

    

