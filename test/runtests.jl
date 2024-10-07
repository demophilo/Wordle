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

@testset "check_word_for_validity" begin
    word_vector = make_word_vector("../data/raw/wortliste.json", 5)

    @test check_word_for_validity(word_vector, "Zinne") 
    @test !check_word_for_validity(word_vector, "Zinn")
    @test !check_word_for_validity(word_vector, "Zinnn") 
end

@testset "get_color_dict" begin
	color_dict = get_color_dict()

	@test color_dict["red"] == "\e[31m"
	@test color_dict["green"] == "\e[32m"
	@test color_dict["yellow"] == "\e[33m"
	@test color_dict["blue"] == "\e[34m"
	@test color_dict["purple"] == "\e[35m"
	@test color_dict["lightblue"] == "\e[36m"
	@test color_dict["white"] == "\e[37m"
	@test color_dict["lightred"] == "\e[91m"
	@test color_dict["green2"] == "\e[92m"
	@test color_dict["lightyellow"] == "\e[93m"
	@test color_dict["lightpurple"] == "\e[95m"
	@test color_dict["cyan"] == "\e[96m"
end

@testset "colorize_string" begin
	color_dict = get_color_dict()
	colored_string = colorize_string("Hello World!", color_dict, "red")

	@test colored_string == "\e[31mHello World!\e[0m"
end