$editors = window.editors = $('[data-clrctrl=editor]')
edits = ['H', 'S', 'L']

$editors.each(function() {
  editor = $(this)[0]
  console.log(editor)
  // build editor
  forms = {}
  $.map(edits, function(id) {
    if (form = $(editor).find('[data-clrctrl-val=' + id + ']')[0]) {
      forms[id] = {
        slider: $(form).find('input[type=range]')[0],
        meter: $(form).find('input[type=text]')[0],
        preview: $(editor).find('[data-clrctrl=preview]')[0],
        value: 50
      }
    }
  })

  $.each(forms, function(id, form){
   $(form.slider).on('input', updateUI)
   $(form.meter).on('input', function(event){
     forms[id].value = this.value
     updateUI()
   })

   function updateUI() {
     $.each(forms, function(id, form){
       form = forms[id]
       $(form.slider).prop({'value': form.value})
     $(form.meter).prop({'value': form.value})
     $(form.preview).css({
       'background-color': getColor(forms)
     })
     })
    }

  })

})

function getColor(forms) {
  H = forms['H'].value
  S = forms['S'].value
  L = forms['L'].value
  color = 'hsl(' + H + ', ' + S + '%, ' + L + '%)'
  console.log(color)
  return color
}
