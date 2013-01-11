poly.pane = {}
poly.pane.make = (spec, grp) -> new Pane spec, grp
class Pane
  constructor: (spec, multiindex) ->
    @spec = spec
    @index = multiindex
    @str = ''
    for k, v of multiindex
      if @str then @str += ","
      @str += "#{k}: #{v}"
  make: (spec, data) ->
    @layers ?= @_makeLayers spec
    @title ?= @_makeTitle spec
    @title.make title: @str
    for layer, id in @layers
      layer.make spec.layers[id], data[id].statData, data[id].metaData
    @domains = @_makeDomains spec, @layers
  _makeTitle: () -> poly.guide.title('facet')
  _makeLayers: (spec) ->
    _.map spec.layers, (layerSpec) -> poly.layer.make(layerSpec, spec.strict)
  _makeDomains: (spec, layers) ->
    poly.domain.make layers, spec.guides, spec.strict
  render: (renderer, offset, clipping, dims) ->
    @title.render renderer(offset, false), dims, {}
    for layer in @layers
      {sampled} = layer.render renderer(offset, clipping)
