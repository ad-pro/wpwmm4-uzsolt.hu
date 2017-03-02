COMP_LISTS!=sed -n \
  '/^\/comp\/[^\|]*\/[^\|]*\// s,/\([^\|]*\)/.*,\1,p' \
  ${MENUDATAFILE}

.for C in ${COMP_LISTS}
CTANEV_${C}!=cut -d \| -f 1 data/${C}.psv | sort -u
CEVF_${C}!=cut -d \| -f 2 data/${C}.psv | sort -u
VIRTUALOUT_list_evf_pdf+=${CEVF_${C}:S/^/${C}\//:=.html}
VIRTUALOUT_list_tanev_pdf+=${CTANEV_${C}:S/^/${C}\//:=.html}
.endfor
