
**Challenge #3 We have a nested object, we would like a function that you pass in the object and a key and get back the value. How this is implemented is up to you. Example Inputs object = {“a”:{“b”:{“c”:”d”}}} key = a/b/c object = {“x”:{“y”:{“z”:”a”}}} key = x/y/z value = a

**Script


var object = {"a": { "b": { "c": "d" }}};

console.log("Result at 'a.b.c': ",_.get(object, 'a.b.c'));

var object2 = {"x":{"y":{"z":"a"}}};
console.log("Result at 'x.y.z': ",_.get(object2, 'x.y.z'));

<script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.11/lodash.js"></script>



**OutPut

"Result at 'a.b.c': "
"d"
"Result at 'x.y.z': "
"a"

![OutputFile](https://user-images.githubusercontent.com/55081476/130342657-916fbeb3-8567-4241-a6b6-48cbd2984d2b.png)

