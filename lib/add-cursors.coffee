AddCursorsView = require './add-cursors-view'
{CompositeDisposable, Point, Range} = require 'atom'

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

  selectionExists: ->
    selections = @editor.getSelections()
    if selections
      for selection in selections
        if selection.getText().length > 0
          return true
    false

  left: ->
    if @editor = atom.workspace.getActiveTextEditor()
      if @selectionExists()
        selections = @editor.getSelections()
        for selection in selections
          range = selection.getScreenRange()
          selection.clear()
          for line in range.getRows()
            @editor.addCursorAtScreenPosition [line, 0]
      else
        @removeCursors()
        lines = @editor.getLineCount()
        for line in [0..lines-1]
          @editor.addCursorAtScreenPosition [line, 0]

  right: ->
    @left()
    cursors = @editor.getCursors()
    for cursor in cursors
      cursor.moveToEndOfScreenLine()
