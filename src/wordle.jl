module wordle

using JSON3

export make_word_vector, word_list_path


word_list_path = "data/raw/wortliste.json"

function make_word_vector(json_path::String, length_of_words::Int)
	file = open(json_path, "r")
	words = JSON3.read(file)
	close(file)
	word_vector = filter(word -> length(word) == length_of_words, words)

	return word_vector
end

end # module wordle
