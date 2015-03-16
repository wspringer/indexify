# README 

Sometimes you want to keep track of a collection of objects, but have that collection indexed by
different properties. This is where **indexify** might be useful:

```javascript
indexify = require('indexify');

var persons = indexify([
  { key: 'id',  extract: function(obj) { return obj.id; }, unique: true },
  { key: 'age', extract: function(obj) { return obj.age; }, unique: false }
]);

persons.add({ 
  id: '09707', age: 37
});
persons.add({ 
  id: '08227', age: 37
});

persons.by.age(37);     // two persons (an array)
persons.by.id('09707'); // one person (an object)
```

That's basically it. The only other thing you're currently able to do is remove objects from the
collection:

```javascript
persons.remove({ 
  id: '09707', age: 37
});
```

## Changes

### 0.3

* Add the ability to search for multiple values: `posts.by.tags('pet', 'house')`.


### 0.2

* If the `extract` function returns an array, then the index will be updated based on the individual
elements in the array. 



