require('cloud/event_thumbnail.js');
require('cloud/photo_thumbnail.js');
//require('cloud/crop_image.js');
require('cloud/venue_thumbnail.js');
 
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});