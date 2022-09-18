#!/bin/bash

NOW=`date +"%d_%m_%Y"`
JSON_COPY=$(find "../data" -type f -iname "*-pipeline.db" |sort |head -n1)
COPIED_JSON=../data/pipeline-$NOW.json

# Creates a copy of json.
json_copy() {
	if [[ -z ${JSON_COPY} ]]; then
    	cp ../data/pipeline.json ../data/pipeline-$NOW.json
	fi
}

# Deletes metadata property
delete_metadata() {
	tmp=$(mktemp)
	HAS_PROPERTY=$(jq 'has("metadata")' $COPIED_JSON)
	if [[ -z ${JSON_COPY} ]] && [[ $HAS_PROPERTY ]]; then
		# Use mktemp to delete property on place 
		jq 'del(.metadata)' $COPIED_JSON > "$tmp" && mv "$tmp" $COPIED_JSON
	else
		echo -e "\033[31mNo JSON file found\033[0m"
		return
	fi
}

# Increments version property
increment_version() {
	tmp=$(mktemp)
	HAS_PROPERTY=$(jq 'has("version")' $COPIED_JSON)
	if [[ -z ${JSON_COPY} ]] && [[ $HAS_PROPERTY ]]; then
		current_version= jq ' .pipeline | .version +1' $COPIED_JSON
		NEXT_VERSION=$(($current_version + 2))
		jq --argjson current_version "${NEXT_VERSION}" '.pipeline.version = $current_version' $COPIED_JSON > "$tmp" && mv "$tmp" $COPIED_JSON
	else
		echo -e "\033[31mNo JSON file found\033[0m"
		return
	fi
}

# Sets current branch name
set_current_branch() {
	tmp=$(mktemp)
	BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
	HAS_PROPERTY=$(jq 'has("Branch")' $COPIED_JSON)
	if [[ -z ${JSON_COPY} ]] && [[ $HAS_PROPERTY ]]; then
		jq --arg BRANCH "$BRANCH" '.pipeline.stages[].actions[].configuration.Branch = $BRANCH' $COPIED_JSON > "$tmp" && mv "$tmp" $COPIED_JSON
	else
		echo -e "\033[31mNo JSON file found\033[0m"
		return
	fi
}

# Sets the repo owner
set_owner() {
	repo_url=$(git config --get remote.origin.url)
	NAME=${repo_url%/*}
	HAS_PROPERTY=$(jq 'has("Owner")' $COPIED_JSON)
	if [[ -z ${JSON_COPY} ]] && [[ $HAS_PROPERTY ]]; then
		jq --arg NAME "$NAME" '.pipeline.stages[].actions[].configuration.Owner = $NAME' $COPIED_JSON > "$tmp" && mv "$tmp" $COPIED_JSON
	else
		echo -e "\033[31mNo JSON file found\033[0m"
		return
	fi
}

# Sets automatic pipeline execution. default value is false
set_automatic_pipeline_execution() {
	IS_AUTOMATIC="${1:-false}"
	HAS_PROPERTY=$(jq 'has("PollForSourceChanges")' $COPIED_JSON)
	if [[ -z ${JSON_COPY} ]] && [[ $HAS_PROPERTY ]]; then
		jq --arg IS_AUTOMATIC "$IS_AUTOMATIC" '.pipeline.stages[].actions[].configuration.PollForSourceChanges = $IS_AUTOMATIC' $COPIED_JSON > "$tmp" && mv "$tmp" $COPIED_JSON
	else
		echo -e "\033[31mNo JSON file found\033[0m"
		return
	fi
}

json_copy
delete_metadata
increment_version
set_current_branch
set_owner
set_automatic_pipeline_execution true

"$@"