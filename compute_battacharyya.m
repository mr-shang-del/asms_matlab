function similarity = compute_bhattacharyya(h1, h2)
    similarity = sum(sqrt(h1 .* h2));
end

