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