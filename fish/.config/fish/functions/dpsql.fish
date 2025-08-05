# ~/.config/fish/functions/dpsql.fish
function dpsql --wraps psql -d "Run psql in a Docker container"
    # Find the first running container based on the official 'postgres' image.
    set -l container (docker ps --filter "name=dtsp-db-v3" --format "{{.Names}}" | head -n 1)

    # If no container is found, print an error and exit.
    if not test -n "$container"
        echo "Error: No running Docker container based on the 'postgres' image found." >&2
        return 1
    end

    # Let the user know which container is being used.
    echo -e "\e[32mFound container: '$container'. Connecting...\e[0m"

    # Default to 'postgres' database if no arguments are given.
    set -l dbname postgres
    set -l query ""

    # If at least one argument is given, it's the database name.
    if test (count $argv) -ge 1
        set dbname $argv[1]
    end

    # If a second argument is given, it's the query.
    if test (count $argv) -ge 2
        set query $argv[2]
    end

    # If a query is provided, execute it non-interactively.
    if test -n "$query"
        docker exec -i $container psql -U postgres -d "$dbname" -c "$query"
    else
        # Otherwise, start an interactive psql shell on the specified database.
        docker exec -it $container psql -U postgres -d "$dbname"
    end
end
