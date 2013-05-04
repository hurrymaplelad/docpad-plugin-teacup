# Export Plugin
module.exports = (BasePlugin) ->
  # Define Plugin
  class TeacupPlugin extends BasePlugin
    # Plugin name
    name: 'teacup'

    # Plugin config
    config: {}

    # =============================
    # Renderers

    # Render Teacup
    renderTeacup: (opts, next) ->
      # Prepare
      {templateData, content} = opts
      {render} = require('teacup')
      coffee = require('coffee-script')
      vm = require('vm')

      sandbox =
        module: exports: {}
        require: require

      # Grab function exported from coffeescript module source 
      template = null
      try
        vm.runInNewContext(coffee.compile(content), sandbox)
        template = sandbox.module.exports
      catch err
        next(err)

      # Render
      opts.content = render(template, templateData)

      # Done
      next()

    # =============================
    # Events

    # Render
    # Called per document, for each extension conversion. Used to render one extension to another.
    render: (opts, next) ->
      # Prepare
      {inExtension, outExtension} = opts

      # Teacup
      if inExtension in ['teacup', 'coffee'] and (outExtension in ['js','css']) is false
        # Render and complete
        @renderTeacup(opts, next)

      # Something else
      else
        # Nothing to do, return back to DocPad
        return next()
