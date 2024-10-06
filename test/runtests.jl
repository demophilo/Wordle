using Test
using JSON3
include("../src/wordle.jl")
using .wordle

@testset "make_word_vector" begin
	word_vector = make_word_vector("../data/raw/wortliste.json", 5)
	@test length(word_vector[1]) == 5
	@test "Zinne" in word_vector
end

@testset "cleanword" begin
    @test cleanword("áéíóú") == "aeiou"
    @test cleanword("àèìòù") == "aeiou"
    @test cleanword("âêîôû") == "aeiou"
    @test cleanword("ãõ") == "ao"
    @test cleanword("å") == "a"
    @test cleanword("äëïöü") == "aeiou"
    @test cleanword("ç") == "c"
    @test cleanword("ñ") == "n"
    @test cleanword("Ñ") == "N"
end
