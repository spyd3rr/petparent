// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap


//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl


//= require_self
//= require_tree .

$(document).ready(function(){

});


$(function() {
//    $("#products th a, #products .pagination a").live("click", function() {
//        $.getScript(this.href);
//        return false;
//    });
//    $("#products_search input").keyup(function() {
//        $.get($("#products_search").attr("action"), $("#products_search").serialize(), null, "script");
//        return false;
//    });

    $( document ).ajaxStart(function () {
        $( "#ajax_div" ).show();
    });
    $( document ).ajaxStop(function() {
        $( "#ajax_div" ).hide();
    });

    $( document ).ajaxError(function (event, jqXHR, ajaxSettings, thrownError) {
        alert(jqXHR['status'] + ' ' + thrownError);
    });

});
