# matches libpostal_address_parser_response
struct ParserResponse
    num_components::Csize_t
    components::Ptr{Cstring}
    labels::Ptr{Cstring}
end

function Base.convert(::Type{Dict{String, String}}, r::ParserResponse)
    components = unsafe_string.(unsafe_wrap(Array, r.components, r.num_components))
    labels = unsafe_string.(unsafe_wrap(Array, r.labels, r.num_components))
    Dict{String, String}(zip(labels, components))
end

# matches libpostal_address_parser_options
struct AddressParserOptions
    language::Cstring
    country::Cstring
end

function parse_address(address)
    # TODO options
    
    opts = @ccall libpostal.libpostal_get_address_parser_default_options()::AddressParserOptions
    resptr = @ccall libpostal.libpostal_parse_address(address::Cstring, opts::AddressParserOptions)::Ptr{ParserResponse}

    try
        result = convert(Dict{String, String}, unsafe_load(resptr))
        return result
    finally
        @ccall libpostal.libpostal_address_parser_response_destroy(resptr::Ptr{ParserResponse})::Cvoid
    end
end