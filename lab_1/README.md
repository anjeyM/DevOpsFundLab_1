# Practical Lab 1

## Part 2. Create a Bash script using Vim

## Available script methods:

- add (Adds a new username and role to the database).
- backup (Creates a backup for the database).
- restore (Restores a database from a backup file).
- find (Finds a specific user in database).
- list (Prints a list of users from database).
- help (Shows list of all methods).

## Usage:

```
cd scripts
./db.sh method-name
```

## Part 3. Automate the build process with Bash

## Available script methods:

- install (Installs dependencies).
- start (Starts a project).
- build (Builds a project).
- test (Runs tests).
- lint (Runs lint).
- help (Shows list of all methods).

## Usage:

```
cd scripts
./build-client.sh method-name
```

## Part 4. Automate tasks with JSON files

## Available script methods:

- json_copy (Creates a copy of ./db/pipeline.json).
- delete_metadata (Deletes metadata property).
- increment_version (Increments version property).
- set_current_branch (Sets current branch name).
- set_owner (Sets the repo owner).
- set_automatic_pipeline_execution (Sets automatic pipeline execution. default value is false).

## Usage:

```
cd scripts
./update-pipeline-defenition.sh
```
