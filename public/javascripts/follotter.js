var API_BASE_URI = 'http://mirakui.tsuyabu.in/follotter/api';
//var API_BASE_URI = 'http://localhost:4000/api';

function Queue(capacity, callback) {
  this.init();
  this.capacity = capacity;
  this.progress_callback = callback || function(){};
}

Queue.prototype.push = function(i) {
  this.queue[i] = true;
  this.count++;
}

Queue.prototype.pop = function(i) {
  if (this.queue[i]) {
    this.queue[i] = false;
    this.count--;
    progress = ((this.capacity-this.count)/this.capacity)*100;
    this.progress_callback(progress);
  }
}

Queue.prototype.init = function() {
  this.queue = [];
  this.count = 0;
}

$(document).ready(function() {
  $("#progress").progressBar(0, {
    showText: false,
    boxImage: "images/progressbar.gif",
    barImage: "images/progressbg_red.gif"})
  .hide();
  $(".cofriends .permalink").hide();
  $("#loading").hide();
  //$("input:first").attr('disabled', 'disabled');
  $("input:first").attr('disabled', false);

  $(".cofriends form").submit(function() {
    $(".cofriends .permalink").hide();
    $(".cofriends input[@type=submit]")
    .hide()
    .attr('disabled', true);
    $("#progress").progressBar(0).show();
    $("#loading").show();
    $("input:first").attr('disabled', true);

    query = $("input:first").val();
    query = (query.match(/\s*([^\s].*[^\s])\s*/) || [])[1];
    if (!query) {
      print_error('query is empty');
      return false;
    }
    query = query.split(/[ 　]+/)
    friends_array = [];
    result = null;

    invalid_ids = validate_ids(query);
    if (invalid_ids.length>0) {
      print_error('invalid id: '+invalid_ids.join(', '));
      return false;
    }

    $('#output').empty();
    queue = new Queue(query.length, function(progress) {
      //console.debug(progress);
      $("#progress").progressBar(progress);
      if (progress>=100) {
        uniq = array_common(friends_array);
        for (var i=uniq.length-1; i>0; i--) {
          $('<h3></h3>')
          .text('friends of '+(i+1)+' people')
          .appendTo('#output');
          box = $('<div>')
          .appendTo('#output');
          $.each(uniq[i]||[], function(j) {
            u = uniq[i][j];
            $('<a>')
            .attr('href', 'http://twitter.com/'+u.id)
            .append(
              $('<img>')
              .attr('src', u.icon)
              .attr('alt', u.id)
              .width(24)
              .height(24)
            )
            .appendTo('#output');
          });
        }
        $(".cofriends .permalink")
        .attr('href', '/main/cofriends/'+query.join('-'))
        .show();
        $(".cofriends input[@type=submit]")
        .attr('disabled', false)
        .show();
        $("#progress").hide().progressBar(0);
        $("#error").hide();
        $("#loading").hide();
        $("input:first").attr('disabled', false);
      }
    });

    $.each(query, function(i) {
      queue.push(i);
      load_friends(query[i], function(res) {
        if (res['friends']) {
          friends_array.push(res['friends']);
        }
        else if (res['error']) {
          print_error(res['error']);
          queue.init();
        }
        else {
          print_error('unexpected error');
          queue.init();
        }
        queue.pop(i);
      });
    });

    return false;
  });
});

function print_error(msg) {
  $("#error").text(msg).show();
  $(".cofriends .permalink").hide();
  $(".cofriends input[@type=submit]")
  .attr('disabled', false)
  .show();
  $("#progress").hide().progressBar(0);
  $("#loading").hide();
  $("input:first").attr('disabled', false);
}

function validate_ids(ids) {
  invalid_ids = [];
  $.each(ids, function(i) {
    id = ids[i];
    if (id==null) {
      invalid_ids.push(id);
    }
    else if (id.match(/[^a-zA-Z0-9_]/)) {
      invalid_ids.push(id);
    }
  });
  return invalid_ids;
}

function load_friends(id, func_loaded) {
  url = API_BASE_URI + '/friends/' + id;
  //console.debug(url);
  $.getJSON(url, function(json) {
    func_loaded(json);
  });
}

function array_common(arrays) {
  merged = [];
  // merge
  $.each(arrays, function(i) {
    merged = merged.concat(arrays[i]);
  });
  // sort
  merged.sort(function(a,b) {
    return a['id']>b['id'];
  });

  // uniq
  uniq = new Array(arrays.length);
  _x = null;
  count = 0;
  $.each(merged, function(i) {
    x = merged[i];
    if (_x) {
      if (x['id']==_x['id']) {
        count++;
      }
      else {
        uniq[count] ? uniq[count].push(_x) : (uniq[count]=[_x]);
        count = 0;
      }
    }
    _x = x;
  });
  uniq[count] ? uniq[count].push(_x) : (uniq[count]=[_x]);
  return uniq;
}
