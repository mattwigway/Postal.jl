# matches libpostal_duplicate_options
struct DuplicateOptions
    num_languages::Csize_t
    languages::Ptr{Cstring}
end

# These codes must match libpostal.h
@enumx DuplicateStatus NullDuplicate=-1 NonDuplicate=0 PossibleDuplicateNeedsReview=3 LikelyDuplicate=6 ExactDuplicate=9

for label in ["name", "street", "house_number", "po_box", "unit", "floor", "postal_code"]
    fname = Symbol("is_$(label)_duplicate")
    libpostal_fname = Symbol("libpostal_is_$(label)_duplicate")
    @eval function $fname(a, b)
        opts = @ccall libpostal.libpostal_get_default_duplicate_options()::DuplicateOptions
        return DuplicateStatus.T(@ccall libpostal.$libpostal_fname(a::Cstring, b::Cstring, opts::DuplicateOptions)::Cint)
    end
end