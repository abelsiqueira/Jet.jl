using DataStructures, JSON

function hfun_jetdata()
  data = JSON.parsefile(joinpath(@__DIR__, "data.json"), dicttype=OrderedDict)

  output = ""
  opened = false
  for entry in data
    if entry["kind"] == "header"
      opened && (output *= "```\n")
      output *= "## " * entry["package"] * "\n"
      output *= entry["description"] * "\n"
      output *= "```julia\n"
      opened = true
    else
      output *= "- " * entry["description"] * "\n"
      output *= "  " * entry["command"] * "\n\n"
    end
  end
  output *= "```\n"
  # return output
  return fd2html(output, internal=true)
end

function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

function lx_baz(com, _)
  # keep this first line
  brace_content = Franklin.content(com.braces[1]) # input string
  # do whatever you want here
  return uppercase(brace_content)
end
