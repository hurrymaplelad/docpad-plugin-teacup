fs = require 'fs'

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
      coffee = require 'coffee-script'
      # Wrap the coffeescript module compiler to strip YAML frontmatter
      require.extensions['.coffee'] = (module, filename) ->
        raw = fs.readFileSync filename, 'utf8'
        stripped = if raw.charCodeAt(0) is 0xFEFF then raw.substring 1 else raw
        stripped = stripped.replace /^---[\s\S]+^---/m, ''
        module._compile coffee.compile(stripped, {filename}), filename

      # Prepare
      {render} = require('teacup')
      {templateData, content} = opts
      templatePath = opts.file.get('fullPath')

      try
        # Grab function exported from coffeescript module source 
        template = require(templatePath).bind(templateData)
        # Render
        opts.content = render(template, templateData)
      catch err
        next(err)

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
