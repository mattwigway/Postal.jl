struct NormalizeOptions
    # List of language codes
    languages::Ptr{Cstring}
    num_languages::Csize_t
    address_components::UInt16

    # String options
    latin_ascii::Bool
    transliterate::Bool
    strip_accents::Bool
    decompose::Bool
    lowercase::Bool
    trim_string::Bool
    drop_parentheticals::Bool
    replace_numeric_hyphens::Bool
    delete_numeric_hyphens::Bool
    split_alpha_from_numeric::Bool
    replace_word_hyphens::Bool
    delete_word_hyphens::Bool
    delete_final_periods::Bool
    delete_acronym_periods::Bool
    drop_english_possessives::Bool
    delete_apostrophes::Bool
    expand_numex::Bool
    roman_numerals::Bool
end

function expand_address(address; options=nothing)
    opts = if !isnothing(options)
        options
    else
        # does not need to be destroyed, returns a const
        @ccall libpostal.libpostal_get_default_options()::NormalizeOptions
    end

    outsize = zeros(UInt64, 1)

    # libpostal returns a char ** - i.e. a pointer to the start of an array of pointers to strings
    resptr = @ccall libpostal.libpostal_expand_address(address::Cstring, opts::NormalizeOptions, outsize::Ref{Csize_t})::Ptr{Cstring}
    # unsafe_string copies the string data; it is unsafe because the pointer could be pointing to something other than a string,
    # once it is called the result is safe to use.
    try
        result = unsafe_string.(unsafe_wrap(Array, resptr, outsize[1]))
        return result
    finally
        # free memory
        @ccall libpostal.libpostal_expansion_array_destroy(resptr::Ptr{Ptr{Cstring}}, outsize[1]::Csize_t)::Cvoid
    end
end