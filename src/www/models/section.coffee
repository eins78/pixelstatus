xhr = require('xhr')
Model = require('ampersand-model')

module.exports = Model.extend
  # hack: always fetch self on init. (app always renders everything)
  initialize: ()->
    this.fetch()

  props:
    id: 'string'
    color: 'string'

  session:
    editing:
      type: 'boolean'
      default: false

  # TODO: update all atributes
  updateColor: (new_color)->
    old_color = this.color
    xhr {
      url: this.url(),
      method: 'PATCH',
      json: {color: new_color}
    }, (err, resp, body)=>
      if (err)
        this.set('color', old_color)
        console.error('update color error!', err)
      else
        this.set('color', new_color)
