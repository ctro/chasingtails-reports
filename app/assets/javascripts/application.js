// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require refile
//= require_tree .

// Google Maps
var geocoder;
var map;

// Callback from async script
function initMap() {
 var latlng = new google.maps.LatLng(0,0);
 var mapOptions = {
   zoom: 15,
   center: latlng
 }
 map = new google.maps.Map(document.getElementById("map"), mapOptions);
}

// Geocode : New reports
function setLatLong() {

  // HTML5 geolocation : Report form
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      var pos = { lat: position.coords.latitude, lng: position.coords.longitude };
      $('#report_lat').val(pos.lat);
      $('#report_lng').val(pos.lng);
    });
  }
}

// Show Lat/Lng from walk
function setLatLong(lat, lng) {
  pos = { lat: lat, lng: lng }
  var infoWindow = new google.maps.InfoWindow({map: map});
  infoWindow.setPosition(pos);
  infoWindow.setContent('Reported here');
  map.setCenter(pos);
}

// Reverse Geocode : Client addresses
function codeAddress(address) {
 geocoder = new google.maps.Geocoder();
 geocoder.geocode( { 'address': address}, function(results, status) {
   if (status == google.maps.GeocoderStatus.OK) {
     map.setCenter(results[0].geometry.location);
     var marker = new google.maps.Marker({
         map: map,
         position: results[0].geometry.location
     });
   } else {
     alert("Geocode was not successful for the following reason: " + status);
   }
 });
}
