# Where the sources (m4) are.
SRC_DIR=src/

SVN!=	which svn || which svnlite

COMMON_DIR=/home/zsolt/svn/wpwmm4/
BRANCH!=	${SVN} info --show-item relative-url | sed 's,.*/,,'
# Destination directory
.if ${BRANCH} == trunk
DEST_DIR=/usr/local/www/uzsolt/
.else
DEST_DIR=/usr/local/www/wip/
.endif
# Where the layouts are.
LAYOUT_DIR=layout/

# Virtual directory
VIRT_DIR=virtual/

HOOK_POST_HTML=${MSG2} Checking validity ; tidy5 -q -e -f /dev/stdout ${.TARGET} | sed '/About/,$$d ; s,^,     ,'
HOOK_POST_VHTML=${HOOK_POST_HTML}

ASSETS_DIR+=	parts/

# Targets in ${DEST_DIR}
.include "mk/about.mk"
.include "mk/edumath_stat.mk"
.include "mk/edu_phys.mk"
.include "mk/notes_bsd.mk"
.include "mk/notes_cli.mk"
.include "mk/notes_eco.mk"
.include "mk/notes_joke.mk"
.include "mk/notes_latex.mk"
.include "mk/notes_other.mk"
.include "mk/notes_phys.mk"
.include "mk/notes_r.mk"
.include "mk/notes_svn.mk"
.include "mk/notes_web.mk"
.include "mk/root.mk"

.for T in ${TARGETS}
.if ${T:C,/.*,,}==notes
${T}_REQ+=${LAYOUT_DIR}note.m4
.endif
.endfor

.include "mk/css.mk"

MKDIR_REQ=data/menu.psv mk/comp_lists.mk

# Global requirement
GREQ=${MENUTARGET} include/01_header.m4

# Category of virtually created files.
.include "mk/virtuals.mk"

MENUDATAFILE=data/menu.psv
STATICDIR=/home/zsolt/svn/uzsolt.hu/static/

include mk/comp_lists.mk
include mk/generate_menu.mk

pre-everything:

clean-other:
	rm -rf menu
