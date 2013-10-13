Template.beam.helpers
  parse: (m) ->
    if m.split(' ').length > 1 or /\<|\>|'|"/.test(m)
      return m
    if /^http/.test m
      return new Handlebars.SafeString("<a target='_blank' href='#{m}'>#{m}</a>")
    return m
  'user': ->
    Meteor.user()?.profile.name
  'messages': -> Messages.find()
  'yours': ->
    if @userId is Meteor.userId() then "yours" else ""
  'klass': ->
    if @status is "is done." then "done" else "typing"
  'prof': ->
    fbId = Meteor.user().services.facebook.id
    "https://graph.facebook.com/#{fbId}/picture"

update_message = (status) ->
  current = $('#message').val()
  return unless current.trim()
  messageId = Session.get("messageId")
  if messageId
    Messages.update(messageId, {$set: {message: current, status: status}})
  else
    message =
      message: current
      userId: Meteor.userId()
      name: Meteor.user().profile.name
      status: status
      fbId: Meteor.user()?.services.facebook.id
    messageId = Messages.insert message
    Session.set("messageId", messageId)
  if status is "is done."
    $('#message').val ''
    Session.set("messageId") # clear
  return false


Template.beam.events
  'keyup #message': (e) ->
    status = if e.keyCode is 13 then "is done." else "is typing..."
    update_message status

Template.beam.rendered = ->
  $('html, body').scrollTop( $(document).height() - $(window).height() )
