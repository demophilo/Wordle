module wordle

using JSON3

export make_word_vector, word_list_path, cleanword


word_list_path = "data/raw/wortliste.json"

function make_word_vector(json_path::String, length_of_words::Int)
	file = open(json_path, "r")
	words = JSON3.read(file)
	close(file)
	word_vector = filter(word -> length(word) == length_of_words, words)

	return word_vector
end

function cleanword(input::AbstractString)
	changetable = Dict(
		'á' => 'a', 'à' => 'a', 'â' => 'a', 'ã' => 'a', 'å' => 'a', 'ä' => 'a',
		'é' => 'e', 'è' => 'e', 'ê' => 'e', 'ë' => 'e',
		'í' => 'i', 'ì' => 'i', 'î' => 'i', 'ï' => 'i',
		'ó' => 'o', 'ò' => 'o', 'ô' => 'o', 'õ' => 'o', 'ø' => 'o', 'ö' => 'o',
		'ú' => 'u', 'ù' => 'u', 'û' => 'u', 'ü' => 'u',
		'ç' => 'c',
		'ñ' => 'n', 'Ñ' => 'N'
	)

	output = ""
	for char in input
		output *= haskey(changetable, char) ? changetable[char] : char
	end
	return output
end

end # module word


#word_vector = make_word_vector(word_list_path, 5)
#println(word_vector)