# Makefile for Cadence Genus Synthesis Flow
# Target Design: timer_top (Timer IP)

DESIGN       = timer_top
SCRIPT_DIR   = scripts
REPORT_DIR   = reports
OUTPUT_DIR   = outputs
SYNTH_SCRIPT = $(SCRIPT_DIR)/run_synth.tcl
VIEW_SCRIPT  = $(SCRIPT_DIR)/view_netlist.tcl

.PHONY: all synth gui view open_gui clean clean_all help

all: synth

# 1. Run batch synthesis (Command-line only, tự động thoát khi xong)
synth:
	@mkdir -p $(REPORT_DIR) $(OUTPUT_DIR)
	@echo "=================================================="
	@echo " Running Cadence Genus Synthesis for $(DESIGN)... "
	@echo "=================================================="
	genus -batch -files $(SYNTH_SCRIPT) -log $(REPORT_DIR)/genus_synth.log

# 2. Run synthesis and keep GUI open (Tổng hợp từ đầu và giữ nguyên cửa sổ GUI)
gui:
	@mkdir -p $(REPORT_DIR) $(OUTPUT_DIR)
	@echo "=================================================="
	@echo " Launching Genus GUI with $(DESIGN)...            "
	@echo "=================================================="
	genus -gui -files $(SYNTH_SCRIPT) -log $(REPORT_DIR)/genus_gui.log

# 3. View already synthesized netlist in GUI (MỞ NGAY LẬP TỨC MÀ KHÔNG CẦN TỔNG HỢP LẠI)
view:
	@mkdir -p $(REPORT_DIR) $(OUTPUT_DIR)
	@echo "=================================================="
	@echo " Opening Synthesized Netlist in Genus GUI...      "
	@echo "=================================================="
	genus -gui -files $(VIEW_SCRIPT) -log $(REPORT_DIR)/genus_view.log

# 4. Just open empty Genus GUI (Chỉ mở giao diện Genus trống)
open_gui:
	genus -gui

# Clean temporary run files
clean:
	@rm -rf genus.cmd* genus.log* fv .st_launch_* genus_temp_*
	@echo "Cleaned Genus run logs and temporary directories."

# Clean all outputs and reports
clean_all: clean
	@rm -rf $(REPORT_DIR)/* $(OUTPUT_DIR)/*
	@echo "Cleaned all reports and synthesis outputs."

help:
	@echo "Usage:"
	@echo "  make synth     : Chạy tổng hợp chế độ dòng lệnh (batch mode)"
	@echo "  make gui       : Chạy lại tổng hợp từ đầu và giữ nguyên cửa sổ GUI"
	@echo "  make view      : MỞ NGAY netlist đã tổng hợp lên GUI (nhanh, không cần tổng hợp lại)"
	@echo "  make open_gui  : Chỉ khởi động phần mềm Genus ở chế độ GUI trống"
	@echo "  make clean     : Xóa file tạm và log chạy"
	@echo "  make clean_all : Xóa toàn bộ file kết quả và báo cáo"
