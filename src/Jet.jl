module Jet

using Crayons
using DataStructures
using JSON
using Markdown
using ReplMaker
using StringDistances

function __init__()
  global data = JSON.parsefile(joinpath(@__DIR__, "..", "data.json"), dicttype=OrderedDict{String,Any})
end

include("actions.jl")
include("format.jl")
include("new.jl")
include("repl.jl")

end # module