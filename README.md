# Haxe extern definitions for Koa.js
## Install
```
haxelib git koa https://github.com/DenkiYagi/haxe-extern-koa
```

## Example
```haxe
var app = new Koa();

app.use(function (ctx, next) {
    ctx.body = "Hello World!";
});

app.listen(3000);
```
