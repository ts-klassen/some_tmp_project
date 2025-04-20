#!/usr/bin/awk -f
# Usage: awk -v num=01 -f extract_query.awk queries.sql
# Extracts the SQL statement that corresponds to the comment marker
# "-- 01" (or any two‑digit number) in queries.sql.

BEGIN {
    target = sprintf("-- %02d", num + 0);
    found = 0;
}

# Strip Windows CR
{ sub(/\r$/, ""); }

# Detect the marker line
index($0, target) == 1 {
    found = 1;
    next;
}

# Next marker means stop
found && /^-- [0-9][0-9]/ {
    exit;
}

# While in target section, print lines
found {
    print;
}