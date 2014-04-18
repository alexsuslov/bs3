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
  <input class='form-control'><span class='help-block'></span>"

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
  testString = "<label for='Textarea'>Textarea label</label>\
  <textarea class='form-control'>Textarea value</textarea>\
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
  <select class='form-control'>\
    <option value='sel val1'>sel name1</option>\
    <option value='sel val3'>sel name2</option>\
    </select>\
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




