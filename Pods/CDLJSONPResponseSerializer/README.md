# CDLJSONPResponseSerializer

This is a class to parse JSONP responses with AFNetworking. It uses Javascript
contexts provided by the JavaScriptCore framework.

## Requirements

- Xcode 5.0

- Target of iOS 7.0 or OS X 10.9

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) 2.0

- ARC enabled

- JavaScriptCore framework

## Running unit tests

In the `Tests/` directory, run `pod install` to set up the workspace. Then you
can open the workspace and run tests in the `Tests` project.

## Security Issues

Because JSONP responses are executed in Javascript contexts, a malicious
response could cause very large memory or CPU usage. Your app could quit
or lock up. This is also true of plain JSON, but JSONP can do it with only a
small amount of data, for example:

```javascript
while(1); // The response will use 100% CPU and never complete.
```

## Credits

Created by [Chris Lundie](http://www.lundie.ca/).

## License

See the LICENSE file.
