(function() {
  var $, Slugger;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  $ = jQuery;
  $.fn.extend({
    slugger: function(options) {
      return $(this).each(function() {
        return new Slugger($(this), options);
      });
    }
  });
  Slugger = (function() {
    Slugger.prototype.settings = {
      slugInput: null,
      safeMode: true,
      cleanseSlugInput: true
    };
    Slugger.prototype.input = $();
    Slugger.prototype.lastSlug = null;
    Slugger.prototype.generatedSlug = null;
    Slugger.prototype.slugIsDirty = false;
    Slugger.prototype.caretLibExists = false;
    function Slugger($el, options) {
      this.onSlugInputChange = __bind(this.onSlugInputChange, this);
      this.onSlugInputKeyup = __bind(this.onSlugInputKeyup, this);
      this.onInputKeyup = __bind(this.onInputKeyup, this);      this.options = $.extend({}, this.settings, options);
      if (this.options.slugInput == null) {
        throw "You must provide a slugInput jQuery object";
      }
      this.caretLibExists = !!$().caret;
      this.$input = $el;
      this.$input.bind("keyup", this.onInputKeyup);
      if (this.options.cleanseSlugInput) {
        this.options.slugInput.bind("keyup", this.onSlugInputKeyup);
      }
      this.options.slugInput.bind("change", this.onSlugInputChange);
      this.lastSlug = this.options.slugInput.val();
      this.generatedSlug = this.convert(this.$input.val());
      this.update();
    }
    Slugger.prototype.onInputKeyup = function(event) {
      return this.update();
    };
    Slugger.prototype.onSlugInputKeyup = function(event) {
      var caretPos, cleansed;
      cleansed = this.cleanse(this.options.slugInput.val());
      if (cleansed.changeOccurred) {
        if (this.caretLibExists) {
          caretPos = this.options.slugInput.caret();
        }
        this.options.slugInput.val(cleansed.cleansedString);
        if (this.caretLibExists) {
          caretPos += cleansed.difference * -1;
          return this.options.slugInput.caret(caretPos);
        }
      }
    };
    Slugger.prototype.onSlugInputChange = function(event) {
      if (this.options.slugInput.val() === '') {
        return this.update();
      }
    };
    Slugger.prototype.update = function() {
      if (this.options.safeMode) {
        this.safeUpdate();
      } else {
        this.dirtyUpdate();
      }
      return this.render();
    };
    Slugger.prototype.safeUpdate = function() {
      var string;
      this.lastSlug = this.options.slugInput.val();
      string = this.$input.val();
      if (this.lastSlug !== this.generatedSlug && this.lastSlug !== '') {
        return this.slugIsDirty = true;
      } else {
        this.slugIsDirty = false;
        return this.generatedSlug = this.convert(string);
      }
    };
    Slugger.prototype.dirtyUpdate = function() {
      var string;
      this.slugIsDirty = false;
      string = this.$input.val();
      return this.generatedSlug = this.convert(string);
    };
    Slugger.prototype.render = function() {
      if (!this.slugIsDirty) {
        return this.options.slugInput.val(this.generatedSlug);
      }
    };
    Slugger.prototype.convert = function(str) {
      var cStr;
      cStr = str.replace(/^\s+|\s+$/g, '');
      cStr = this.replace(cStr);
      return cStr;
    };
    Slugger.prototype.cleanse = function(str) {
      var cStr;
      cStr = this.replace(str);
      return {
        cleansedString: cStr,
        changeOccurred: cStr !== str,
        difference: str.length - cStr.length
      };
    };
    Slugger.prototype.replace = function(str) {
      var cStr, from, i, to, _ref;
      cStr = str.toLowerCase();
      from = "åãàáäâẽèéëêìíïîõòóöôùúüûñç·/_,:;";
      to = "aaaaaaeeeeeiiiiooooouuuunc------";
      for (i = 0, _ref = from.length - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
        cStr = cStr.replace(new RegExp(from.charAt(i), 'g'), to.charAt(i));
      }
      cStr = cStr.replace(/[^a-z0-9 -]/g, '').replace(/\s+/g, '-').replace(/-+/g, '-');
      return cStr;
    };
    return Slugger;
  })();
}).call(this);
