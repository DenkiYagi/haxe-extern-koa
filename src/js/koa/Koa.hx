package js.koa;

import js.Promise;
import js.html.URL;
import js.node.net.Socket;
import js.node.net.Server.ServerListenOptionsTcp;
import js.node.net.Server.ServerListenOptionsUnix;
import js.node.http.Server;
import js.node.http.IncomingMessage;
import js.node.http.ServerResponse;
import haxe.Constraints.Function;
import externtype.Mixed2;
import externtype.ValueOrArray;

@:jsRequire("koa")
extern class Koa {
    function new();

    var proxy(default, default): Bool;
    var subdomainOffset(default, default): Int;
    var env(default, default): String;
    var request(default, never): RequestBase;
    var response(default, never): ResponseBase;
    var context(default, never): ContextBase;

    /**
     * Shorthand for:
     *
     *    http.createServer(app.callback()).listen(...)
     */
	@:overload(function(path: String, ?callback: Void -> Void): Server {})
	@:overload(function(handle: Mixed2<Dynamic, {fd: Int}>, ?callback: Void -> Void): Server {})
	@:overload(function(port: Int, ?callback: Void -> Void): Server {})
	@:overload(function(port: Int, backlog: Int, ?callback: Void -> Void): Server {})
	@:overload(function(port: Int, hostname: String, ?callback: Void -> Void): Server {})
	@:overload(function(port: Int, hostname: String, backlog: Int, ?callback:Void -> Void): Server {})
	function listen(options: Mixed2<ServerListenOptionsTcp, ServerListenOptionsUnix>, ?callback: Void -> Void): Server;

    /**
     * Return JSON representation.
     * We only bother showing settings.
     */
    function toJSON(): Dynamic<Dynamic>;
    /**
     * Inspect implementation.
     */
    function inspect(): Dynamic<Dynamic>;
    /**
     * Use the given middleware `fn`.
     *
     * Old-style middleware will be converted.
     */
    function use(middleware: Middleware): Koa;
    /**
     * Return a request handler callback
     * for node's native http server.
     */
    function callback(): Function;
}

extern class RequestBase {
    /**
     * Get/Set request header
     */
    var header(default, default): Dynamic<String>;
    /**
     * Get/Set request header, alias as request.header
     */
    var headers(default, default): Dynamic<String>;
    /**
     * Get/Set request URL
     */
    var url(default, default): String;
    /**
     * Get origin of URL
     */
    var origin(default, never): String;
    /**
     * Get full request URL
     */
    var href(default, never): String;
    /**
     * Get/Set request method
     */
    var method(default, default): String;
    /**
     * Get/Set request pathname, retaining the query-string when present
     */
    var path(default, default): String;
    /**
     * Get/Set parsed query-string
     */
    var query(default, default): Dynamic<Dynamic>;
    /**
     * Get/Set query string
     */
    var querystring(default, default): String;
    /**
     * Get the search string. Same as the querystring
     * except it includes the leading ?.
     *
     * Set the search string. Same as
     * response.querystring= but included for ubiquity.
     */
    var search(default, default): String;
    /**
     * Parse the "Host" header field host
     * and support X-Forwarded-Host when a
     * proxy is enabled.
     */
    var host(default, never): String;
    /**
     * Parse the "Host" header field hostname
     * and support X-Forwarded-Host when a
     * proxy is enabled.
     */
    var hostname(default, never): String;
    /**
     * Get WHATWG parsed URL.
     * Lazily memoized.
     */
    var URL(default, never): String;
    /**
     * Check if the request is fresh, aka
     * Last-Modified and/or the ETag
     * still match.
     */
    var fresh(default, never): Bool;
    /**
     * Check if the request is stale, aka
     * "Last-Modified" and / or the "ETag" for the
     * resource has changed.
     */
    var stale(default, never): Bool;
    /**
     * Check if the request is idempotent.
     */
    var idempotent(default, never): Bool;
    /**
     * Return the request socket.
     */
    var socket(default, never): Socket;
    /**
     * Get the charset when present or undefined.
     */
    var charset(default, never): String;
    /**
     * Return parsed Content-Length when present.
     */
    var length(default, never): Int;
    /**
     * Return the protocol string "http" or "https"
     * when requested with TLS. When the proxy setting
     * is enabled the "X-Forwarded-Proto" header
     * field will be trusted. If you're running behind
     * a reverse proxy that supplies https for you this
     * may be enabled.
     */
    var protocol(default, never): String;
    /**
     * Short-hand for:
     *
     *    this.protocol == 'https'
     */
    var secure(default, never): Bool;
    /**
     * When `app.proxy` is `true`, parse
     * the "X-Forwarded-For" ip address list.
     *
     * For example if the value were "client, proxy1, proxy2"
     * you would receive the array `["client", "proxy1", "proxy2"]`
     * where "proxy2" is the furthest down-stream.
     */
    var ips(default, never): Array<String>;
    /**
     * Return subdomains as an array.
     *
     * Subdomains are the dot-separated parts of the host before the main domain
     * of the app. By default, the domain of the app is assumed to be the last two
     * parts of the host. This can be changed by setting `app.subdomainOffset`.
     *
     * For example, if the domain is "tobi.ferrets.example.com":
     * If `app.subdomainOffset` is not set, this.subdomains is
     * `["ferrets", "tobi"]`.
     * If `app.subdomainOffset` is 3, this.subdomains is `["tobi"]`.
     */
    var subdomains(default, never): Array<String>;
    /**
     * Check if the given `type(s)` is acceptable, returning
     * the best match when true, otherwise `false`, in which
     * case you should respond with 406 "Not Acceptable".
     *
     * The `type` value may be a single mime type string
     * such as "application/json", the extension name
     * such as "json" or an array `["json", "html", "text/plain"]`. When a list
     * or array is given the _best_ match, if any is returned.
     *
     * Examples:
     *
     *     // Accept: text/html
     *     this.accepts('html');
     *     // => "html"
     *
     *     // Accept: text/*, application/json
     *     this.accepts('html');
     *     // => "html"
     *     this.accepts('text/html');
     *     // => "text/html"
     *     this.accepts('json', 'text');
     *     // => "json"
     *     this.accepts('application/json');
     *     // => "application/json"
     *
     *     // Accept: text/*, application/json
     *     this.accepts('image/png');
     *     this.accepts('png');
     *     // => false
     *
     *     // Accept: text/*;q=.5, application/json
     *     this.accepts(['html', 'json']);
     *     this.accepts('html', 'json');
     *     // => "json"
     */
    @:overload(function (): Array<String> {})
    function accepts(types: ValueOrArray<String>): Mixed2<String, Bool>;
    /**
     * Return accepted encodings or best fit based on `encodings`.
     *
     * Given `Accept-Encoding: gzip, deflate`
     * an array sorted by quality is returned:
     *
     *     ['gzip', 'deflate']
     */
    @:overload(function (): Array<String> {})
    function acceptsEncodings(encodings: ValueOrArray<String>): String;
    /**
     * Return accepted charsets or best fit based on `charsets`.
     *
     * Given `Accept-Charset: utf-8, iso-8859-1;q=0.2, utf-7;q=0.5`
     * an array sorted by quality is returned:
     *
     *     ['utf-8', 'utf-7', 'iso-8859-1']
     */
    @:overload(function (): Array<String> {})
    function acceptsCharsets(charsets: ValueOrArray<String>): String;
    /**
     * Return accepted languages or best fit based on `langs`.
     *
     * Given `Accept-Language: en;q=0.8, es, pt`
     * an array sorted by quality is returned:
     *
     *     ['es', 'pt', 'en']
     */
    @:overload(function (): Array<String> {})
    function acceptsLanguages(languages: ValueOrArray<String>): String;
    /**
     * Check if the incoming request contains the "Content-Type"
     * header field, and it contains any of the give mime `type`s.
     * If there is no request body, `null` is returned.
     * If there is no content type, `false` is returned.
     * Otherwise, it returns the first `type` that matches.
     *
     * Examples:
     *
     *     // With Content-Type: text/html; charset=utf-8
     *     this.is('html'); // => 'html'
     *     this.is('text/html'); // => 'text/html'
     *     this.is('text/*', 'application/json'); // => 'text/html'
     *
     *     // When Content-Type is application/json
     *     this.is('json', 'urlencoded'); // => 'json'
     *     this.is('application/json'); // => 'application/json'
     *     this.is('html', 'application/*'); // => 'application/json'
     *
     *     this.is('html'); // => false
     */
    function is(types: Array<String>): Null<Mixed2<String, Bool>>;
    /**
     * Return the request mime type void of
     * parameters such as "charset".
     */
    var type(default, never): String;
    /**
     * Return request header.
     *
     * The `Referrer` header field is special-cased,
     * both `Referrer` and `Referer` are interchangeable.
     *
     * Examples:
     *
     *     this.get('Content-Type');
     *     // => "text/plain"
     *
     *     this.get('content-type');
     *     // => "text/plain"
     *
     *     this.get('Something');
     *     // => undefined
     */
    function get(field: String): String;
    /**
     * Inspect implementation.
     */
    function inspect(): Dynamic<Dynamic>;
    /**
     * Return JSON representation.
     */
    function toJSON(): Dynamic;
}

extern class Request extends RequestBase {
    /**
     * Application instance reference.
     */
    var app(default, never): Koa;
    /**
     * Node's request object.
     */
    var req(default, never): IncomingMessage;
    /**
     *  Node's response object.
     *  Bypassing Koa's response handling is not supported. Avoid using the following node properties:
     *
     *      * res.statusCode
     *      * res.writeHead()
     *      * res.write()
     *      * res.end()
     */
    var res(default, never): ServerResponse;
    /**
     * A koa Context object.
     */
    var ctx(default, never): Context;
    /**
     * A koa Response object.
     */
    var response(default, never): Response;
    /**
     * Get request original URL.
     */
    var originalUrl(default, never): String;
    /**
     * Request remote address. Supports X-Forwarded-For when app.proxy is true.
     */
    var ip(default, never): String;
    var accept(default, never): Accept;
}

extern class ResponseBase {
    /**
     * Return the request socket.
     */
    var socket(default, never): Socket;
    /**
     * Return response header.
     */
    var header(default, never): Dynamic<String>;
    /**
     * Return response header, alias as response.header
     */
    var headers(default, never): Dynamic<String>;
    /**
     * Get/Set response status code.
     */
    var status(default, default): Int;
    /**
     * Get/Set response status message
     */
    var message(default, default): String;
    /**
     * Get/Set response body.
     */
    var body(default, default): Dynamic;
    /**
     * Get/Set Content-Length field
     */
    var length(default, default): Int;
    /**
     * Check if a header has been written to the socket.
     */
    var headerSent(default, never): Bool;
    /**
     * Vary on `field`.
     */
    function vary(field: String): Void;
    /**
     * Perform a 302 redirect to `url`.
     *
     * The string "back" is special-cased
     * to provide Referrer support, when Referrer
     * is not present `alt` or "/" is used.
     *
     * Examples:
     *
     *    this.redirect('back');
     *    this.redirect('back', '/index.html');
     *    this.redirect('/login');
     *    this.redirect('http://google.com');
     */
    function redirect(url: String, ?alt: String): Void;
    /**
     * Set Content-Disposition header to "attachment" with optional `filename`.
     */
    function attachment(filename: String): Void;
    /**
     * Return the response mime type void of
     * parameters such as "charset".

     * Set Content-Type response header with `type` through `mime.lookup()`
     * when it does not contain a charset.
     *
     * Examples:
     *
     *     this.type = '.html';
     *     this.type = 'html';
     *     this.type = 'json';
     *     this.type = 'application/json';
     *     this.type = 'png';
     */
    var type(default, default): String;
    /**
     * Get/Set the Last-Modified date.
     */
    var lastModified(default, default): Date;
    /**
     * Get/Set the ETag of a response.
     * This will normalize the quotes if necessary.
     *
     *     this.response.etag = 'md5hashsum';
     *     this.response.etag = '"md5hashsum"';
     *     this.response.etag = 'W/"123456789"';
     */
    var etag(default, default): String;
    /**
     * Check whether the response is one of the listed types.
     * Pretty much the same as `this.request.is()`.
     */
    function is(types: Array<String>): Null<Mixed2<String, Bool>>;
    /**
     * Return response header.
     *
     * Examples:
     *
     *     this.get('Content-Type');
     *     // => "text/plain"
     *
     *     this.get('content-type');
     *     // => "text/plain"
     */
    function get(field: String): String;
    /**
     * Set header `field` to `val`, or pass
     * an object of header fields.
     *
     * Examples:
     *
     *    this.set('Foo', ['bar', 'baz']);
     *    this.set('Accept', 'application/json');
     *    this.set({ Accept: 'text/plain', 'X-API-Key': 'tobi' });
     */
    @:overload(function(fields: Dynamic<Dynamic>): Void {})
    function set(field: String, val: ValueOrArray<String>): Void;
    /**
     * Append additional header `field` with value `val`.
     *
     * Examples:
     *
     * ```
     * this.append('Link', ['<http://localhost/>', '<http://localhost:3000/>']);
     * this.append('Set-Cookie', 'foo=bar; Path=/; HttpOnly');
     * this.append('Warning', '199 Miscellaneous warning');
     * ```
     */
    function append(field: String, val: ValueOrArray<String>): Void;
    /**
     * Remove header `field`.
     */
    function remove(name: String): Void;
    /**
     * Checks if the request is writable.
     * Tests for the existence of the socket
     * as node sometimes does not set it.
     */
    var writable(default, never): Bool;
    /**
     * Inspect implementation.
     */
    function inspect(): Dynamic<Dynamic>;
    /**
     * Return JSON representation.
     */
    function toJSON(): Dynamic;
    /**
     * Flush any set headers, and begin the body
     */
    function flushHeaders(): Void;
}

extern class Response extends ResponseBase {
    /**
     * Application instance reference.
     */
    var app(default, never): Koa;
    /**
     * Node's request object.
     */
    var req(default, never): IncomingMessage;
    /**
     *  Node's response object.
     *  Bypassing Koa's response handling is not supported. Avoid using the following node properties:
     *
     *      * res.statusCode
     *      * res.writeHead()
     *      * res.write()
     *      * res.end()
     */
    var res(default, never): ServerResponse;
    /**
     * A koa Context object.
     */
    var ctx(default, never): Context;
    /**
     * A koa Request object.
     */
    var request(default, never): Request;
}

extern class ContextBase implements Dynamic {
    /**
     * util.inspect() implementation, which
     * just returns the JSON output.
     */
    function inspect(): Dynamic<Dynamic>;
    /**
     * Return JSON representation.
     *
     * Here we explicitly invoke .toJSON() on each
     * object, as iteration will otherwise fail due
     * to the getters and cause utilities such as
     * clone() to fail.
     */
    function toJSON(): Dynamic<Dynamic>;
    /**
     * Similar to .throw(), adds assertion.
     *
     *    this.assert(this.user, 401, 'Please login!');
     *
     * See: https://github.com/jshttp/http-assert
     */
    function assert(value: Dynamic, status: Int, ?msg: String, ?opts: Dynamic<Dynamic>): Void;
    /**
     * Throw an error with `msg` and optional `status`
     * defaulting to 500. Note that these are user-level
     * errors, and the message may be exposed to the client.
     *
     *    this.throw(403)
     *    this.throw('name required', 400)
     *    this.throw(400, 'name required')
     *    this.throw('something exploded')
     *    this.throw(new Error('invalid'), 400);
     *    this.throw(400, new Error('invalid'));
     *
     * See: https://github.com/jshttp/http-errors
     */
    @:native("throw")
    function throwError(status: Int, ?msg: String, ?opts: Dynamic<Dynamic>): Void;

    // Response delegation
    /**
     * Set Content-Disposition header to "attachment" with optional `filename`.
     */
    function attachment(filename: String): Void;
    /**
     * Perform a 302 redirect to `url`.
     *
     * The string "back" is special-cased
     * to provide Referrer support, when Referrer
     * is not present `alt` or "/" is used.
     *
     * Examples:
     *
     *    this.redirect('back');
     *    this.redirect('back', '/index.html');
     *    this.redirect('/login');
     *    this.redirect('http://google.com');
     */
    function redirect(url: String, ?alt: String): Void;
    /**
     * Remove header `field`.
     */
    function remove(name: String): Void;
    /**
     * Vary on `field`.
     */
    function vary(field: String): Void;
    /**
     * Set header `field` to `val`, or pass
     * an object of header fields.
     *
     * Examples:
     *
     *    this.set('Foo', ['bar', 'baz']);
     *    this.set('Accept', 'application/json');
     *    this.set({ Accept: 'text/plain', 'X-API-Key': 'tobi' });
     */
    @:overload(function(fields: Dynamic<Dynamic>): Void {})
    function set(field: String, val: ValueOrArray<String>): Void;
    /**
     * Append additional header `field` with value `val`.
     *
     * Examples:
     *
     * ```
     * this.append('Link', ['<http://localhost/>', '<http://localhost:3000/>']);
     * this.append('Set-Cookie', 'foo=bar; Path=/; HttpOnly');
     * this.append('Warning', '199 Miscellaneous warning');
     * ```
     */
    function append(field: String, val: ValueOrArray<String>): Void;
    /**
     * Flush any set headers, and begin the body
     */
    function flushHeaders(): Void;
    /**
     * Get/Set response status code.
     */
    var status(default, default): Int;
    /**
     * Get/Set response status message
     */
    var message(default, default): String;
    /**
     * Get/Set response body.
     */
    var body(default, default): Dynamic;
    /**
     * Get/Set Content-Length field
     */
    var length(default, default): Int;
    /**
     * Return the response mime type void of
     * parameters such as "charset".

     * Set Content-Type response header with `type` through `mime.lookup()`
     * when it does not contain a charset.
     *
     * Examples:
     *
     *     this.type = '.html';
     *     this.type = 'html';
     *     this.type = 'json';
     *     this.type = 'application/json';
     *     this.type = 'png';
     */
    var type(default, default): String;
    /**
     * Get/Set the Last-Modified date.
     */
    var lastModified(default, default): Date;
    /**
     * Get/Set the ETag of a response.
     * This will normalize the quotes if necessary.
     *
     *     this.response.etag = 'md5hashsum';
     *     this.response.etag = '"md5hashsum"';
     *     this.response.etag = 'W/"123456789"';
     */
    var etag(default, default): String;
    /**
     * Check if a header has been written to the socket.
     */
    var headerSent(default, never): Bool;
    /**
     * Checks if the request is writable.
     * Tests for the existence of the socket
     * as node sometimes does not set it.
     */
    var writable(default, never): Bool;

    // Request delegation
    /**
     * Return accepted languages or best fit based on `langs`.
     *
     * Given `Accept-Language: en;q=0.8, es, pt`
     * an array sorted by quality is returned:
     *
     *     ['es', 'pt', 'en']
     */
    @:overload(function (): Array<String> {})
    function acceptsLanguages(languages: ValueOrArray<String>): String;
    /**
     * Return accepted encodings or best fit based on `encodings`.
     *
     * Given `Accept-Encoding: gzip, deflate`
     * an array sorted by quality is returned:
     *
     *     ['gzip', 'deflate']
     */
    @:overload(function (): Array<String> {})
    function acceptsEncodings(encodings: ValueOrArray<String>): String;
    /**
     * Return accepted charsets or best fit based on `charsets`.
     *
     * Given `Accept-Charset: utf-8, iso-8859-1;q=0.2, utf-7;q=0.5`
     * an array sorted by quality is returned:
     *
     *     ['utf-8', 'utf-7', 'iso-8859-1']
     */
    @:overload(function (): Array<String> {})
    function acceptsCharsets(charsets: ValueOrArray<String>): String;
    /**
     * Check if the given `type(s)` is acceptable, returning
     * the best match when true, otherwise `false`, in which
     * case you should respond with 406 "Not Acceptable".
     *
     * The `type` value may be a single mime type string
     * such as "application/json", the extension name
     * such as "json" or an array `["json", "html", "text/plain"]`. When a list
     * or array is given the _best_ match, if any is returned.
     *
     * Examples:
     *
     *     // Accept: text/html
     *     this.accepts('html');
     *     // => "html"
     *
     *     // Accept: text/*, application/json
     *     this.accepts('html');
     *     // => "html"
     *     this.accepts('text/html');
     *     // => "text/html"
     *     this.accepts('json', 'text');
     *     // => "json"
     *     this.accepts('application/json');
     *     // => "application/json"
     *
     *     // Accept: text/*, application/json
     *     this.accepts('image/png');
     *     this.accepts('png');
     *     // => false
     *
     *     // Accept: text/*;q=.5, application/json
     *     this.accepts(['html', 'json']);
     *     this.accepts('html', 'json');
     *     // => "json"
     */
    @:overload(function (): Array<String> {})
    function accepts(types: ValueOrArray<String>): Mixed2<String, Bool>;
    /**
     * Return request header.
     *
     * The `Referrer` header field is special-cased,
     * both `Referrer` and `Referer` are interchangeable.
     *
     * Examples:
     *
     *     this.get('Content-Type');
     *     // => "text/plain"
     *
     *     this.get('content-type');
     *     // => "text/plain"
     *
     *     this.get('Something');
     *     // => undefined
     */
    function get(field: String): String;
    /**
     * Check if the incoming request contains the "Content-Type"
     * header field, and it contains any of the give mime `type`s.
     * If there is no request body, `null` is returned.
     * If there is no content type, `false` is returned.
     * Otherwise, it returns the first `type` that matches.
     *
     * Examples:
     *
     *     // With Content-Type: text/html; charset=utf-8
     *     this.is('html'); // => 'html'
     *     this.is('text/html'); // => 'text/html'
     *     this.is('text/*', 'application/json'); // => 'text/html'
     *
     *     // When Content-Type is application/json
     *     this.is('json', 'urlencoded'); // => 'json'
     *     this.is('application/json'); // => 'application/json'
     *     this.is('html', 'application/*'); // => 'application/json'
     *
     *     this.is('html'); // => false
     */
    function is(types: Array<String>): Null<Mixed2<String, Bool>>;
    /**
     * Get/Set query string
     */
    var querystring(default, default): String;
    /**
     * Check if the request is idempotent.
     */
    var idempotent(default, default): Bool;
    /**
     * Return the request socket.
     */
    var socket(default, never): Socket;  //var socket(default, default): Socket;
    /**
     * Get the search string. Same as the querystring
     * except it includes the leading ?.
     *
     * Set the search string. Same as
     * response.querystring= but included for ubiquity.
     */
    var search(default, default): String;
    /**
     * Get/Set request method
     */
    var method(default, default): String;
    /**
     * Get/Set parsed query-string
     */
    var query(default, default): Dynamic<Dynamic>;
    /**
     * Get/Set request pathname, retaining the query-string when present
     */
    var path(default, default): String;
    /**
     * Get/Set request URL
     */
    var url(default, default): String;
    /**
     * Get origin of URL
     */
    var origin(default, never): String;
    /**
     * Get full request URL
     */
    var href(default, never): String;
    /**
     * Return subdomains as an array.
     *
     * Subdomains are the dot-separated parts of the host before the main domain
     * of the app. By default, the domain of the app is assumed to be the last two
     * parts of the host. This can be changed by setting `app.subdomainOffset`.
     *
     * For example, if the domain is "tobi.ferrets.example.com":
     * If `app.subdomainOffset` is not set, this.subdomains is
     * `["ferrets", "tobi"]`.
     * If `app.subdomainOffset` is 3, this.subdomains is `["tobi"]`.
     */
    var subdomains(default, never): Array<String>;
    /**
     * Return the protocol string "http" or "https"
     * when requested with TLS. When the proxy setting
     * is enabled the "X-Forwarded-Proto" header
     * field will be trusted. If you're running behind
     * a reverse proxy that supplies https for you this
     * may be enabled.
     */
    var protocol(default, never): String;
    /**
     * Parse the "Host" header field host
     * and support X-Forwarded-Host when a
     * proxy is enabled.
     */
    var host(default, never): String;
    /**
     * Parse the "Host" header field hostname
     * and support X-Forwarded-Host when a
     * proxy is enabled.
     */
    var hostname(default, never): String;
    /**
     * Get WHATWG parsed URL.
     * Lazily memoized.
     */
    var URL(default, never): URL;
    /**
     * Get/Set request header
     */
    var header(default, default): Dynamic<String>;
    /**
     * Get/Set request header, alias as request.header
     */
    var headers(default, default): Dynamic<String>;
    /**
     * Short-hand for:
     *
     *    this.protocol == 'https'
     */
    var secure(default, never): Bool;
    /**
     * Check if the request is stale, aka
     * "Last-Modified" and / or the "ETag" for the
     * resource has changed.
     */
    var stale(default, never): Bool;
    /**
     * Check if the request is fresh, aka
     * Last-Modified and/or the ETag
     * still match.
     */
    var fresh(default, never): Bool;
    /**
     * When `app.proxy` is `true`, parse
     * the "X-Forwarded-For" ip address list.
     *
     * For example if the value were "client, proxy1, proxy2"
     * you would receive the array `["client", "proxy1", "proxy2"]`
     * where "proxy2" is the furthest down-stream.
     */
    var ips(default, never): Array<String>;
    /**
     * Request remote address. Supports X-Forwarded-For when app.proxy is true.
     */
    var ip(default, never): String;
}

extern class Context extends ContextBase {
    /**
     * Application instance reference.
     */
    var app(default, never): Koa;
    var request(default, never): Request;
    var response(default, never): Response;
    /**
     * Node's request object.
     */
    var req(default, never): IncomingMessage;
    /**
     *  Node's response object.
     *  Bypassing Koa's response handling is not supported. Avoid using the following node properties:
     *
     *      * res.statusCode
     *      * res.writeHead()
     *      * res.write()
     *      * res.end()
     */
    var res(default, never): ServerResponse;
    /**
     * Get request original URL.
     */
    var originalUrl(default, never): String;
    /**
     * Get cookies.
     */
    var cookies(default, never): Cookies;
    var accept(default, never): Accept;
    /**
     * The recommended namespace for passing information through middleware and to your frontend views.
     */
    var state(default, never): Dynamic<Dynamic>;
    /**
     * To bypass Koa's built-in response handling, you may explicitly set `ctx.respond = false;`
     */
    var respond(default, default): Null<Bool>;
}

extern class Accept {
    /**
     * Return the first accepted charset. If nothing in `charsets` is accepted, then `false` is returned.
     * If no charsets are supplied, all accepted charsets are returned, in the order of the client's preference
     * (most preferred first).
     */
    @:overload(function (): Array<String> {})
    function charset(charsets: ValueOrArray<String>): Mixed2<String, Bool>;

    /**
     * Return the first accepted charset. If nothing in `charsets` is accepted, then `false` is returned.
     * If no charsets are supplied, all accepted charsets are returned, in the order of the client's preference
     * (most preferred first).
     */
    @:overload(function (): Array<String> {})
    function charsets(charsets: ValueOrArray<String>): Mixed2<String, Bool>;

    /**
     * Return the first accepted encoding. If nothing in `encodings` is accepted, then `false` is returned.
     * If no encodings are supplied, all accepted encodings are returned, in the order of the client's preference
     * (most preferred first).
     */
    @:overload(function (): Array<String> {})
    function encoding(encodings: ValueOrArray<String>): Mixed2<String, Bool>;

    /**
     * Return the first accepted encoding. If nothing in `encodings` is accepted, then `false` is returned.
     * If no encodings are supplied, all accepted encodings are returned, in the order of the client's preference
     * (most preferred first).
     */
    @:overload(function (): Array<String> {})
    function encodings(encodings: ValueOrArray<String>): Mixed2<String, Bool>;

    /**
     * Return the first accepted language. If nothing in `languages` is accepted, then `false` is returned.
     * If no languaes are supplied, all accepted languages are returned, in the order of the client's preference
     * (most preferred first).
     */
    @:overload(function (): Array<String> {})
    function language(languages: ValueOrArray<String>): Mixed2<String, Bool>;

    /**
     * Return the first accepted language. If nothing in `languages` is accepted, then `false` is returned.
     * If no languaes are supplied, all accepted languages are returned, in the order of the client's preference
     * (most preferred first).
     */
    @:overload(function (): Array<String> {})
    function languages(languages: ValueOrArray<String>): Mixed2<String, Bool>;

    /**
     * Return the first accepted language. If nothing in `languages` is accepted, then `false` is returned.
     * If no languaes are supplied, all accepted languages are returned, in the order of the client's preference
     * (most preferred first).
     */
    @:overload(function (): Array<String> {})
    function lang(languages: ValueOrArray<String>): Mixed2<String, Bool>;

    /**
     * Return the first accepted language. If nothing in `languages` is accepted, then `false` is returned.
     * If no languaes are supplied, all accepted languages are returned, in the order of the client's preference
     * (most preferred first).
     */
    @:overload(function (): Array<String> {})
    function langs(languages: ValueOrArray<String>): Mixed2<String, Bool>;

    /**
     * Return the first accepted type (and it is returned as the same text as what appears in the `types` array). If nothing in `types` is accepted, then `false` is returned.
     * If no types are supplied, return the entire set of acceptable types.
     *
     * The `types` array can contain full MIME types or file extensions. Any value that is not a full MIME types is passed to `require('mime-types').lookup`.
     */
    function type(types: ValueOrArray<String>): Mixed2<ValueOrArray<String>, Bool>;

    /**
     * Return the first accepted type (and it is returned as the same text as what appears in the `types` array). If nothing in `types` is accepted, then `false` is returned.
     * If no types are supplied, return the entire set of acceptable types.
     *
     * The `types` array can contain full MIME types or file extensions. Any value that is not a full MIME types is passed to `require('mime-types').lookup`.
     */
    function types(types: ValueOrArray<String>): Mixed2<ValueOrArray<String>, Bool>;
}

extern class Cookies {
    var secure(default, never): Bool;
    var request(default, never): IncomingMessage;
    var response(default, never): ServerResponse;
    /**
     * This extracts the cookie with the given name from the
     * Cookie header in the request. If such a cookie exists,
     * its value is returned. Otherwise, nothing is returned.
     */
    function get(name: String, ?opts: CookiesGetOptions): Null<String>;
    /**
     * This sets the given cookie in the response and returns
     * the current context to allow chaining.If the value is omitted,
     * an outbound header with an expired date is used to delete the cookie.
     */
    function set(name: String, ?value: String, ?opts: CookiesSetOptions): Cookies;
}

typedef CookiesGetOptions = {
    var signed: Bool;
}

typedef CookiesSetOptions = {
    /**
     * a number representing the milliseconds from Date.now() for expiry
     */
    @:optional var maxAge: Int;
    /**
     * a Date object indicating the cookie's expiration
     * date (expires at the end of session by default).
     */
    @:optional var expires: Date;
    /**
     * a string indicating the path of the cookie (/ by default).
     */
    @:optional var path: String;
    /**
     * a string indicating the domain of the cookie (no default).
     */
    @:optional var domain: String;
    /**
     * a boolean indicating whether the cookie is only to be sent
     * over HTTPS (false by default for HTTP, true by default for HTTPS).
     */
    @:optional var secure: Bool;
    /**
     * "secureProxy" option is deprecated; use "secure" option, provide "secure" to constructor if needed
     */
    @:optional var secureProxy: Bool;
    /**
     * a boolean indicating whether the cookie is only to be sent over HTTP(S),
     * and not made available to client JavaScript (true by default).
     */
    @:optional var httpOnly: Bool;
    /**
     * a boolean or string indicating whether the cookie is a "same site" cookie (false by default).
     * This can be set to 'strict', 'lax', or true (which maps to 'strict').
     */
    @:optional var sameSite: CookieSameSite;
    /**
     * a boolean indicating whether the cookie is to be signed (false by default).
     * If this is true, another cookie of the same name with the .sig suffix
     * appended will also be sent, with a 27-byte url-safe base64 SHA1 value
     * representing the hash of cookie-name=cookie-value against the first Keygrip key.
     * This signature key is used to detect tampering the next time a cookie is received.
     */
    @:optional var signed: Bool;
    /**
     * a boolean indicating whether to overwrite previously set
     * cookies of the same name (false by default). If this is true,
     * all cookies set during the same request with the same
     * name (regardless of path or domain) are filtered out of
     * the Set-Cookie header when setting this cookie.
     */
    @:optional var overwrite: Bool;
}

@:enum abstract CookieSameSite(Dynamic) {
    var Strict = "strict";
    var Lax = "lax";
    var None = false;
}


typedef Middleware = Mixed2<Context -> Next -> Void, Context -> Next -> Promise<Void>>;
typedef Next = Void -> Promise<Void>;