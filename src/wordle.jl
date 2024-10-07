module wordle

using JSON3

export make_word_vector, cleanword, compare_strings, check_input_letters, check_word_for_validity, input_trial, input_game_variant, get_color_dict, colorize_string, get_colorized_string_vector


#word_list_path = "data/raw/wortliste.json"

function make_word_vector(json_path::String, length_of_words::Int)
	file = open(json_path, "r")
	words = JSON3.read(file)
	close(file)
	word_vector = filter(word -> length(word) == length_of_words, words)

	return word_vector
end

function cleanword(input::AbstractString)
	changetable = Dict(
		'á' => 'a', 'à' => 'a', 'â' => 'a', 'ã' => 'a', 'å' => 'a',
		'é' => 'e', 'è' => 'e', 'ê' => 'e', 'ë' => 'e',
		'í' => 'i', 'ì' => 'i', 'î' => 'i', 'ï' => 'i',
		'ó' => 'o', 'ò' => 'o', 'ô' => 'o', 'õ' => 'o', 'ø' => 'o',
		'ú' => 'u', 'ù' => 'u', 'û' => 'u',
		'ç' => 'c',
		'ñ' => 'n', 'Ñ' => 'N'
	)

	output = ""
	for char in input
		output *= haskey(changetable, char) ? changetable[char] : char
	end
	return output
end

function compare_strings(word_to_guess::String, trial_string::String)
	goal_word = cleanword(lowercase(word_to_guess))
	trial_word = cleanword(lowercase(trial_string))
	goal_letter_vector = collect(goal_word)
	trial_letter_vector = collect(trial_word)
	available_goal_vector = fill(1, length(goal_letter_vector))
	right_trial_vector = fill(-1, length(trial_letter_vector))

	for position ∈ eachindex(goal_letter_vector)
		if goal_letter_vector[position] == trial_letter_vector[position]
			available_goal_vector[position] = 0
			right_trial_vector[position] = 2
		end
	end

	for trial_position ∈ eachindex(goal_letter_vector)
		if right_trial_vector[trial_position] != 2
			for goal_position ∈ eachindex(goal_letter_vector)
				if goal_position == length(goal_word)
					if available_goal_vector[goal_position] == 1
						if goal_letter_vector[goal_position] == trial_letter_vector[trial_position]
							available_goal_vector[goal_position] = 0
							right_trial_vector[trial_position] = 1
						else
							right_trial_vector[trial_position] = 0
						end
					else
						right_trial_vector[trial_position] = 0
					end
				else
					if available_goal_vector[goal_position] == 1
						if goal_letter_vector[goal_position] == trial_letter_vector[trial_position]
							available_goal_vector[goal_position] = 0
							right_trial_vector[trial_position] = 1
							break
						end
					end
				end
			end
		end
	end

	return right_trial_vector
end

function check_input_letters(word::String, length_word)::Bool
	word = replace(word, r"\s+" => "")
	if length(word) != length_word
		return false
	end

	if !all(typeof(c) == Char && ('a' <= c <= 'z' || 'A' <= c <= 'Z' || c in "äöüßÄÖÜ") for c in word)
		return false
	end

	return true
end

function check_word_for_validity(word_vector::Vector{String}, word::String)::Bool
	if word ∈ word_vector
		return true
	else
		return false
	end
end


function input_trial(word_vector::Vector{String}, word_length::Int)::String
	word_trial = ""
	while true
		word_trial = lowercase(cleanword(readline()))
		if check_input_letters(word_trial, word_length) && check_word_for_validity(word_vector, word_trial)
			break
		else
			println("Netter Versuch, aber das ist kein deutsches Wort!")
		end
	end

	return word_trial
end

function input_game_variant()
	println("Wie viele Buchstaben soll das Wort haben?\nMöglich sind 4, 5, 6, 7, 8.")
	number_letters::String = ""
	while !(number_letters in ["4", "5", "6", "7", "8"])
		println("Bitte geben Sie eine gültige Zahl ein.")
		number_letters = readline()
	end
	return number_letters
end

function get_color_dict()
	farben = Dict(
		"red" => "\e[31m",
		"green" => "\e[32m",
		"yellow" => "\e[33m",
		"blue" => "\e[34m",
		"purple" => "\e[35m",
		"lightblue" => "\e[36m",
		"white" => "\e[37m",
		"lightred" => "\e[91m",
		"green2" => "\e[92m",
		"lightyellow" => "\e[93m",
		"lightpurple" => "\e[95m",
		"cyan" => "\e[96m"
	)
	return farben
end

function colorize_string(text::String, color_dict::Dict{String, String}, color::String)::String
	_colored_string = color_dict["$color"] * text * "\e[0m"
	return _colored_string
end

function get_colorized_string_vector(word::String, progress::Vector{Int}, color_dict::Dict)::Vector{String}
	word_string_vector = [string(c) for c in collect(word)]
	colorized_string_vector = Vector{String}([])
	for i ∈ eachindex(word_string_vector)
		if progress[i] == 2
			colorized_string = colorize_string(word_string_vector[i], color_dict, "green2")
		elseif progress[i] == 1
			colorized_string = colorize_string(word_string_vector[i], color_dict, "red")
		else
			colorized_string = colorize_string(word_string_vector[i], color_dict, "white")
		end
		push!(colorized_string_vector, colorized_string)
	end
	return colorized_string_vector

end

end # module wordle

