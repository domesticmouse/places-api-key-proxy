// Copyright 2015 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:io';
import 'package:args/args.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';

final _logger = new Logger("places_api_key_proxy");
final _placesApiHost = "maps.googleapis.com";

main(List<String> arguments) async {
  // Configure logger
  Logger.root.onRecord.listen(new LogPrintHandler());

  // Parse command line arguments
  var parser = new ArgParser();
  parser.addOption('key', abbr: 'k', help: 'Places API Key');
  parser.addOption('port', abbr: 'p', help: 'Port to bind to');
  var flags = parser.parse(arguments);
  validateParameters(parser, flags);

  // Run the proxy server
  var server = await HttpServer.bind(
      InternetAddress.ANY_IP_V6, int.parse(flags['port']));
  _logger.info('Places API proxy running on localhost:${server.port}');
  await for (var request in server) {
    var reqUri = request.requestedUri;
    var path = reqUri.path;
    var queryParams = new Map.from(reqUri.queryParameters);
    queryParams['key'] = flags['key'];
    var url = new Uri.https(_placesApiHost, path, queryParams);
    _logger.info('Requesting: $url');

    var response = await http.get(url);
    request.response.statusCode = response.statusCode;
    request.response.headers.contentType =
        ContentType.parse(response.headers['content-type']);
    request.response.write(response.body);
    request.response.close();
    _logger.info('Relayed: $url');
  }
}

validateParameters(ArgParser parser, ArgResults results) {
  if (results['key'] == null) {
    usageAndExit(parser, 'Missing key parameter');
  }
  if (!results['key'].startsWith('AIza')) {
    usageAndExit(parser, 'Invalid key parameter: ${results['key']}');
  }
  if (results['port'] == null) {
    usageAndExit(parser, 'Missing port parameter');
  }
  int.parse(results['port'], onError: (source) {
    usageAndExit(parser, 'Invalid port parameter: $source');
  });
}

usageAndExit(ArgParser parser, String reason) {
  print(reason);
  print(parser.usage);
  exit(1);
}
