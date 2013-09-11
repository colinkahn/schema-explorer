APP.filter "prettifyHtml", ->
  elementHTML = (element) ->
    $("<div/>").append(element.clone()).html()

  indentLine = (html, indents) ->
    s = ""
    c = 0
    while c < indents
      s += "  "
      c += 1

    s + html + "\n"

  indentRecursive = (element, indents = 0) ->

    if not element.children().length
      html = elementHTML element
      return indentLine html, indents
    else
      children = element.children().remove()
      html     = elementHTML element

      index      = html.indexOf "><"
      closingTag = html.substring index+1
      html       = html.replace closingTag, ""
      html       = indentLine html, indents

      for child in children
        html += indentRecursive $(child), indents+1

      return html+ indentLine closingTag, indents

  (element) ->
    html = indentRecursive element
    return html



