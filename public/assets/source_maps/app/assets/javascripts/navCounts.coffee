class @NavCounts
  setup: ->
    pageNav = $('a[data-studiable-count]','.main.nav .group.of.navigation.links')

    pageNav.each ->
      $this = $(this)
      count = $this.attr("data-studiable-count")

      if count > 0
        countMarkup = '<span class="nav_count">' + count + '</span>'
        $this.append(countMarkup)
