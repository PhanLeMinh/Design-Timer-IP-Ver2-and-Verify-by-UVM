# Environment setup script for Cadence EDA Tools (Csh / Tcsh)
setenv GENHOME /home/$user/cadence/installs/DDI221/GENUS221
setenv INNHOME /home/$user/cadence/installs/DDI221/INNOVUS221
setenv XCELHOME /home/$user/cadence/installs/XCELIUM2509

setenv LM_LICENSE_FILE 5280@192.168.32.10
setenv CDS_LIC_FILE $LM_LICENSE_FILE

set path = ( $GENHOME/bin $INNHOME/bin $XCELHOME/bin $path )
echo "[INFO] Cadence Genus / Innovus / Xcelium environment loaded successfully."
