# Environment setup script for Cadence EDA Tools (Bash)
export GENHOME=/home/dtvt_07/cadence/installs/DDI221/GENUS221
export INNHOME=/home/dtvt_07/cadence/installs/DDI221/INNOVUS221
export XCELHOME=/home/dtvt_07/cadence/installs/XCELIUM2509

export LM_LICENSE_FILE=5280@192.168.32.10
export CDS_LIC_FILE=$LM_LICENSE_FILE

export PATH=$GENHOME/bin:$INNHOME/bin:$XCELHOME/bin:$PATH
echo "[INFO] Cadence Genus / Innovus / Xcelium environment loaded successfully."
