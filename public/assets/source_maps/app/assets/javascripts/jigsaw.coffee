class @Jigsaw
  setup: ->
    $('#filterable_list').waitForImages ->
      options = {
        valueNames: ['title', 'description', 'tag']
      }

      list = new List('filterable_list', options);

      container = document.querySelector('.jigsaw_grid');
      layout = new Masonry( container, {
        isFitWidth: true,
        columnWidth: 200,
        gutter: 20,
        itemSelector: '.jigsaw_item'
      });

      triggerLayoutReload = ()->
        layout.layout()

      list.on('updated', triggerLayoutReload)

      # Clippable trigger
      clippable = $('.clippable')
      clippable.on('click', triggerLayoutReload)
