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
//= require foundation
//= require turbolinks
//= require twitter/typeahead
//= require_tree .

$(function(){ $(document).foundation(); });

var engine = new Bloodhound({
  name: 'books',
  local: [],
  remote: {
    url: "/books/autocomplete?query=%QUERY",
    filter: function(list) {
      return $.map(list, function(title) { return { title: title }; });
    }
  },
  datumTokenizer: function(d) { return Bloodhound.tokenizers.whitespace(d.val); },
  queryTokenizer: Bloodhound.tokenizers.whitespace
});

engine.initialize();

$('#book_search').typeahead(null, {
  displayKey: 'title',
  source: engine.ttAdapter()
});




