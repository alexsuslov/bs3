(function() {
  var bs3, clean;

  $(function() {
    var cols, container, form1, labelInput, labelSelect, labelTextarea, testString;
    console.log('Tests start');
    console.log('Check bs3');
    if (bs3) {
      console.log('bs3 ok');
    } else {
      throw new Error('bs3 not present error');
    }
    console.log('create container');
    container = bs3({
      "class": 'container'
    });
    if (container === "<div class='container'></div>") {
      console.log('bs3 work ok');
      $('body').prepend(container);
    } else {
      console.log('"' + container + '"');
      throw new Error('bs3 generator error');
    }
    labelInput = bs3.labelInput({
      label: 'test label',
      name: 'test',
      type: 'text',
      value: 'test value'
    });
    testString = "<label for='test'>test label</label><input name='test' class='form-control'><span class='help-block'></span>";
    if (labelInput === testString) {
      console.log('labelInput ok');
    } else {
      console.log('"' + labelInput + '"');
      throw new Error('labelInput generator error');
    }
    labelTextarea = bs3.labelTextarea({
      label: 'Textarea label',
      name: 'Textarea',
      value: 'Textarea value',
      rows: "10"
    });
    testString = "<label for='Textarea'>Textarea label</label><textarea name='Textarea' rows='10' class='form-control'>Textarea value</textarea><span class='help-block'></span>";
    if (labelTextarea === testString) {
      console.log('labelTextarea ok');
    } else {
      console.log('"' + labelTextarea + '"');
      throw new Error('labelTextarea generator error');
    }
    labelSelect = bs3.labelSelect({
      label: 'Select label',
      name: 'Select',
      options: [
        {
          name: 'sel name1',
          value: 'sel val1'
        }, {
          name: 'sel name2',
          value: 'sel val3'
        }
      ]
    });
    testString = "<label for='Select'>Select label</label><select name='Select' class='form-control'><option value='sel val1'>sel name1</option><option value='sel val3'>sel name2</option></select><span class='help-block'></span>";
    if (labelSelect === testString) {
      console.log('labelSelect ok');
    } else {
      console.log('"' + labelSelect + '"');
      throw new Error('labelSelect generator error');
    }
    form1 = bs3({
      tag: 'form',
      action: '#',
      role: "form",
      content: [labelInput, labelTextarea, labelSelect]
    });
    cols = [
      bs3({
        "class": 'col-md-4',
        content: form1
      }), bs3({
        "class": 'col-md-4'
      }), bs3({
        "class": 'col-md-4'
      })
    ];
    return $('.container').html(bs3({
      "class": 'row',
      content: cols
    }));
  });


  /*
  Cleaning line from unnecessary
  @param  [String] собрано генератором
  @return [String] очищенная строка
   */

  clean = function(string) {
    if (this.debug) {
      return string;
    }
    return string.replace(/\s+/g, ' ').replace(/\n|\t|\r/g, '');
  };


  /*
  Генератор элемента из json объекта
  Объект:
  - content
  --[String] строка для вставки в объект
  --[Array] массив строк для вставки в объект
  - param [Объект] name=value
  ...
  
  @param  [Object] Объект
  @return [String] html строка
   */

  bs3 = function(object) {
    var closeTag, comma, content, param, params, _ref;
    this.clean = clean;
    if (Object.prototype.toString.call(object.content) === '[object Array]') {
      content = object.content.join('');
    } else {
      content = object.content || '';
    }
    params = '';
    comma = '';
    for (param in object) {
      if (param !== 'content' && param !== 'tag' && param !== 'options') {
        params += "" + comma + param + "='" + object[param] + "'";
        comma = ' ';
      }
    }
    if (!object.tag) {
      object.tag = 'div';
    }
    closeTag = '';
    if ((_ref = object.tag) !== 'input' && _ref !== 'hr' && _ref !== 'br') {
      closeTag = "</" + object.tag + ">";
    }
    return this.clean("<" + object.tag + " " + params + ">" + content + closeTag);
  };


  /*
  Генератор группы элементов из json объекта
  - label
  - select
  - help-block
  @param  [Object]
  @return [String] html строка
   */

  bs3.labelSelect = function(object) {
    var cls, label, option, options, select, spanInfo, _i, _len, _ref;
    label = this({
      "for": object.name,
      tag: 'label',
      content: object.label
    });
    options = '';
    _ref = object.options;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      option = _ref[_i];
      options += this({
        tag: 'option',
        content: option.name,
        value: option.value
      });
    }
    cls = 'form-control';
    if (object["class"]) {
      cls += ' ' + object["class"];
    }
    select = this({
      tag: 'select',
      name: object.name,
      "class": cls,
      content: options
    });
    spanInfo = this({
      "class": "help-block",
      tag: 'span'
    });
    return label + select + spanInfo;
  };


  /*
  Генератор группы элементов из json объекта
  - label
  - textarea
  - help-block
  @param  [Object]
  @return [String] html строка
   */

  bs3.labelTextarea = function(object) {
    var label, param, spanInfo, textarea;
    label = this({
      "for": object.name,
      tag: 'label',
      content: object.label
    });
    textarea = {
      tag: 'textarea',
      content: object.value
    };
    for (param in object) {
      if (param !== 'label' && param !== 'value') {
        textarea[param] = object[param];
      }
    }
    if (textarea["class"]) {
      textarea["class"] = object["class"] + ' form-control';
    } else {
      textarea["class"] = 'form-control';
    }
    textarea = this(textarea);
    spanInfo = this({
      "class": "help-block",
      tag: 'span'
    });
    return label + textarea + spanInfo;
  };


  /*
  Генератор группы элементов из json объекта
  - label
  - input
  - help-block
  
  @param  [Object]
  @return [String] html строка
   */

  bs3.labelInput = function(object) {
    var cls, input, label, spanInfo;
    label = this({
      "for": object.name,
      tag: 'label',
      content: object.label
    });
    cls = 'form-control';
    if (object["class"]) {
      cls += ' ' + object["class"];
    }
    input = this({
      tag: 'input',
      name: object.name,
      "class": cls,
      content: object.content
    });
    spanInfo = this({
      "class": "help-block",
      tag: 'span'
    });
    return label + input + spanInfo;
  };


  /*
   _                _                _        _
  | |__   ___  _ __(_)_______  _ __ | |_ __ _| |
  | '_ \ / _ \| '__| |_  / _ \| '_ \| __/ _` | |
  | | | | (_) | |  | |/ / (_) | | | | || (_| | |
  |_| |_|\___/|_|  |_/___\___/|_| |_|\__\__,_|_|
   */


  /*
  Генератор группы элементов из json объекта
  - label
  - select
  - help-block
  @param  [Object]
  @return [String] html строка
   */

  bs3.horizontalLabelSelect = function(object) {
    var cls, label, option, options, select, spanInfo, _i, _len, _ref;
    label = this({
      "for": object.name,
      tag: 'label',
      "class": 'col-sm-2 control-label',
      content: object.label
    });
    options = '';
    _ref = object.options;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      option = _ref[_i];
      options += this({
        tag: 'option',
        content: option.name,
        value: option.value
      });
    }
    cls = 'form-control';
    if (object["class"]) {
      cls += ' ' + object["class"];
    }
    select = this({
      "class": 'col-sm-10',
      content: this({
        tag: 'select',
        name: object.name,
        "class": cls,
        content: options
      })
    });
    spanInfo = this({
      "class": "help-block col-sm-12",
      tag: 'span'
    });
    return this({
      "class": 'form-group',
      content: label + select + spanInfo
    });
  };


  /*
  Генератор группы элементов из json объекта
  - label
  - textarea
  - help-block
  @param  [Object]
  @return [String] html строка
   */

  bs3.horizontalLabelTextarea = function(object) {
    var label, param, spanInfo, textarea;
    label = this({
      "for": object.name,
      tag: 'label',
      "class": 'col-sm-2 control-label',
      content: object.label
    });
    textarea = {
      tag: 'textarea',
      content: object.value
    };
    for (param in object) {
      if (param !== 'label' && param !== 'value') {
        textarea[param] = object[param];
      }
    }
    if (textarea["class"]) {
      textarea["class"] = object["class"] + ' form-control';
    } else {
      textarea["class"] = 'form-control';
    }
    textarea = this({
      "class": 'col-sm-10',
      content: this(textarea)
    });
    spanInfo = this({
      "class": "help-block col-sm-12",
      tag: 'span'
    });
    return this({
      "class": 'form-group',
      content: label + textarea + spanInfo
    });
  };


  /*
  Генератор группы элементов из json объекта
  - label
  - input
  - help-block
  
  @param  [Object]
  @return [String] html строка
   */

  bs3.horizontalLabelInput = function(object) {
    var cls, input, label, spanInfo;
    label = this({
      "for": object.name,
      tag: 'label',
      "class": 'col-sm-2 control-label',
      content: object.label
    });
    cls = 'form-control';
    if (object["class"]) {
      cls += ' ' + object["class"];
    }
    input = this({
      "class": 'col-sm-10',
      content: this({
        tag: 'input',
        name: object.name,
        "class": cls,
        content: object.content
      })
    });
    spanInfo = this({
      "class": "help-block col-sm-12",
      tag: 'span'
    });
    return this({
      "class": 'form-group',
      content: label + input + spanInfo
    });
  };

  window.bs3 = bs3;

}).call(this);

//# sourceMappingURL=../js/bs3-tests.js.map
