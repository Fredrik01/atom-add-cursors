AddCursorsView = require './add-cursors-view'
{CompositeDisposable, Point} = require 'atom'

module.exports = AddCursors =
  addCursorsView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'add-cursors:left': => @left()
    @subscriptions.add atom.commands.add 'atom-workspace',
      'add-cursors:right': => @right()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @addCursorsView.destroy()

  serialize: ->
    addCursorsViewState: @addCursorsView.serialize()

  removeCursors: ->
    cursors = @editor.getCursors()
    for cursor in cursors
      cursor.moveToBeginningOfScreenLine()

  left: ->
    if @editor = atom.workspace.getActiveTextEditor()
      @removeCursors()
      lines = @editor.getLineCount()
      console.log lines
      for line in [0..lines-1]
        @editor.addCursorAtScreenPosition [line, 0]

  right: ->
    @left()
    cursors = @editor.getCursors()
    for cursor in cursors
      cursor.moveToEndOfScreenLine()
