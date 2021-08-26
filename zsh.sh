alias gcaa='git commit -a --amend -C HEAD'

function branch-merge() {
  git checkout $1 && git pull origin $1 && git pull origin $2 && git merge $2
}

function bsync() {
  gch $1 && gpull $2 && gpush && gch $2 && gpull $1 && gpush
}

function gpush() {
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  echo "pushing to '$CURRENT_BRANCH'"
  git push origin $CURRENT_BRANCH
}

function gch() {
  git checkout $1 && git pull origin $1
}

function gchb() {
  git checkout -b $1
}

function gac() {
  git add . && git commit -m $1 $2
}

function gpull() {
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  if [ -z "$1" ]
  then
    echo "pulling '$CURRENT_BRANCH'"
    git pull origin $CURRENT_BRANCH
  else
    echo "pulling '$1' into '$CURRENT_BRANCH'"
    git pull origin $1
  fi
}

function gacp() {
  gac && gpush
}

alias mss='gch master && gpull @staging && gpush && gch @staging && gpull master && gpush'
alias sds='gch @staging && gpull @develop && gpush && gch @develop && gpull @staging && gpush'

alias app_dev_sync='gch dev-android && gpull dev && gpush && gch dev-ios && gpull dev && gpush && gch dev'
alias app_staging_sync='gch staging && gpull dev && gpush && gch dev && gpull staging && gpush && gch staging-android && gpull dev-android && gpush && gch staging-ios && gpull dev-ios && gpush && gch staging'
alias app_master_sync='gch master && gpull staging && gpush && gch staging && gpull master && gpush && gch master-android && gpull staging-android && gpush && gch master-ios && gpull staging-ios && gpush && gch master'

function stage_apk_build() {
  flutter clean && flutter pub get && flutter build apk --flavor dev --dart-define=CUSTOM_ENV=stage && open build/app/outputs/flutter-apk/
}
function stage_apk_bundle_build() {
  flutter clean && flutter pub get && flutter build appbundle --flavor dev --release --dart-define=CUSTOM_ENV=stage
}

function android_run() {
  flutter clean && flutter pub get && flutter run -t lib/main_dev.dart --flavor $1 --dart-define=CUSTOM_ENV=$2
}

function ios_run() {
  flutter clean && flutter pub get && flutter run -t lib/main_dev.dart --dart-define=CUSTOM_ENV=$1 | grep -v "Error retrieving thread information"
}

function stage_ios_build() {
  flutter clean && flutter pub get && cd ios && pod deintegrate && pod clean && arch -x86_64 pod install && flutter build ios --dart-define=CUSTOM_ENV=stage
}