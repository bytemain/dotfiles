mkdir -p .tmp
TMPFILE=$(mktemp .tmp/git-commit-status-message.XXX);
git status --porcelain \
    | grep '^[MARCDT]' \
    | sort \
    | sed -re 's/^([[:upper:]])[[:upper:]]?[[:space:]]+/\1:\n/' \
    | awk '!x[$0]++' \
    | sed -re 's/^([[:upper:]]:)$/\n\1/' \
    | sed -re 's/^M:$/Modified: /' \
    | sed -re 's/^A:$/Added: /' \
    | sed -re 's/^R:$/Renamed: /' \
    | sed -re 's/^C:$/Copied: /' \
    | sed -re 's/^D:$/Deleted: /' \
    | sed -re 's/^T:$/File Type Changed: /' \
    | tr '\n' ' ' | xargs \
    > $TMPFILE; \
git commit -F $TMPFILE; \
rm -f $TMPFILE \
