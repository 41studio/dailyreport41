# Store detached versions of body tags inserted by MiniProfiler when fetching a new page with Turbolinks
storeMiniProfileBodyTags =->
  if $('#mini-profiler').length and not window.MiniProfileBodyTags
    window.MiniProfileBodyTags = {}
    window.MiniProfileBodyTags.Container = $('.profiler-results').detach()
    window.MiniProfileBodyTags.Templates = $('script[type="text/x-jquery-tmpl"]').detach()

# Copy detached tags back into the body when changing pages with Turbolinks
migrateMiniProfileBodyTags =->
  if window.MiniProfileBodyTags
    $body = $('body')
    $body.append(window.MiniProfileBodyTags.Container)
    $body.append(window.MiniProfileBodyTags.Templates)

# doc.ready init
$ ->
  $(document).bind('page:change', migrateMiniProfileBodyTags)
  $(document).bind('page:fetch', storeMiniProfileBodyTags)
  $(document).on 'turbolinks:load', ->
    migrateMiniProfileBodyTags
    storeMiniProfileBodyTags
