# Haxe extern definitions for Koa.js
## Install
```
haxelib install koa
```

## Example
```haxe
var app = new Koa();

app.use(function (ctx, next) {
    ctx.body = "Hello World!";
});

app.listen(3000);
```