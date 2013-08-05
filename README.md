JSON Syntax Highlight
=====================

Add syntax highlighting to JSON objects in Objective C for both Cocoa and iOS
without using HTML

![jsh](http://www.daveeddy.com/static/media/github/jsh.png)

Requires ARC

Installation
------------

- Copy `JSONSyntaxHighlight.m` and `JSONSyntaxHighlight.h` to your porject
- iOS
    - Add `UIKit.framework` to your project
- Mac
    - Add `AppKit.framework` to your project

Usage
-----

``` objective-c
- (JSONSyntaxHighlight *)initWithJSON:(id)JSON;
```

Create a `JSONSyntaxHighlight` object given a JSON object (`NSDictionary`, `NSArray`, etc.)

``` objective-c
@property (readonly, nonatomic, strong) id JSON;
@property (readonly, nonatomic, strong) NSString *parsedJSON;
```

`JSON` is the unmodified JSON object, and `parsedJSON` is the stringified pretty printed JSON
string

---

``` objective-c
- (NSAttributedString *)highlightJSON;
- (NSAttributedString *)highlightJSONWithPrettyPrint:(BOOL)prettyPrint;
```

Return an `NSAttributedString` with the highlighted JSON in an optionally
pretty printed format.  If unspecified, pretty printing is the default

``` objective-c
@property (nonatomic, strong) NSDictionary *keyAttributes;
@property (nonatomic, strong) NSDictionary *stringAttributes;
@property (nonatomic, strong) NSDictionary *nonStringAttributes;
```

Set the attributes to be used for the `NSAttributedString` for the JSON keys
and values (both string and non-string)

---

``` objective-c
- (void)enumerateMatchesWithIndentBlock:(void(^)(NSRange, NSString*))indentBlock
                               keyBlock:(void(^)(NSRange, NSString*))keyBlock
                             valueBlock:(void(^)(NSRange, NSString*))valueBlock
                               endBlock:(void(^)(NSRange, NSString*))endBlock
```

Fire a callback for every key item found in the parsed JSON, each callback
is fired with the `NSRange` the substring appears in `self.parsedJSON`, as well
as the `NSString` at that location.

An example JSON file with each "key item" is illustrated below

```
{
     "name": "dave",
+---++------++----++
|    |       |     |
|    |       |     +-->end    (may be empty)
|    |       +-------->value  (will have quotes if string)
|    +---------------->key    (will have quotes and colon)
+--------------------->indent (leading spaces)
     "age": 24
+---++-----++++
|    |      | |
|    |      | +------->end    @""
|    |      +--------->value  @"24"
|    +---------------->key    @"\"age\":"
+--------------------->indent @"    "
}
+
|
+--------------------->end    @"}"
```

---

``` objective-c
+ (Color *)colorWithRGB:(NSInteger)rgbValue;
+ (Color *)colorWithRGB:(NSInteger)rgbValue alpha:(CGFloat)alpha;
```

These functions can be used to return an `NSColor` or `UIColor` object (as appropriate)
based on the given `rgbValue`



Example
-------

Clone this project and open the XCode project to see the Mac and iOS examples

Import this library

``` objective-c
#import "JSONSyntaxHighlight.h"
```

Create the `JSONSyntaxHighlight` object

``` objective-c
id JSONObj = @{
  @"name": @"dave"
};

JSONSyntaxHighlight *jsh = [[JSONSyntaxHighlight alloc] initWithJSON:JSONObj];

NSAttributedString *s;
```

Basic highlighting

``` objective-c
s = [jsh highlightJSON];
// s => an NSAttributedString with the JSON highlighted in pretty print format

s = [jsh highlightJSONWithPrettyPrint:NO];
// s => same as above, but compressed JSON is returned
```

Advanced highlighting

``` objective-c
jsh.nonStringAttributes = @{NSForegroundColorAttributeName: [JSONSyntaxHighlight colorWithRGB:0xffffff]};
jsh.stringAttributes = @{NSForegroundColorAttributeName: [JSONSyntaxHighlight colorWithRGB:0x00ff00]};
jsh.keyAttributes = @{NSForegroundColorAttributeName: [JSONSyntaxHighlight colorWithRGB:0x0000ff]};
s = [jsh highlightJSON];
// s => an NSAttributedString with the JSON highlighted in pretty print format
// using the colors specified above
```

Event driven API

``` objective-c
NSMutableString *json = [[NSMutableString alloc] initWithString:@""];
[jsh enumerateMatchesWithIndentBlock:
 // The indent
 ^(NSRange range, NSString *s) {
     [json appendAttributedString:s];
 }
                             keyBlock:
 // The key (with quotes and colon)
 ^(NSRange range, NSString *s) {
     [json appendAttributedString:s];
 }
                           valueBlock:
 // The value
 ^(NSRange range, NSString *s) {
     [json appendAttributedString:s];
 }
                             endBlock:
 // The final comma, or ending character
 ^(NSRange range, NSString *s) {
     [json appendAttributedString:s];
     [json appendAttributedString:@"\n"];
 }];
// json => a pretty printed JSON string
```

Todo
----

- Create a cocoa pod for this library

License
-------

MIT License
