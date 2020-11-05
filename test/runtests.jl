using DataStructures
using Jet
using JSON
using Test

include("output.jl")

function tests()
  @testset "Basic functionality" begin
    @test jet("pkg:Jet", false) == jet("package:Jet", false) == jet_pkg("Jet", false) == jet_pkg_Jet
    @test jet("cmd:}", false) == jet("command:}", false) == jet("}", false) == jet_snippet("}", false) == jet_snippet_repl
    @test jet("pkg:Jet cmd:for", false) == jet("cmd:for pkg:Jet", false) == jet_snippet_in("for", "Jet", false) == jet_search_for
    @test jet("?", false) == jet("help", false) == jet_snippet_help
    @test jet("?", true) === jet("?") === jet_pkg("Jet") === jet_snippet("?") === jet_snippet_in("?", "Jet") === nothing
  end

  @testset "Fuzzy Search" begin
    @test jet_pkg("datafarmes", false) == jet_pkg("DataFrames", false)
    @test jet("pkg:datafarm4es", false) == jet("pkg:DataFrames", false)
    @test jet("bopxlot", false) == jet("boxplot", false)
  end

  @testset "Data is sorted" begin
    p(x) = x["package"]
    o(x) = Dict("header" => 1, "snippet" => 2)[x["kind"]]
    ℓ(x) = length(x["description"])
    sorted_data = sort(sort.(deepcopy(Jet.data)), by=x->(p(x),o(x),ℓ(x)))
    @test Jet.data == sorted_data
    for (x,y) in zip(Jet.data, sorted_data)
      sort!(y["tags"])
      for (p,q) in zip(x, y)
        @test p == q
      end
    end
  end

  @testset "Errors" begin
    @test_throws ErrorException("Unexpected number of actions. See Jet's help") jet("pkg:Foo cmd:Bar cmd:FooBar")
    @test_throws ErrorException("Unexpected action what. See Jet's help") jet("what:now")
    @test_throws ErrorException("Unexpected compound action `potato:... tomato:...`. Maybe you meant `pkg:tomato cmd:potato`?") jet("potato:tomato tomato:potato")
    @test_throws ErrorException("kind \"wrong\" not accepted. It should be \"header\" or \"snippet\"") new_entry("", "wrong", "", "", [])
    @test_throws ErrorException("Please pass some tags.") new_entry("", "header", "", "", [])
    @test_throws ErrorException("For kind=\"header\", cmd should be \"\"") new_entry("", "header", "empty", "", ["tags"])
  end

  @testset "Creating data" begin
    original_data = deepcopy(Jet.data)
    manual_data = deepcopy(Jet.data)
    new_pkg("FAKE", "FAKE description", ["A", "B"])
    new_snippet("FAKE", "1 = 0", "FAKE snippet", ["C", "D"])
    new_snippet("1 < 0", "Another FAKE snippet", ["C", "E"])
    push!(manual_data, OrderedDict(
      "command" => "",
      "description" => "FAKE description",
      "kind" => "header",
      "package" => "FAKE",
      "tags" => ["A", "B"]
    ))
    push!(manual_data, OrderedDict(
      "command" => "1 = 0",
      "description" => "FAKE snippet",
      "kind" => "snippet",
      "package" => "FAKE",
      "tags" => ["C", "D"]
    ))
    push!(manual_data, OrderedDict(
      "command" => "1 < 0",
      "description" => "Another FAKE snippet",
      "kind" => "snippet",
      "package" => "",
      "tags" => ["C", "E"]
    ))
    p(x) = x["package"]
    o(x) = Dict("header" => 1, "snippet" => 2)[x["kind"]]
    ℓ(x) = length(x["description"])
    sort!(manual_data, by=x->(p(x),o(x),ℓ(x)))
    @test Jet.data == manual_data
    for (x,y) in zip(Jet.data, manual_data)
      for (p,q) in zip(x, y)
        @test p == q
      end
    end
    # Writing back the correct data
    open(joinpath(@__DIR__, "..", "data.json"), "w") do io
      JSON.print(io, original_data, 2)
    end
  end
end

tests()
