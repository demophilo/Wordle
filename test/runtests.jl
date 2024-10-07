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
	@test cleanword("äëïöü") == "äeiöü"
	@test cleanword("ç") == "c"
	@test cleanword("ñ") == "n"
	@test cleanword("Ñ") == "N"
end

@testset "compare_strings" begin
	@test compare_strings("zinne", "zinne") == [2, 2, 2, 2, 2]
	@test compare_strings("zinne", "tinne") == [0, 2, 2, 2, 2]
	@test compare_strings("zinne", "nnnie") == [1, 0, 2, 1, 2]
	@test compare_strings("zinne", "xarrs") == [0, 0, 0, 0, 0]
	@test compare_strings("zinne", "eggau") == [1, 0, 0, 0, 0]
	@test compare_strings("zinne", "zinnn") == [2, 2, 2, 2, 0]
	@test compare_strings("zünne", "zinnn") == [2, 0, 2, 2, 0]
end

@testset "check_input_letters" begin
	@test check_input_letters("zinne", 5) == true
	@test check_input_letters("zinn", 5) == false
	@test check_input_letters("zin nn", 5) == true
	@test check_input_letters("üöÄäß", 5) == true
end
