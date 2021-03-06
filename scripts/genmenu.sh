#!/bin/sh

IFS="|"
FILE=data/menu.psv
STR_HOMEPAGE="Kezdőlap"

# $1 : level number
# $2 : url
get_current_level() {
  local ln="$1"
  echo "${2}" | cut -d / -f -$((ln+1))
}

# $1 : pattern
get_pattern() {
  echo "$1/[^/]*/|"
}

print_menu() {

  local level=${1:-0} ; shift
  local current=${1:-""} ; shift
  # level+2: the first character is /
  local next_level=`echo ${current} | cut -d / -f -$((level+2))`

  if [ ${level} -eq 0 ]; then
    local pattern='^http://\|^/[^/]*/|'
  else
    local current_level=`get_current_level ${level} "${current}"`
    local pattern="`get_pattern ${current_level}`"
  fi

  local indentstr=`jot -b ' ' -s '' $((level*2+2))`

  grep "${pattern}" ${FILE} | \
    while read href title tooltip; do
      if echo ${href} | grep -q "^${next_level}/$"; then
        local divclass=selected
      else
        if [ "${level}" -eq 0 ]; then
          local divclass=menu
        else
          local divclass=submenu
        fi
      fi
      printf '%s_DIVB(%s)\n' "${indentstr}" "${divclass}"
      printf '  %s<a href="%s" title="%s" class="menu_href">_DIVB(menu_text)%s _DIVE</a>' "${indentstr}" "${href}" "${tooltip}" "${title}"
      if echo ${href} | grep -q "^${next_level}/$"; then
        local sub_current_level=`get_current_level $((level+1)) "${current}"`
        local sub_pattern="`get_pattern ${sub_current_level}`" #/[^/]*/|"
        if grep -q "${sub_pattern}" ${FILE}; then
          printf "%s_DIVB(div_submenu)\n" "${indentstr}"
          print_menu $((level+1)) ${current}
          printf "%s_DIVE\n" "${indentstr}"
        fi
      fi
      printf "\n%s_DIVE\n" "${indentstr}"
    done

}

# kilistázza a gyökérben levő pontokat (0. szint)
# közben megtalálja a belépési pontot a következő szintre
#   grep-pel az előző szintre
#   közben megtalálja a belépési pontot a következő szintre...
cat << EOF
<div id=menu>
  <a href=/>
  <div id=menu_header><h2>Udvari Zsolt honlapja</h2></div>
  </a>
  _DIVB(div_menu)
EOF

print_menu 0 $*

cat << EOF
  _DIVE
_DIVE
EOF

ACTIVE_FILES=""
if [ "${1}" = "/" ]; then
  ACTIVE_MENU="${STR_HOMEPAGE}"
else
  ACTIVE_MENU=`grep "$1|" ${FILE} data/art_lists.psv data/comp_lists.psv data/video_lists.psv | awk -F '|' '{print $2}'`
  ACTIVE_TOOLTIP=`grep "$1|" ${FILE} data/art_lists.psv data/comp_lists.psv data/video_lists.psv | awk -F '|' '{print $3}'`
  ACTIVE_COMP_TITLE=`grep "$1|" ${FILE} data/comp_lists.psv | awk -F '|' '{print $2}'`
fi

echo "m4_define(_ACTIVEMENU,\`${ACTIVE_MENU}')"
echo "m4_define(_ACTIVETOOLTIP,\`${ACTIVE_TOOLTIP}')"
echo "m4_define(_ACTIVE_COMP_TITLE,\`${ACTIVE_COMP_TITLE}')"

