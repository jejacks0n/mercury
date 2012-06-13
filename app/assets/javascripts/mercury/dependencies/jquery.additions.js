/*
 * jQuery serializeObject Plugin: https://github.com/fojas/jQuery-serializeObject
 *
 */
!function($){
  $.serializeObject = function(obj){
    var o={},lookup=o,a = obj;
    $.each(a,function(){
      var named = this.name.replace(/\[([^\]]+)?\]/g,',$1').split(','),
          cap = named.length - 1,
          i = 0;
      for(;i<cap;i++) {
        // move down the tree - create objects or array if necessary
        if(lookup.push){ // this is an array, add values instead of setting them
          // push an object if this is an empty array or we are about to overwrite a value
          if( !lookup[lookup.length -1] // this is an empty array
              || lookup[lookup.length -1].constructor !== Object //current value is not a hash
              || lookup[lookup.length -1][named[i+1]] !== undefined //current item is already set
              ){
            lookup.push({});
          }
          lookup = lookup[lookup.length -1];
        } else {
          lookup = lookup[named[i]] = lookup[named[i]] || (named[i+1]==""?[]:{});
        }
      }
      if(lookup.push){
        lookup.push(this.value);
      }else{
        lookup[named[cap]]=this.value;
      }
      lookup = o;
    });
    return o;
  };

  $.deserializeObject = function deserializeObject(json,arr,prefix){
    var i,j,thisPrefix,objType;
    arr = arr || [];
    if(Object.prototype.toString.call(json) ==='[object Object]'){
      for(i in json){
        thisPrefix = prefix ? [prefix,'[',i,']'].join('') : i;
        if(json.hasOwnProperty(i)){
          objType = Object.prototype.toString.call(json[i])
          if(objType === '[object Array]'){
            for(j = 0,jsonLen = json[i].length;j<jsonLen;j++){
              deserializeObject(json[i][j],arr,thisPrefix+'[]');
            }
          }else if(objType === '[object Object]'){
            deserializeObject(json[i],arr,thisPrefix);
          }else {
            arr.push({
              name : thisPrefix,
              value : json[i]
            });
          }
        }
      }
    } else {
      arr.push({
        name : prefix,
        value : json
      });
    }
    return arr;
  }

  var check = function(){
    // older versions of jQuery do not have prop
    var propExists = !!$.fn.prop;
    return function(obj,checked){
      if(propExists) obj.prop('checked',checked);
      else obj.attr('checked', (checked ? 'checked' : null ));
    };
  }();

  $.applySerializedArray = function(form,obj){
    var $form = $(form).find('input,select,textarea'), el;
    check($form.filter(':checked'),false)
    for(var i = obj.length;i--;){
      el = $form.filter("[name='"+obj[i].name+"']");
      if(el.filter(':checkbox').length){
        if(el.val() == obj[i].value) check(el.filter(':checkbox'),true);
      }else if(el.filter(':radio').length){
        check(el.filter("[value='"+obj[i].value+"']"),true)
      } else {
        el.val(obj[i].value);
      }
    }
  };

  $.applySerializedObject = function(form, obj){
    $.applySerializedArray(form,$.deserializeObject(obj));
  };

  $.fn.serializeObject = $.fn.serializeObject || function(){
    return $.serializeObject(this.serializeArray());
  };

  $.fn.applySerializedObject = function(obj){
    $.applySerializedObject(this,obj);
    return this;
  };

  $.fn.applySerializedArray = function(obj){
    $.applySerializedArray(this,obj);
    return this;
  };

}(jQuery);
/*
 * jQuery Easing v1.3 - http://gsgd.co.uk/sandbox/jquery/easing/
 *
 * Uses the built in easing capabilities added In jQuery 1.1 to offer multiple easing options
 *
 * TERMS OF USE - jQuery Easing
 *
 * Open source under the BSD License.
 *
 * Copyright © 2008 George McGinley Smith
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the
 * following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following
 * disclaimer.  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and
 * the following disclaimer in the documentation and/or other materials provided with the distribution.
 *
 * Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
jQuery.extend(jQuery.easing, {
  easeInSine: function (x, t, b, c, d) {
    return -c * Math.cos(t / d * (Math.PI / 2)) + c + b
  },
  easeOutSine: function (x, t, b, c, d) {
    return c * Math.sin(t / d * (Math.PI / 2)) + b
  },
  easeInOutSine: function (x, t, b, c, d) {
    return -c / 2 * (Math.cos(Math.PI * t / d) - 1) + b
  }
});

/*
 * jQuery JSON Plugin version: 2.1 (2009-08-14)
 *
 * This document is licensed as free software under the terms of the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Brantley Harris wrote this plugin. It is based somewhat on the JSON.org  website's http://www.json.org/json2.js,
 * which proclaims: "NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.", a sentiment that I uphold.
 *
 * It is also influenced heavily by MochiKit's serializeJSON, which is  copyrighted 2005 by Bob Ippolito.
 */
(function($) {
  $.toJSON = function(o) {
    if (typeof(JSON) == 'object' && JSON.stringify) return JSON.stringify(o);

    var type = typeof(o);

    if (o === null) return "null";
    if (type == "undefined") return undefined;
    if (type == "number" || type == "boolean") return o + "";
    if (type == "string") return $.quoteString(o);

    if (type == 'object') {
      if (typeof(o.toJSON) == "function") return $.toJSON(o.toJSON());

      if (o.constructor === Date) {
        var year = o.getUTCFullYear();

        var month = o.getUTCMonth() + 1;
        if (month < 10) month = '0' + month;

        var day = o.getUTCDate();
        if (day < 10) day = '0' + day;

        var hours = o.getUTCHours();
        if (hours < 10) hours = '0' + hours;

        var minutes = o.getUTCMinutes();
        if (minutes < 10) minutes = '0' + minutes;

        var seconds = o.getUTCSeconds();
        if (seconds < 10) seconds = '0' + seconds;

        var milli = o.getUTCMilliseconds();
        if (milli < 100) milli = '0' + milli;
        if (milli < 10) milli = '0' + milli;

        return '"' + year + '-' + month + '-' + day + 'T' + hours + ':' + minutes + ':' + seconds + '.' + milli + 'Z"';
      }

      if (o.constructor === Array) {
        var ret = [];
        for (var i = 0; i < o.length; i++) ret.push($.toJSON(o[i]) || "null");
        return "[" + ret.join(",") + "]";
      }

      var pairs = [];
      for (var k in o) {
        var name;
        type = typeof(k);

        if (type == "number") name = '"' + k + '"';
        else if (type == "string") name = $.quoteString(k);
        else continue;  //skip non-string or number keys

        if (typeof o[k] == "function") continue;  //skip pairs where the value is a function.
        var val = $.toJSON(o[k]);
        pairs.push(name + ":" + val);
      }

      return "{" + pairs.join(", ") + "}";
    }
  };

  $.quoteString = function(string) {
    if (string.match(_escapeable)) {
      return '"' + string.replace(_escapeable, function (a) {
        var c = _meta[a];
        if (typeof c === 'string') return c;
        c = a.charCodeAt();
        return '\\u00' + Math.floor(c / 16).toString(16) + (c % 16).toString(16);
      }) + '"';
    }
    return '"' + string + '"';
  };

  var _escapeable = /["\\\x00-\x1f\x7f-\x9f]/g;
  var _meta = {'\b': '\\b', '\t': '\\t', '\n': '\\n', '\f': '\\f', '\r': '\\r', '"' : '\\"', '\\': '\\\\'};
})(jQuery);

/*
 * jQuery Localizer Plugin
 *
 * Copyright (c) 2011 Sagi Mann (with a basic reworking by Jeremy Jackson)
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms are permitted provided that the above copyright notice and this
 * paragraph are duplicated in all such forms and that any documentation, advertising materials, and other materials
 * related to such distribution and use acknowledge that the software was developed by the <organization>.  The name of
 * the University may not be used to endorse or promote products derived from this software without specific prior
 * written permission.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 */
(function($) {
  $.fn.localize = function(locale) {
    this.find('*').contents().each(function() {
      var translated = false;
      var source = '';
      if (typeof(this.data) == 'string') {
        source = $.trim(this.data);
        if (source && (translated = (locale.sub[source] || locale.top[source]))) {
          this.data = translated;
        }
      }

      if (this.nodeName == 'IMG' && this.attributes['src']) {
        source = this.attributes['src'].nodeValue;
        if (source && (translated = (locale.sub[source] || locale.top[source]))) {
          $(this).attr('src', translated);
        }
      }

      if (this.nodeName == "A" && this.attributes['href']) {
        source = $.trim(this.attributes['href'].nodeValue);
        if (source && (translated = (locale.sub[source] || locale.top[source]))) {
          $(this).attr('href', translated);
        }
      }

      if (this.nodeName == "INPUT" && this.attributes['type']) {
        if (this.attributes['value'] && ['submit', 'reset', 'button'].indexOf(this.attributes['type'].nodeValue.toLowerCase()) > -1) {
          source = $.trim(this.attributes['value'].nodeValue);
          if (source && (translated = (locale.sub[source] || locale.top[source]))) {
            $(this).attr('value', translated);
          }
        }
      }

      return this;
    });
  };
})(jQuery);
