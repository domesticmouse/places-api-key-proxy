# Places API Key proxy

A proxy for Google Places API that adds API key to requests. For a good tutorial on how to use 
this Places API Proxy with [Google Maps SDK for iOS](https://developers.google.com/maps/documentation/ios-sdk/), 
please see 
[Google Maps iOS SDK Tutorial: Getting Started](http://www.raywenderlich.com/109888/google-maps-ios-sdk-tutorial).

## Usage

Firstly, install the [Dart SDK](https://www.dartlang.org/downloads/mac.html). The
recommended way is to use [Homebrew](http://brew.sh/) to install Dart.

```bash
$ brew tap dart-lang/dart
$ brew install dart
```

Then download the dependent packages using Dart's `pub` package management tool.

```bash
$ cd places-api-key-proxy
$ pub install
```

Finally, run the Places API Key proxy server by supplying an [API Key](https://developers.google.com/places/webservice/intro#Authentication) and a
port to bind to.

```bash
$ pub run bin/main.dart -k AIzaNotARealAPIKey -p 10000
2015.29.30 10:29:35.159	places_api_key_proxy	[INFO]:	Places API proxy running on localhost:10000
```

To test the Proxy server, simply open [localhost:10000/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&types=food&name=cruise](http://localhost:10000/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&types=food&name=cruise) in your browser of choice.

```bash
$ curl "http://localhost:10000/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&types=food&name=cruise" | more
```

This proxy server binds to all interfaces on the machine, so it will be visible
on localhost for use from the iOS Simulator, and via `en0` for use from a real
iOS device, provided both your Mac and your iOS device share the same Wifi. To
retrieve the IP address of your machine, use `ifconfig` as follows.

```bash
$ ifconfig en0
en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
	ether 28:cf:e9:12:8d:35
	inet6 fe80::2acf:e9ff:fe12:8d35%en0 prefixlen 64 scopeid 0x4
	inet 192.168.1.10 netmask 0xffffff00 broadcast 192.168.1.255
	nd6 options=1<PERFORMNUD>
	media: autoselect
	status: active
```


_This is not an official Google product_
