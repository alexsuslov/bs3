$ ->
  console.log 'Tests start'

  console.log 'Check bs3'
  if bs3
    console.log 'bs3 ok'
  else
    throw new Error 'bs3 not present error'
  # container
  console.log 'create container'
  container = bs3
    class:'container'

  if container is "<div class='container'></div>"
    console.log 'bs3 work ok'
    $('body').prepend container
  else
    console.log '"' + container + '"'
    throw new Error 'bs3 generator error'

  # row
  labelInput =
    bs3.labelInput
      label: 'test label'
      name: 'test'
      type: 'text'
      value: 'test value'
  testString = "<label for='test'>test label</label>\
  <input name='test' class='form-control'>\
    <span class='help-block'></span>"

  if labelInput is testString
    console.log 'labelInput ok'
  else
    console.log '"' + labelInput + '"'
    throw new Error 'labelInput generator error'


  labelTextarea =
    bs3.labelTextarea
      label: 'Textarea label'
      name: 'Textarea'
      value: 'Textarea value'
      rows: "10"

  testString = "<label for='Textarea'>Textarea label</label>\
  <textarea name='Textarea' rows='10' \
  class='form-control'>Textarea value</textarea>\
    <span class='help-block'></span>"
  if labelTextarea is testString
    console.log 'labelTextarea ok'
  else
    console.log '"' + labelTextarea + '"'
    throw new Error 'labelTextarea generator error'

  labelSelect =
    bs3.labelSelect
      label: 'Select label'
      name: 'Select'
      options:[
        name:'sel name1'
        value:'sel val1'
      ,
        name:'sel name2'
        value:'sel val3'
      ]
  testString = "<label for='Select'>Select label</label>\
  <select name='Select' class='form-control'>\
    <option value='sel val1'>sel name1</option>\
    <option value='sel val3'>sel name2</option></select>\
    <span class='help-block'></span>"

  if labelSelect is testString
    console.log 'labelSelect ok'
  else
    console.log '"' + labelSelect + '"'
    throw new Error 'labelSelect generator error'

  # form
  form1 =
    bs3
      tag:'form'
      action:'#'
      role:"form"
      content:[ labelInput, labelTextarea, labelSelect]


  # cols
  cols = [
    bs3(
      class:'col-md-4'
      content: form1
      )
  ,
    bs3
      class:'col-md-4'
  ,
    bs3
      class:'col-md-4'
  ]

  $('.container').html bs3
    class:'row'
    content: cols





###
Cleaning line from unnecessary
@param  [String] собрано генератором
@return [String] очищенная строка
###
clean = (string)->
  return string if @debug
  string.replace(/\s+/g, ' ').replace(/\n|\t|\r/g, '')

###
Генератор элемента из json объекта
Объект:
- content
--[String] строка для вставки в объект
--[Array] массив строк для вставки в объект
- param [Объект] name=value
...

@param  [Object] Объект
@return [String] html строка
###
bs3 = (object)->
  @clean = clean

  # content
  if Object.prototype.toString.call(object.content) is '[object Array]'
    content = object.content.join ''
  else
    content = object.content || ''

  # params
  params = ''
  comma = ''
  for param of object
    unless param in ['content','tag', 'options']
      params += "#{comma}#{param}='#{object[param]}'"
      comma = ' '
  # tag
  object.tag = 'div' unless object.tag
  # close tag
  closeTag = ''
  closeTag = "</#{object.tag}>"  unless object.tag in ['input', 'hr', 'br']

  @clean "<#{object.tag} #{params}>#{content}#{closeTag}"


###
Генератор группы элементов из json объекта
- label
- select
- help-block
@param  [Object]
@return [String] html строка
###

bs3.labelSelect = (object)->
  label = @
    for: object.name
    tag: 'label'
    content: object.label

  options = ''
  for option in object.options
    options += @
      tag: 'option'
      content: option.name
      value: option.value

  cls = 'form-control'
  cls += ' ' + object.class if object.class

  select = @
    tag:'select'
    name:object.name
    class: cls
    content: options

  spanInfo = @
    class:"help-block"
    tag:'span'

  label + select + spanInfo


###
Генератор группы элементов из json объекта
- label
- textarea
- help-block
@param  [Object]
@return [String] html строка
###
bs3.labelTextarea = (object)->
  label = @
    for: object.name
    tag: 'label'
    content: object.label

  textarea =
    tag:'textarea'
    content: object.value

  for param of object
    unless param in ['label', 'value' ]
      textarea[param] = object[param]

  if textarea.class
    textarea.class =  object.class + ' form-control'
  else
    textarea.class = 'form-control'

  textarea = @ textarea

  spanInfo = @
    class:"help-block"
    tag:'span'

  label + textarea + spanInfo


###
Генератор группы элементов из json объекта
- label
- input
- help-block

@param  [Object]
@return [String] html строка
###

bs3.labelInput = (object)->
  label = @
    for: object.name
    tag: 'label'
    content: object.label

  cls = 'form-control'
  cls += ' ' + object.class if object.class

  input = @
    tag:'input'
    name: object.name
    class: cls
    content: object.content

  spanInfo = @
    class:"help-block"
    tag:'span'

  label + input + spanInfo

window.bs3 = bs3