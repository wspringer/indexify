expect = (require 'chai').expect
_ = require 'lodash'
indexify = require '../src/index'

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

  it 'should index extracted arrays by its elements', ->
    tagged = indexify [
      key: 'tags'
      extract: (obj) -> obj.tags
      unique: false
    ]
    tagged.add { post: 'foo', tags: ['node', 'scala']}
    tagged.add { post: 'bar', tags: ['node']}
    expect(tagged.by.tags('node')).to.have.length(2)
    expect(tagged.by.tags('scala')).to.have.length(1)

  it 'should index duplicates in arrays only once', ->
    tagged = indexify [
      key: 'tags'
      extract: (obj) -> obj.tags
      unique: false
    ]
    tagged.add { post: 'foo', tags: ['node', 'node']}
    expect(tagged.by.tags('node')).to.have.length(1)

  it 'should accept multiple keys when filtering for non-unique indexes', ->
    tagged = indexify [
      key: 'tags'
      extract: (obj) -> obj.tags
      unique: false
    ]
    tagged.add { post: 'foo', tags: ['pet', 'door'] }
    tagged.add { post: 'bar', tags: ['pet', 'bike'] }
    expect(tagged.by.tags('pet', 'door')).to.have.length(1)
    expect(tagged.by.tags('pet', 'bike')).to.have.length(1)

  it 'should throw an error in case the arguments for filtering are wrong', ->
    posts = indexify [
      key: 'tags'
      extract: (obj) -> obj.tags
      unique: false
    ,
      key: 'title',
      extract: (obj) -> obj.title
      unique: true
    ]
    posts.add { post: 'foo', tags: ['pet', 'door'] }
    posts.add { post: 'bar', tags: ['pet', 'bike'] }
    expect(-> posts.by.tags()).to.throw 'Expecting at least one value to search for'



