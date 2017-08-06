# Where the sources (m4) are.
SRC_DIR=src/

# Destination directory
DEST_DIR=/usr/local/www/uzsolt/
COMMON_DIR=/home/zsolt/git/wpwmm4/
.ifdef WIP
include wip.mk
.endif
# Where the layouts are.
LAYOUT_DIR=layout/

# Virtual directory
VIRT_DIR=virtual/

# Targets in ${DEST_DIR}
TARGETS=index.html \
	news.html \
	about/cv.html \
	about/index.html \
	edu/phys/art/index.html \
	notes/bsd/copy_cddvd.html \
	notes/bsd/daemon.html \
	notes/bsd/dump_volume.html \
	notes/bsd/vmware.html \
	notes/cli/feh_wallpaper.html \
	notes/cli/ffmpeg_dvd_player.html \
	notes/cli/html_parse.html \
	notes/cli/pdf_jelszo.html \
	notes/cli/pdfjam.html \
	notes/cli/rsync_transmission.html \
	notes/joke/curry.html \
	notes/joke/kenyer.html \
	notes/latex/angles.html \
	notes/latex/grid.html \
	notes/latex/randomize_exsheets.html \
	notes/latex/segments.html \
	notes/latex/smiley.html \
	notes/phys/atom.html \
	notes/phys/h2o.html \
	notes/web/gyors-oldal.html
index.html_REQ=scripts/genmain.sh data/news.psv ${LAYOUT_DIR}main.m4
news.html_REQ=${index.html_REQ}
edu/phys/art/index.html_REQ=scripts/select_art.sh data/art_lists.psv
.for T in ${TARGETS}
.if ${T:C,/.*,,}==notes
${T}_REQ+=${LAYOUT_DIR}note.m4
.endif
.endfor

TARGETS_MANUAL=feed.xml
${DEST_DIR}feed.xml: data/news.psv scripts/genrss.sh
	${MSG1} Generating feed.xml...
	@scripts/genrss.sh > ${.TARGET}

CSS_FILES=main syntax
.for css in ${CSS_FILES}
TARGETS_MANUAL+=css/${css}.css
${DEST_DIR}css/${css}.css: assets/css/${css}.css
	@mkdir -p ${DEST_DIR}css
	sassc -t compressed ${.ALLSRC} ${.TARGET}
.endfor

MKDIR_REQ=data/menu.psv mk/comp_lists.mk

notes/latex/angles.html_REQ=${DEST_DIR}notes/latex/angles.png
notes/latex/grid.html_REQ=${DEST_DIR}notes/latex/grid.png
notes/latex/segments.html_REQ=${DEST_DIR}notes/latex/segments.png
.include "mk/latex_png.mk"

# Global requirement
GREQ=${MENUTARGET} include/01_header.m4

# Category of virtually created files.
# Name of values will use the ${value}.m4 inside ${VIRT_DIR}.
VIRTUALS=kep \
		 keplist \
		 menu \
		 edumath eduphys \
		 notes_list \
		 select_comp \
		 select_exams_evf \
		 select_tanev_evf \
		 select_tanev select_evf\
		 list_evf_pdf list_tanev_pdf \
		 list_art_pdf \
		 pdf exams_pdf

MENUDATAFILE=data/menu.psv
STATICDIR=/usr/local/www/static/

include mk/v_menu.mk
include mk/v_edumath.mk
include mk/v_eduphys.mk
include mk/v_keplist.mk
include mk/v_kep.mk
include mk/v_notes_list.mk
include mk/v_select_comp.mk
include mk/v_select_exams_evf.mk
include mk/v_select_tanev_evf.mk
include mk/v_select_tanev.mk
include mk/v_select_evf.mk
include mk/v_list_evf_pdf.mk
include mk/v_list_tanev_pdf.mk
include mk/v_list_art.mk
include mk/v_pdf.mk
include mk/v_exams_pdf.mk
include mk/comp_lists.mk
include mk/generate_menu.mk

pre-everything:

clean-other:
	rm -rf menu
